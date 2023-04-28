#!/bin/bash

curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-428.0.0-linux-x86_64.tar.gz
ls
tar -xf google-cloud-cli-428.0.0-linux-x86.tar.gz
./google-cloud-sdk/install.sh --quiet
./google-cloud-sdk/bin/gcloud init