#!/bin/bash
# shellcheck disable=SC1091,SC2086

function create_bucket() {
  # creates a PUBLICLY ACCESSABLE bucket
  local bucket=$1

  # create the bucket
  gcloud storage buckets create gs://$bucket --no-public-access-prevention
  
  if [[ $? != 0 ]]; then
    echo "failed: create_bucket"
    exit
  fi

  # make it publicly accessable
  gcloud storage buckets add-iam-policy-binding gs://$bucket \
    --member=allUsers \
    --role=roles/storage.objectViewer \
    --no-user-output-enabled

  if [[ $? != 0 ]]; then
    echo "failed: add-iam-policy-binding"
  fi
}

function list_buckets() {
  # outputs a json object
  gcloud storage buckets list --format="json(name)"
}

function get_bucket_list() {
  # returns a list with the output
  local bucket_list=($(list_buckets | jq -r ".[].name"))
  printf '%s\n' "${bucket_list[@]}"
}

function upload_files() {
  # upload one or more files to a bucket
  #TODO: support lists of files
  local bucket_name=$1
  local files=$2

  gcloud storage cp $files gs://$bucket_name
}

function delete_buckets() {
  # deletes one or more buckets at once
  # takes the input as an array
  local bucket_list=( "$@" )

  local BUCKET_URL_STRING=

  # create a list of bucket URLs
  for b in "${bucket_list[@]}"; do
    local BUCKETNAME="gs://$b"
    BUCKET_URL_STRING+="$BUCKETNAME "
  done

  # trim the trailing space
  BUCKET_URL_STRING="${BUCKET_URL_STRING%% }"

  # this deletes the entire contents of the bucket, then the bucket itself
  # using a list enables multiple deletes in one call
  eval "gcloud storage rm -r $BUCKET_URL_STRING"
}

function get_file_metadata() {
  # returns a yaml string of the whole metadata
  local bucket_name=$1
  local file_name=$2

  local file_metadata
  file_metadata=$(gcloud storage objects describe gs://$bucket_name/$file_name)

  echo $file_metadata
}

function get_file_public_url() {
  # returns the composed public url
  GOOGLE_BUCKET_PREFIX='https://storage.googleapis.com'

  local bucket_name=$1
  local file_name=$2
  # local file_yaml
  local file_url
  
  # file_yaml=$(get_file_metadata $bucket_name $file_name)
  # file_url=$(echo $file_yaml | yq "\"$GOOGLE_BUCKET_PREFIX\" + .bucket + \"/\" + .name")
  file_url="$GOOGLE_BUCKET_PREFIX/$bucket_name/$file_name"
  echo $file_url
}
