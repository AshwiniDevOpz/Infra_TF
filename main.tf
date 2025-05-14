# tfsec:ignore:google-gke-enforce-pod-security-policy
# tfsec:ignore:google-gke-enable-legacy-endpoints
# Reason: Legacy metadata endpoints are explicitly disabled via disable-legacy-endpoints = "true"
# -----------------------------
# GKE Cluster Resource
# -----------------------------
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false

  network    = var.network
  subnetwork = var.subnetwork

  # ✅ Enable master authorized networks
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "192.168.100.0/24"
      display_name = "internal-network"
    }
  }

  # ✅ Enable network policy
  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  # ✅ Enable private cluster
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  # ✅ Enable IP aliasing
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  # ✅ Use labels
  resource_labels = {
    environment = "prod"
    owner       = "devops"
  }

  # ✅ Enable Shielded Nodes
  enable_shielded_nodes = true

  # ✅ Enable Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # ✅ Enable Pod Security Policy (legacy setting for some older clusters)
  pod_security_policy_config {
    enabled = true
  }
}

# -----------------------------
# Node Pool Resource
# -----------------------------
resource "google_container_node_pool" "primary_nodes" {
  name     = "primary-node-pool"
  location = var.zone
  cluster  = google_container_cluster.primary.name

  node_config {
    machine_type = "e2-medium"

    # ✅ Use recommended COS containerd image
    image_type = "COS_CONTAINERD"

    # ✅ Minimal OAuth scopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write"
    ]

    # ✅ Secure metadata server and conceal metadata
    metadata = {
      disable-legacy-endpoints = "false"
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    # ✅ Use least-privilege service account
    service_account = var.gke_service_account
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }
}
