#!/bin/bash
# shellcheck disable=2086


## Behavior:
## Runs the upload_file script
## Is the result is successful, it returns the URL of the uploaded file.
##  and sets the the status to OK.
## If the upload_file fails, it returns the string output from the gcloud cli 
##  and sets the the status to SKIPPED.

echo 'Uploading your file!'
result=$($GITHUB_ACTION_PATH/scripts/upload_file.sh)

if [[ $result =~ 'Skipping'  ]]; then
  echo "DEPLOY_RESULT_CONTENT=$result" >> $GITHUB_OUTPUT
  echo "DEPLOY_STATUS=SKIPPED" >> $GITHUB_OUTPUT
else
  echo "FILE_URL=$result" >> $GITHUB_OUTPUT
  echo "DEPLOY_STATUS=OK" >> $GITHUB_OUTPUT
fi
