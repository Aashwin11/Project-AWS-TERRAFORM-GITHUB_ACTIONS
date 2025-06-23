output "subnet-blocks-ids" {
  value =[for subnet in aws_subnet.main-subnets : subnet.id]
}