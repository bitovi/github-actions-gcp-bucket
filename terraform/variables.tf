# uses env var TF_VAR_GCP_PROJECT_ID
variable "GCP_PROJECT_ID" {}

variable "file_name" {
  required = true
  default  = ""
}

variable "file_source" {
  required = true
  default  = ""
}
