#!/usr/bin/env bats
# shellcheck disable=SC2086
bats_require_minimum_version 1.5.0

load 'bucket_helpers.sh'

setup() {
  TEST_BUCKET="test-bucket-$RANDOM"
  BUCKET_DELETED=false
}

teardown() {
  # Check if the bucket exists and BUCKET_DELETED is false
  bucket_exists="$(gcloud storage buckets list --filter="name=$TEST_BUCKET" --format="json(name)")"
  
  if [[ -n "$bucket_exists" && "$BUCKET_DELETED" == "false" ]]; then
    delete_buckets $TEST_BUCKET
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
  echo "$result" | grep -q "$TEST_BUCKET"
}

@test "get_bucket_list returns a list of bucket names" {
  create_bucket $TEST_BUCKET
  result="$(get_bucket_list)"
  echo "$result" | grep -q "$TEST_BUCKET"
}

@test "upload_files uploads a file to a bucket" {
  create_bucket $TEST_BUCKET
  echo "test content" > testfile.txt
  upload_files $TEST_BUCKET testfile.txt
  gcloud storage ls gs://$TEST_BUCKET | grep -q "testfile.txt"
  rm testfile.txt
}

@test "delete_buckets deletes specified buckets" {
  create_bucket $TEST_BUCKET
  delete_buckets $TEST_BUCKET
  BUCKET_DELETED=true
  run ! grep -q "$TEST_BUCKET" <(get_bucket_list)
  [[ $status -ne 0 ]]
}

@test "get_file_metadata returns file metadata in YAML format" {
  create_bucket $TEST_BUCKET
  echo "test content" > testfile.txt
  upload_files $TEST_BUCKET testfile.txt
  result="$(get_file_metadata $TEST_BUCKET testfile.txt)"
  echo "$result" | grep -q "name: testfile.txt"
  rm testfile.txt
}

@test "get_file_public_url returns the public URL for a file" {
  create_bucket $TEST_BUCKET
  echo "test content" > testfile.txt
  upload_files $TEST_BUCKET testfile.txt
  result="$(get_file_public_url $TEST_BUCKET testfile.txt)"
  [ "$result" == "https://storage.googleapis.com/$TEST_BUCKET/testfile.txt" ]
  rm testfile.txt
}


