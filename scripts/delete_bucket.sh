#!/bin/bash
# shellcheck disable=SC1091,SC2086

source $GITHUB_ACTION_PATH/scripts/bucket_helpers.sh

delete_buckets $BUCKET_NAME
