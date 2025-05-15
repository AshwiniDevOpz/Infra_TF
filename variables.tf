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

variable "network" {
  default = "default"
}
variable "subnetwork" {
  default = "default"
}
variable "release_channel" {
  default = "REGULAR"
}
variable "node_locations" {
  type    = list(string)
  default = []
}
variable "node_count" {
  default = 2
}
variable "machine_type" {
  default = "e2-medium"
}
variable "oauth_scopes" {
  type    = list(string)
  default = ["https://www.googleapis.com/auth/cloud-platform"]
}
variable "service_account_email" {
  description = "Service account for node pool"
  default     = "awsdevopsdd@gmail.com"
}
