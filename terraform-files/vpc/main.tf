resource "google_compute_network" "vpc_network" {
  name = var.name-of-vpc
  auto_create_subnetworks = var.checking-auto-create-subnets
}

resource "google_compute_firewall" "IAP-firewall" {
  name    = var.firewall-name
  network = google_compute_network.vpc_network.id
  priority = var.priority-of-firewall
  direction     = var.type-of-direction
  source_ranges = var.allowed-ip
  allow {
    protocol = var.protocol-allowed
    ports    = var.ports-allowed
  }
}   