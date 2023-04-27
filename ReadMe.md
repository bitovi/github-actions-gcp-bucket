# Auth Options

## With Service Account Key JSON

1. Create a Google Cloud service account and grant IAM permissions
1. Export the long-lived JSON service account key
1. Upload the JSON service account key to a GitHub secret

## With Workload Identity Federation

1. Create a Google Cloud service account and grant IAM permissions
1. Create and configure a Workload Identity Provider for GitHub
1. Exchange the GitHub Actions OIDC token for a short-lived Google Cloud access token
