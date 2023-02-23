resource "google_compute_subnetwork" "default-subnet" {
  name = var.subnet-name
  ip_cidr_range = var.cidr-ip
  region = var.region-of-subnet
  network = var.vpc-link
  secondary_ip_range {
    range_name    = var.first-secondary-ip-range-name
    ip_cidr_range = var.first-secondary-ip-range-ip
  }
  secondary_ip_range {
    range_name    = var.second-secondary-ip-range-name
    ip_cidr_range = var.second-secondary-ip-range-ip
  }
}