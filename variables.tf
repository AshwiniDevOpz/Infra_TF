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
  type    = string
  default = "default"
}

variable "subnetwork" {
  type    = string
  default = "default"
}

variable "gke_service_account" {
  type    = string
  default = "gke-node-sa@digidense-learning-platform.iam.gserviceaccount.com" # Provide a secure SA with minimal GKE access

}