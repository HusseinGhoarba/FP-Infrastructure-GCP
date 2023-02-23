#------------------------------ SUBNET REQUIRES:
variable "subnet-name" {
  
}

variable "cidr-ip" {
  
}

variable "region-of-subnet" {
  
}

variable "vpc-link" {
  
}

variable "first-secondary-ip-range-name" {
  default = "default"
}

variable "first-secondary-ip-range-ip" {
  default = "10.1.12.0/24"
}

variable "second-secondary-ip-range-name" {
  default = "default-two"
}

variable "second-secondary-ip-range-ip" {
  default = "20.1.22.0/24"
}