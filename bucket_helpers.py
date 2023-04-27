#!/bin/python3

### environment setup:
#### python3 -m venv gcp-action
#### source gcp-action/bin/activate
#### pip install -r requirements.txt

# Imports the Google Cloud client library
from google.cloud import storage

# Instantiates a client
storage_client = storage.Client()

def create_bucket(bucketNames):
  """Creates one or more buckets in GCP Storage."""

  # convert bucket_names to a list if it's a single string
  if isinstance(bucketNames, str):
    bucketNames = [bucketNames]

  # Creates the new bucket/s and makes public
  for bucket_name in bucketNames:
    bucket = storage_client.bucket(bucket_name)
    bucket.storage_class = "STANDARD"
    bucket.location = "US"
    bucket.create()
    
    # make it publicly accessible
    policy = bucket.get_iam_policy()
    policy.bindings.append({
        "role": "roles/storage.objectViewer",
        "members": {"allUsers"},
    })
    bucket.set_iam_policy(policy)

    print(f"Bucket {bucket.name} created.")

def get_buckets():
  """Returns a list of bucket names."""
  
  bucket_names = []
  for bucket in storage_client.list_buckets():
    bucket_names.append(bucket.name)
  return bucket_names

def delete_bucket(bucketNames):
  """Deletes one or more buckets."""
  
  # if a string is passed in, convert to array
  if isinstance(bucketNames, str):
    bucketNames = [bucketNames]

  # iterate and delete
  for bucket_name in bucketNames:
    bucket = storage_client.bucket(bucket_name)
    bucket.delete(force=True)
    print(f"Bucket {bucket_name} deleted.")
    
from google.cloud import storage


def upload_file(bucket_name, source_file_name):
  """Uploads a file to the bucket."""
  
  import glob
  files = glob.glob(source_file_name, recursive=True)
  file_list = []
  for file in files:
    file_list.append(file)
    
  bucket = storage_client.bucket(bucket_name)
  
  for file in file_list:
    blob = bucket.blob(file)
    blob.upload_from_filename(file)
    print(f"File {file} uploaded to {bucket_name}/{file}.")


def bucket_metadata(bucket_name):
  """returns a bucket's metadata."""
  bucket = storage_client.get_bucket(bucket_name)
  return bucket


def file_metadata(bucket_name, file_name):
  """Prints out a blob's metadata."""

  bucket = storage_client.bucket(bucket_name)
  blobs  = storage_client.list_blobs(bucket_name)
  
  for blob in blobs:
    print(blob.name)
    blobMetadata = bucket.get_blob(blob.name)
    print(f"{blobMetadata.media_link}")