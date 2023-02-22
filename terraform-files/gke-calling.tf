#-----------Creation of ServiceAccount that the Node inside GKE will use
module "GKE-SA" {
  source = "./ServiceAccount"
  #------Create ServiceAccount:
  id-of-sa        = "gke-service-account"
  name-in-display = "gke-service-account"
  #------Attach Roles:
  project-id = var.user-project-id
  roles      = "roles/storage.objectViewer"
}

#-----------Creation of GKE Cluster
module "GKE-Cluster" {
  source = "./gke-cluster"
  #-----------------------create GKE Cluster
  cluster-name = "python-cluster"
  cluster-zone =var.user-zone
  #-----------------------------------------
  remove-default-node-pool = true
  initial-node-count       = 1
  vpc-id-for-cluster       = module.my-vpc.id-of-vpc
  subnet-id-for-cluster    = module.restricted-subnet.id-of-subnet
  #-----------------------------------------
  master-cidr-ip-block  = "10.0.1.0/24"
  master-name-config    = "management-cidr"
  #-----------------------------------------
  #-----------------------create NodePool
  name-of-node     = "node-pool-one"
  location-of-node = var.user-zone
  count-of-node    = 1
  #----------------------------------------
  machine-type-of-node = "e2-micro"
  email-of-sa-for-node = module.GKE-SA.email
}