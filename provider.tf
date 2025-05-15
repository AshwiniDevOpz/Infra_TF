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

provider "kubernetes" {
  config_path = "~/.kube/config" # or use a proper config block to access your cluster
}

resource "kubernetes_namespace" "default" {
  metadata {
    name = "default"

    labels = {
      "pod-security.kubernetes.io/enforce"         = "baseline"
      "pod-security.kubernetes.io/enforce-version" = "v1.24"
    }
  }
}
