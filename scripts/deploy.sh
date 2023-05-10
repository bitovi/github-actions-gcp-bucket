#!/bin/bash
# shellcheck disable=2086

echo 'Uploading your file!'
url=$($GITHUB_ACTION_PATH/scripts/upload_file.sh)
echo "FILE_URL='$url'" >> $GITHUB_OUTPUT
echo $GITHUB_OUTPUT
