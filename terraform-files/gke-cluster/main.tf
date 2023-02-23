#-------------------------------Creating -private- GKE -cluster- on restricted subnet
resource "google_container_cluster" "default-cluster" {
  name                     = var.cluster-name
  location                 = var.cluster-zone
  remove_default_node_pool = var.remove-default-node-pool
  initial_node_count       = 1
  network                  = var.vpc-id-for-cluster
  subnetwork               = var.subnet-id-for-cluster
  networking_mode          = "VPC_NATIVE"
  
  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = var.work-load
  }
  
  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pods"
    services_secondary_range_name = "k8s-services"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
  master_authorized_networks_config {
  cidr_blocks {
    cidr_block = var.manage-subnet-ip-range
    display_name = var.master-name-config
  }
}
}

#---------------Creation of NODE Pool and attach it to Cluster
resource "google_container_node_pool" "nodepool" {
  name       = var.name-of-node
  location   = var.location-of-node
  cluster    = google_container_cluster.default-cluster.id
  node_count = var.count-of-node
  #-----------------------------------------------
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  node_config {
    preemptible  = false
    machine_type = var.machine-type-of-node
    #-------------------------------service account
    service_account = var.email-of-sa-for-node
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}