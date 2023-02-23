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
  cluster-name             = "python-cluster"
  cluster-zone             = var.user-zone
  remove-default-node-pool = true
  vpc-id-for-cluster       = module.my-vpc.id-of-vpc
  subnet-id-for-cluster    = module.restricted-subnet.id-of-subnet
  work-load                = "${var.user-project-id}.svc.id.goog"
  manage-subnet-ip-range   = module.management-subnet.ip-range
  master-name-config    = "management-cidr"
  #-----------------------------------------
  #-----------------------create NodePool
  name-of-node     = "node-pool-one"
  location-of-node = var.user-zone
  count-of-node    = 1
  #----------------------------------------
  machine-type-of-node = "e2-standard-4"
  email-of-sa-for-node = module.GKE-SA.email
}
