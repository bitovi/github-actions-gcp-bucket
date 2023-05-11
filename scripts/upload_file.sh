#!/bin/bash
# shellcheck disable=SC1091,SC2086

# Env Vars from the Action:
# BUCKET_NAME: ${{ inputs.bucket_name }}
# FILE_NAME: ${{ inputs.file_name }}
# NO_CLOBBER: ${{ inputs.no_clobber }}

## Expected Behavior:
## if the file was skipped, the return is the skipped message.
## if the file was not skipped, the return is the url of the uploaded file.

source $GITHUB_ACTION_PATH/scripts/bucket_helpers.sh

# create an array of existing buckets
bucketList=($(get_bucket_list))

# create the bucket if it doesn't exist
if [[ ! " ${bucketList[*]} " =~ " $BUCKET_NAME "  ]]; then
  echo "Creating Bucket: $BUCKET_NAME"
  create_bucket $BUCKET_NAME
fi

# engage!
result=$(upload_files $BUCKET_NAME $FILE_NAME $NO_CLOBBER)

# if a file was skipped, the output will be something like:
# Uploading your file!
# Copying file://Bitovi_DevOps_Team_Pillars.md to gs://bitovi-test-action-bucket/Bitovi_DevOps_Team_Pillars.md
# Skipping existing destination item (no-clobber): gs://bitovi-test-action-bucket/Bitovi_DevOps_Team_Pillars.md
if [[ $result =~ 'Skipping' ]]; then
  echo "$FILE_NAME already exists in $BUCKET_NAME, skipped."
  echo $result
  exit
fi

#TODO: print public URL of uploaded file(s)
file_url=$(get_file_public_url $BUCKET_NAME $FILE_NAME)

# return the url
echo $file_url
