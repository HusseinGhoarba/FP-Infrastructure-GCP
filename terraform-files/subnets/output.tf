output "region-of-subnet" {
  value = google_compute_subnetwork.default-subnet.region
}

output "id-of-subnet" {
  value = google_compute_subnetwork.default-subnet.id
}