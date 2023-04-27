from os import getenv
from bucket_helpers import delete_bucket
from dotenv import load_dotenv

# reads the .env file into env vars
load_dotenv()

# set bucket name
buckets = getenv("BUCKET_NAME")

# delete the bucket
delete_bucket(buckets)
