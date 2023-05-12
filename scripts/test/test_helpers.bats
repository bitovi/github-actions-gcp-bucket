#!/usr/bin/env bats
# shellcheck disable=SC2086
bats_require_minimum_version 1.5.0

load '../bucket_helpers.sh'

TESTFILE='testfile.txt'

setup() {
  TEST_BUCKET="test-bucket-$RANDOM"
  BUCKET_DELETED=false
}

# Check if the bucket exists and BUCKET_DELETED is false
teardown() {
  bucket_exists="$(gsutil ls | grep $TEST_BUCKET)"

  if [[ -n "$bucket_exists" && "$BUCKET_DELETED" == "false" ]]; then
    delete_buckets $TEST_BUCKET
  fi

  if [[ -f $TESTFILE ]]; then
    rm -f $TESTFILE
  fi
}

@test "create_bucket creates a new bucket and makes it publicly accessible" {
  create_bucket $TEST_BUCKET
  result="$(gcloud storage buckets get-iam-policy gs://$TEST_BUCKET --format='json(bindings)')"
  echo "$result" | grep -q "allUsers"
  echo "$result" | grep -q "roles/storage.objectViewer"
}

@test "list_buckets returns a list of buckets in JSON format" {
  create_bucket $TEST_BUCKET
  result="$(list_buckets)"
  echo "$result" | grep -q "\"name\": \"$TEST_BUCKET\""
}

@test "get_bucket_list returns a list of bucket names" {
  create_bucket $TEST_BUCKET
  result="$(get_bucket_list)"
  echo "$result" | grep -q "$TEST_BUCKET"
}

@test "upload_files with NO_CLOBBER uploads without overwriting" {
  # $3 in upload_files is 'no_clobber'

  echo "test content" > $TESTFILE
  create_bucket $TEST_BUCKET
  upload_files $TEST_BUCKET $TESTFILE

  echo "updated content" > $TESTFILE
  upload_files $TEST_BUCKET $TESTFILE true

  file_count="$(gcloud storage ls gs://$TEST_BUCKET | grep -c "$TESTFILE")"
  [ "$file_count" -eq 1 ]

  file_content="$(gcloud storage cat gs://$TEST_BUCKET/$TESTFILE)"
  [ "$file_content" == "test content" ]
}

@test "upload_files uploads a file to a bucket with overwriting" {
  # $3 in upload_files is 'no_clobber'

  echo "test content" > $TESTFILE
  create_bucket $TEST_BUCKET
  upload_files $TEST_BUCKET $TESTFILE

  echo "updated content" > $TESTFILE
  upload_files $TEST_BUCKET $TESTFILE false

  file_count="$(gcloud storage ls gs://$TEST_BUCKET | grep -c "$TESTFILE")"
  [ "$file_count" -eq 1 ]

  file_content="$(gcloud storage cat gs://$TEST_BUCKET/$TESTFILE)"
  [ "$file_content" == "updated content" ]
}

@test "delete_buckets deletes specified buckets" {
  # Create two test buckets
  create_bucket "${TEST_BUCKET}-1"
  create_bucket "${TEST_BUCKET}-2"

  bucket_list="$(get_bucket_list)"
  [[ $bucket_list =~ "${TEST_BUCKET}-1" ]]
  [[ $bucket_list =~ "${TEST_BUCKET}-2" ]]

  # Delete the buckets using the delete_buckets function
  delete_buckets "${TEST_BUCKET}-1"

  # Check that the bucket no longer exists
  bucket_list="$(get_bucket_list)"
  [[ ! $bucket_list =~ "${TEST_BUCKET}-1" ]]
  [[ $bucket_list =~ "${TEST_BUCKET}-2" ]]

  delete_buckets "${TEST_BUCKET}-2"

  # Check that the bucket no longer exists
  bucket_list="$(get_bucket_list)"
  [[ ! $bucket_list =~ "${TEST_BUCKET}-1" ]]
  [[ ! $bucket_list =~ "${TEST_BUCKET}-2" ]]
}

@test "get_file_metadata returns file metadata in YAML format" {
  create_bucket $TEST_BUCKET
  echo "test content" > $TESTFILE
  upload_files $TEST_BUCKET $TESTFILE false
  result="$(get_file_metadata $TEST_BUCKET $TESTFILE)"
  echo "$result" | grep -q "name: $TESTFILE"
  rm $TESTFILE
}

@test "get_file_public_url returns the public URL for a file" {
  create_bucket $TEST_BUCKET
  echo "test content" > $TESTFILE
  upload_files $TEST_BUCKET $TESTFILE false
  result="$(get_file_public_url $TEST_BUCKET $TESTFILE)"
  [ "$result" == "https://storage.googleapis.com/$TEST_BUCKET/$TESTFILE" ]
  rm $TESTFILE
}
