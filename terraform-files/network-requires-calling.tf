#------- Create VPC & It's Firewall "allow only from the IAP"
module "my-vpc" {
  source = "./vpc"
  #-------- VPC Requires ----------#
  name-of-vpc = "vpc-main"
  checking-auto-create-subnets = false
  #--------Firewall of VPC --------#
  firewall-name = "iap-allow-access"
  priority-of-firewall = 1000
  type-of-direction = "INGRESS"
  protocol-allowed = "tcp"
  ports-allowed = ["22" , "80"]
  allowed-ip = ["0.0.0.0/0"]
}
#-----------------------------------------------------------------
#------- Create Subnets
module "management-subnet" {
  source = "./subnets"
  subnet-name = "management-subnet"
  cidr-ip = "10.0.1.0/24"
  region-of-subnet = var.user-region
  vpc-link = module.my-vpc.vpc-link
}

module "restricted-subnet" {
  source = "./subnets"
  subnet-name = "restricted-subnet"
  cidr-ip = "10.0.2.0/24"
  region-of-subnet = var.user-region
  vpc-link = module.my-vpc.vpc-link
  first-secondary-ip-range-name = "k8s-pods"
  first-secondary-ip-range-ip = "10.10.10.0/24"
  second-secondary-ip-range-name = "k8s-services"
  second-secondary-ip-range-ip = "10.20.10.0/24"
}
#-----------------------------------------------------------------
#------- Create NATGATEWAY
module "natgateway" {
  source = "./nat-gateway"
  #--------Router Requires
  router-name = "router-01"
  region-of-router = module.management-subnet.region-of-subnet
  network-of-router = module.my-vpc.vpc-link
  #--------NAT Requires
  nat-name = "mangement-nat"
  allocate-ip-of-nat = "AUTO_ONLY"
  subnets-ip-ranges-of-nat-to-work = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
