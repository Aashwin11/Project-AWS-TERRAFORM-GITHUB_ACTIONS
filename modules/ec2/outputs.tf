output "instance-id" {
  value = aws_instance.web.id
}

output "instance-public-ip" {
  value = aws_instance.web.public_ip
}