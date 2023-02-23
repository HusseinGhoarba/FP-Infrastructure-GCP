output "region-of-subnet" {
  value = google_compute_subnetwork.default-subnet.region
}

output "id-of-subnet" {
  value = google_compute_subnetwork.default-subnet.id
}

output "ip-range" {
  value = google_compute_subnetwork.default-subnet.ip_cidr_range
}