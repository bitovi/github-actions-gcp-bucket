#!/bin/bash
# shellcheck disable=SC1091,SC2086

function create_bucket() {
  bucket_name=$1

  gcloud storage buckets create gs://$bucket_name --no-public-access-prevention --uniform-bucket-level-access

  if [[ $? != 0 ]]; then
    echo "failed: create_bucket"
  else
    echo "done"
  fi
}

function list_buckets() {
  gcloud storage buckets list | yq .name
}

function upload_files() {
  files=$1

  gcloud storage cp $files
}

function delete_bucket() {
  #TODO: support a list
  # gcloud storage buckets delete gs://my-bucket gs://my-other-bucket
  bucket_name=$1

  gcloud storage buckets delete gs://$bucket_name
}
