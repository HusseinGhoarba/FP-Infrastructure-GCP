resource "google_compute_instance" "private-vm" {
  name         = var.vm-name
  machine_type = var.vm-type
  zone         = var.zone-of-vm
 
  boot_disk {
    initialize_params {
      image = var.image-of-vm
    }
  }

  metadata = {
  enable-oslogin = "TRUE"
  }

  network_interface {
    subnetwork = var.id-subnet-of-vm
  }

  service_account {
    email  = var.email-of-sa
    scopes = var.scopes-of-sa
  }

  metadata_startup_script = var.vm-script

}