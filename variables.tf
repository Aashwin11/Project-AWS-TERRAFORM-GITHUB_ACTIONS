variable "aws-region" {
  type=string
}
variable "vpc-cidr-block" {
  type = string
}
variable "public-subnet-cidrs" {
  type=list(string)
}
variable "availability-zones" {
  type=list(string)
}
variable "ami-id" {
  type=string
}
variable "instance-type" {
  type=string
}