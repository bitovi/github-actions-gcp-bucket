[![Unit Test](https://github.com/bitovi/github-actions-gcp-bucket/actions/workflows/bats_test.yaml/badge.svg?branch=main)](https://github.com/bitovi/github-actions-gcp-bucket/actions/workflows/bats_test.yaml)

# GitHub Action: Upload To Public GCP Bucket

This Action will upload files from your repo directly into a Google Storage Bucket.

**By default, this bucket and all the files in it are public to the internet.**

Don't upload anything you don't want exposed publicly.

A future enhancement will support setting privacy options on your files.

# Need help or have questions?

This project is supported by [Bitovi, a DevOps Consultancy](https://www.bitovi.com/devops-consulting) and a proud supporter of Open Source software.

You can [get help or ask questions on our Discord channel!](https://discord.gg/J7ejFsZnJ4) Come hang out with us!

Or, you can hire us for training, consulting, or development. [Set up a free consultation.](https://www.bitovi.com/devops-consulting)

## Configuration

### Create and Upload

To install this Action, ceate a workflow in your repos's `.github/workflows` folder:

You must set three environment variables/secrets:

- `GOOGLE_CREDENTIALS`: set as a `secret`. This is the JSON file exported as a credential from your Google Cloud account.
- `BUCKET_NAME`: set as a `variable`, or set statically in your workflow file.
- `FILE_NAME`: set as a `variable`, or set statically in your workflow file. Supports wildcards.

```yaml
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

### Delete The Bucket

To delete the bucket you've created, add the `bucket_destroy` input.

The `FILE_NAME` input is removed in this example, because it's not needed; it'll have no effect if left in.

```yaml
name: GCP Bucket Destroy
on: workflow_dispatch       # set the triggers to your liking
#   push:
#     branches: [ main ]

jobs:
  Bucket-Deploy:
    runs-on: 'ubuntu-latest'
    steps:
      - id: 'destroy'
        uses: 'bitovi/github-actions-gcp-bucket'
        with:
          gcp_access_key: ${{ secrets.GOOGLE_CREDENTIALS }}
          bucket_name: ${{ vars.BUCKET_NAME }}
          bucket_destroy: true
```

## Output

The Action will output the URL to the publicly accessable file.

## Usage

### Manual Operation

You can use the two examples above to create and destroy your bucket on demand.

Create two separate workflow files in `.github/workflows` and leave the trigger set to `workflow_dispatch`.

Run the action when desired by going to the Actions tab in your repo and running the action.

> Note: the path `.github/workflows` is specific and required for the Actions (workflows) to function.

### Automated/GitOps

GitHub Actions really shine when they are automatically triggered by other events in the repository.

Set your action's trigger to run on any push to main:

```yaml
name: GCP Bucket Deploy
on: 
  push:
    branches: [ main ]
```

So your push to `main` will trigger the deploy. If you want to destroy the bucket, update the workflow file per the `destroy` example above, and commit it in. This will trigger the workflow, resulting in the bucket (and all its files) being destroyed.

This is sometimes referred to as "GitOps", because the actions in GitHub are defining the state of your infrastructure.

## To Do

1. enable Google OIDC auth
1. support folders
1. toggle destructive/non-destructive (no-clobber) uploads
1. default folder name (using existing folder name mechanism)
1. Support non-public creation

<!-- markdownlint-disable-file MD041 -->
