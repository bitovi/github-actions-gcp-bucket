output "bucket_name" {
  value = google_storage_bucket.default.name
}

output "bucket_id" {
  value = google_storage_bucket.default.id
}

output "file_url" {
  value = google_storage_bucket_object.default.media_link
}