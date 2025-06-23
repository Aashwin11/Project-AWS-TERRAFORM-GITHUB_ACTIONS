variable "vpc-id" {
  type = string
}

variable "subnet-ids" {
  type=list(string)
}

variable "alb-name" {
  type = string
}

variable "isntance-ids" {
  type=list(string)
}

variable "alb-sg-id" {
  type=string
}
variable "env-name" {
  type=string
}