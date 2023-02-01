# uses env var TF_VAR_GCP_PROJECT_ID
variable "GCP_PROJECT_ID" {}

# name and source require setting either in a local .tfvars file,
# or programatically
variable "file_name" {}

variable "file_source" {}

variable "bucket_domain" {
  default = "https://storage.googleapis.com"
}
