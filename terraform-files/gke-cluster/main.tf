#-------------------------------Creating -private- GKE -cluster- on restricted subnet
resource "google_container_cluster" "default-cluster" {
  name     = var.cluster-name
  location = var.cluster-zone
  #-----------------------------------------------  
  remove_default_node_pool = var.remove-default-node-pool
  initial_node_count       = var.initial-node-count
  network                  = var.vpc-id-for-cluster
  subnetwork               = var.subnet-id-for-cluster
  #-----------------------------------------------
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.master-cidr-ip-block
      display_name = var.master-name-config
    }
  }
  #-----------------------------------------------
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.16.0.0/16"
    services_ipv4_cidr_block = "10.12.0.0/16"
  }
  #-----------------------------------------------
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
  #-----------------------------------------------
  addons_config {
    http_load_balancing {
      disabled = true
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
  node_config {
    preemptible  = true
    machine_type = var.machine-type-of-node
    #-------------------------------service account
    service_account = var.email-of-sa-for-node
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}