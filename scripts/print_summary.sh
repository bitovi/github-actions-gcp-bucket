#!/bin/bash
# shellcheck disable=2086

# Behavior:
# Prints the summary of the run to the GITHUB_STEP_SUMMARY path.

case $DEPLOY_STATUS in

  SKIPPED)
    echo "### $DEPLOY_RESULT_CONTENT " >> $GITHUB_STEP_SUMMARY
    ;;

  DESTROYED)
    echo "### Your bucket '$BUCKET_NAME' was _destroyed_! :bomb:" >> $GITHUB_STEP_SUMMARY
    ;;

  OK)
    echo "### Your file was uploaded! :tada:" >> $GITHUB_STEP_SUMMARY
    echo "" >> $GITHUB_STEP_SUMMARY
    echo "Your file's URL: $FILE_URL" >> $GITHUB_STEP_SUMMARY
    ;;
  
  *)
    echo "### Something went wrong. Please review the logs." >> $GITHUB_STEP_SUMMARY
    ;;
esac
