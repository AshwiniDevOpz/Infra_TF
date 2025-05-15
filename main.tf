resource "google_container_cluster" "primary_cluster" {
  name     = var.cluster_names
  location = var.zones

  remove_default_node_pool = true
  initial_node_count       = 1

  network             = "default"
  subnetwork          = "default"
  deletion_protection = false

  # ✅ Pod security policy is deprecated. Remove this block.
  # pod_security_policy_config {
  #   enabled = true
  # }

  # ✅ Fix: master_authorized_networks_config uses block type `cidr_blocks`
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.0.0/8"
      display_name = "Private Network"
    }
  }

  # ✅ Remove `metadata` block — it's invalid. Instead, set this under `node_config` in the node pool.
  # metadata {
  #   disable_legacy_endpoints = true
  # }

  # ✅ Network policy
  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  # ✅ Private cluster config
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  # ✅ Fix: ip_allocation_policy is a block with no arguments directly under it — no `use_ip_aliases`
  ip_allocation_policy {}

  resource_labels = {
    environment = "prod"
    team        = "devops"
  }
}
resource "google_container_node_pool" "primary_nodes" {
  name     = "primary-node-pool"
  location = var.zones
  cluster  = google_container_cluster.primary_cluster.name

  node_config {
    machine_type = "e2-medium"

    # You can set a service account here if you have one:
    # service_account = var.service_account_email

    metadata = {
      "disable-legacy-endpoints" = "true"
    }

    image_type = "COS_CONTAINERD"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  initial_node_count = 2

  management {
    auto_upgrade = true
    auto_repair  = true
  }
}