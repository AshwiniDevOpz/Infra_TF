# -----------------------------
# Variables
# -----------------------------
variable "project_ids" {
  type        = string
  description = "The GCP project ID"
  default     = "digidense-learning-platform"
}

variable "regions" {
  type    = string
  default = "us-central1"
}

variable "zones" {
  type    = string
  default = "us-central1-c"
}

variable "cluster_names" {
  type    = string
  default = "cluster-01"
}

variable "service-account-email" {
  type    = string
  default = "digidense-access@digidense-learning-platform.iam.gserviceaccount.com"
}
