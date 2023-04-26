#!/bin/bash

source "./.env"

gcloud storage buckets create "gs://$BUCKET_NAME" --no-public-access-prevention --uniform-bucket-level-access