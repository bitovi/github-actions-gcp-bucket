resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  project       = var.GCP_PROJECT_ID
  name          = "${random_id.bucket_prefix.hex}-bucket-static-site"
  force_destroy = true
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

# Make bucket public
resource "google_storage_bucket_iam_member" "member" {
  provider = google-beta
  bucket   = google_storage_bucket.default.name
  role     = "roles/storage.objectViewer"
  member   = "allUsers"
}
