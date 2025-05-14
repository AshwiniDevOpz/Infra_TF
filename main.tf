# ✅ GKE Service Account
resource "google_service_account" "gke_sa" {
  account_id   = "gke-node-sa"
  display_name = "GKE Node Service Account"
}

# ✅ IAM Bindings for GKE Node Service Account
resource "google_project_iam_member" "gke_sa_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

resource "google_project_iam_member" "gke_sa_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

resource "google_project_iam_member" "gke_sa_viewer" {
  project = var.project_id
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

# ✅ GKE Cluster (Updated)
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network
  subnetwork = var.subnetwork

  # ✅ Master authorized networks
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "192.168.100.0/24"
      display_name = "internal-network"
    }
  }

  # ✅ Network policy
  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  # ✅ Private cluster
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  # ✅ IP aliasing (correct nesting)
  ip_allocation_policy {}

  # ✅ Labels
  resource_labels = {
    environment = "prod"
    owner       = "devops"
  }
}

# ✅ Node pool
resource "google_container_node_pool" "primary_nodes" {
  name     = "primary-node-pool"
  location = var.zone
  cluster  = google_container_cluster.primary.name

  node_config {
    machine_type = "e2-medium"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write"
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    service_account = google_service_account.gke_sa.email
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }
}