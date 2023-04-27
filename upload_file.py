import bucket_helpers
from os import getenv
from dotenv import load_dotenv

# reads the .env file into env vars
load_dotenv()

# set the vars
bucket_name = getenv("BUCKET_NAME")
file_name = getenv("FILE_LIST")

# get list of existing buckets
bucket_list = bucket_helpers.get_buckets()

# if not exist, create
if bucket_name not in bucket_list:
  bucket_helpers.create_bucket(bucket_name)

bucket_helpers.upload_file(bucket_name, file_name)
