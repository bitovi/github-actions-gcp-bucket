#!/bin/bash
# shellcheck disable=SC1091,SC2086

# source "./.env"
source $GITHUB_ACTION_PATH/scripts/bucket_helpers.sh

# create an array of existing buckets
bucketList=($(get_bucket_list))

# create the bucket if it doesn't exist
if [[ ! " ${bucketList[*]} " =~ " $BUCKET_NAME "  ]]; then
  echo "Creating Bucket: $BUCKET_NAME"
  create_bucket $BUCKET_NAME
fi

# engage!
upload_files $BUCKET_NAME $FILE_NAME

#TODO: print public URL of uploaded file(s)
file_url=$(get_file_public_url $BUCKET_NAME $FILE_NAME)

# return the url
echo $file_url
