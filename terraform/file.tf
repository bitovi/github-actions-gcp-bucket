# Upload files
# Discussion about using tf to upload a large number of objects
# https://stackoverflow.com/questions/68455132/terraform-copy-multiple-files-to-bucket-at-the-same-time-bucket-creation

# The text object in Cloud Storage
resource "google_storage_bucket_object" "default" {
  name         = var.file_name
  source       = var.file_source
  content_type = "text/html"
  bucket       = google_storage_bucket.default.id
}
