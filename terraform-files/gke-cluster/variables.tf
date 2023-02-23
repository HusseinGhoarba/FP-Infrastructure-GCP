#---------------------------Creation of Cluster
variable "cluster-name" { 
}
variable "cluster-zone" {  
}
variable "vpc-id-for-cluster" {
}
variable "subnet-id-for-cluster" {
}
variable "work-load" {
  default = "hussein-ghoraba.svc.id.goog"
}
variable "manage-subnet-ip-range" {
}
variable "remove-default-node-pool" { 
}
variable "master-name-config" {
}
#-----------------------------------------------
#---------------------------Creation of Cluster
variable "name-of-node" {
}
variable "location-of-node" {
}
variable "count-of-node" {
}
variable "machine-type-of-node" {
}
variable "email-of-sa-for-node" {
}
#-----------------------------------------------