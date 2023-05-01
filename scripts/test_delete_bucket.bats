#!/usr/bin/env bats
# shellcheck disable=SC2086,SC1091

bats_require_minimum_version 1.5.0

source ./bucket_helpers.sh

@test "deletes the specified bucket" {
  # Create a bucket for testing
  TEST_BUCKET="test-delete-bucket-$(date +%s)"
  create_bucket $TEST_BUCKET

  # Wait for the bucket creation process to complete
  sleep 5

  # Delete the created bucket
  delete_buckets $TEST_BUCKET

  # Check if the bucket is deleted
  bucket_list=($(get_bucket_list))
  [[ ! " ${bucket_list[*]} " =~ " $TEST_BUCKET " ]]
}
