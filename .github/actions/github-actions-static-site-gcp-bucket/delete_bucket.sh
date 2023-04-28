#!/bin/bash
# shellcheck disable=SC1091,SC2086

source "./.env"
source "./bucket_helpers.sh"

delete_buckets $BUCKET_NAME
