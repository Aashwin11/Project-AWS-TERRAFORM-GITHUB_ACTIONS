variable "vpc-id" {
  type = string
}
variable "igw-id" {
  type=string
}
variable "subnet-ids" {
  type = list(string)
}
variable "env-name" {
  type=string
}