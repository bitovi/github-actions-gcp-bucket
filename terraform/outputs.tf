output "bucket_id" {
  value = google_storage_bucket.default.id
}

output "file_url" {
  value = "${var.bucket_domain}/${google_storage_bucket.default.id}/${var.file_name}"
}
