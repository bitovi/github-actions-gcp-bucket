# GitHub Action: Upload To Public GCP Bucket

This Action will upload files from your repo directly into a Google Storage Bucket. 

**By default, this bucket and all the files in it are public to the internet.**

Don't upload anything you don't want exposed publicly.

A future enhancement will support setting privacy options on your files.

## Output

The Action will output the URL to the publicly accessable file.

## Usage

To install this Action, ceate a workflow in your repos's `.github/workflows` folder:

You must set three environment variables/secrets:

- `GOOGLE_CREDENTIALS`: set as a `secret`. This is the JSON file exported as a credential from your Google Cloud account.
- `BUCKET_NAME`: set as a `variable`, or set statically in your workflow file.
- `FILE_NAME`: set as a `variable`, or set statically in your workflow file. Supports wildcards.

```sh
name: GCP Bucket Deploy
on: workflow_dispatch       # set the triggers to your liking
#   push:
#     branches: [ main ]

jobs:
  Bucket-Deploy:
    runs-on: 'ubuntu-latest'
    steps:
      - id: 'deploy'
        uses: 'bitovi/github-actions-gcp-bucket'
        with:
          gcp_access_key: ${{ secrets.GOOGLE_CREDENTIALS }}
          bucket_name: ${{ vars.BUCKET_NAME }}
          file_name: ${{ vars.FILE_NAME }}
```

## To Do

1. enable Google OIDC auth
1. support folders
1. toggle destructive/non-destructive (no-clobber) uploads
1. default folder name (using existing folder name mechanism)
1. Support non-public creation
