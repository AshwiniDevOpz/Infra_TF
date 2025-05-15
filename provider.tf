terraform {
  required_version = ">= 1.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.33.0"
    }
  }
}


provider "google" {
  project     = var.project_ids
  region      = var.regions
  credentials = "g-key.json"
}