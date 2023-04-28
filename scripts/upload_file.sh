#!/bin/bash
# shellcheck disable=SC1091,SC2086

set -x

# source "./.env"
source "bucket_helpers.sh"

# create an array of existing buckets
bucketList=($(get_bucket_list))

# create the bucket if it doesn't exist
if [[ ! " ${bucketList[*]} " =~ " $BUCKET_NAME "  ]]; then
  create_bucket $BUCKET_NAME
fi

# engage!
upload_files $BUCKET_NAME $FILE_NAME

#TODO: print public URL of uploaded file(s)
