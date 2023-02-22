output "vpc-link" {
  value = google_compute_network.vpc_network.self_link
}

output "id-of-vpc" {
  value = google_compute_network.vpc_network.id
}