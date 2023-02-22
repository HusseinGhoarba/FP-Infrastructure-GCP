#-----------Creation of ServiceAccount that the VM will use
module "VM-SA" {
  source = "./ServiceAccount"
  #------Create ServiceAccount:
  id-of-sa        = "vm-service-account"
  name-in-display = "vm-service-account"
  #------Attach Roles:
  project-id = var.user-project-id
  roles      = "roles/container.admin"
}

#-----------Creation of Private VM
module "vm-private" {
  source          = "./vm-instance"
  vm-name         = "instance-management"
  vm-type         = "e2-micro"
  zone-of-vm      = var.user-zone
  image-of-vm     = "ubuntu-os-cloud/ubuntu-2204-lts"
  id-subnet-of-vm = module.management-subnet.id-of-subnet
  email-of-sa     = module.VM-SA.email
  scopes-of-sa    = ["cloud-platform"]
  vm-script       = file("metadata-script.sh")
}
