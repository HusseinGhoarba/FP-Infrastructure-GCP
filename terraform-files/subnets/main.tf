resource "google_compute_subnetwork" "default-subnet" {
  name = var.subnet-name
  ip_cidr_range = var.cidr-ip
  region = var.region-of-subnet
  network = var.vpc-link
}