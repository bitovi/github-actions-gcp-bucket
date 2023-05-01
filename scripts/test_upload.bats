#!/usr/bin/env bats
# shellcheck disable=SC2086,SC1091

bats_require_minimum_version 1.5.0
source ./bucket_helpers.sh


setup() {
  TEST_BUCKET="test-upload-bucket-$RANDOM"
  FILE_NAME="test_file.txt"
  BUCKET_DELETED=false
  # Create a test file
  echo "Test content" > $FILE_NAME
}

teardown() {
  # Check if the bucket exists and BUCKET_DELETED is false
  bucket_exists="$(gcloud storage buckets list --filter="name=$TEST_BUCKET" --format="json(name)")"
  
  if [[ -n "$bucket_exists" && "$BUCKET_DELETED" == "false" ]]; then
    delete_buckets $TEST_BUCKET
  fi
  # Clean up the test file
  rm -f $FILE_NAME
}

@test "creates the bucket if it doesn't exist" {
  bucketList=($(get_bucket_list))
  if [[ ! " ${bucketList[*]} " =~ " $TEST_BUCKET " ]]; then
    create_bucket $TEST_BUCKET
  fi
  bucketList=($(get_bucket_list))
  [[ " ${bucketList[*]} " =~ " $TEST_BUCKET " ]]
}

@test "uploads the file successfully" {
  create_bucket $TEST_BUCKET
  sleep 5  # Add a short sleep to allow the bucket creation process to complete
  upload_files $TEST_BUCKET $FILE_NAME
  uploaded_files="$(gcloud storage ls gs://$TEST_BUCKET/)"
  [[ $uploaded_files == *"$FILE_NAME"* ]]
}

@test "returns the public URL of the uploaded file" {
  file_url=$(get_file_public_url $TEST_BUCKET $FILE_NAME)
  expected_url="https://storage.googleapis.com/$TEST_BUCKET/$FILE_NAME"
  [[ $file_url == "$expected_url" ]]
}
