variable "vpc-id" {
  type=string
  description = "VPC ID of the Project"
}

variable "subnet-cidr-blocks-list" {
  type=list(string)
  description = "SUBNET CIDR of the Project"
}

variable "availability-zones-list" {
  type=list(string)
}

variable "env-name" {
  type=string
}