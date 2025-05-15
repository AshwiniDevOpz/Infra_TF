# -----------------------------
# Variables
# -----------------------------
variable "project_id" {
  type        = string
  description = "The GCP project ID"
  default     = "digidense-learning-platform"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-c"
}

variable "cluster_name" {
  type    = string
  default = "my-gke-cluster"
}

