#--------------Create a router for the natgatewat
resource "google_compute_router" "nat-router" {
  name    = var.router-name
  region  = var.region-of-router
  network = var.network-of-router
}

#--------------Create NAT-Gateway
resource "google_compute_router_nat" "my-nat" {
  name                               = var.nat-name
  router                             = google_compute_router.nat-router.name
  region                             = google_compute_router.nat-router.region
  nat_ip_allocate_option             = var.allocate-ip-of-nat
  source_subnetwork_ip_ranges_to_nat = var.subnets-ip-ranges-of-nat-to-work
}

