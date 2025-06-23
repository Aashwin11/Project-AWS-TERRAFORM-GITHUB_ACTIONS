variable "ami-id" {
  type=string
}
variable "instance-type" {
  type=string
}
variable "subnet-id" {
  type=string
}

variable "security-groups-ids" {
    type=list(string)
}

variable "html-content" {
  type=string
}

variable "env-name" {
  type=string
}