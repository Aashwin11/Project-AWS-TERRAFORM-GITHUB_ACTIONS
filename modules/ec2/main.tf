resource "aws_instance" "web" {
  ami = var.ami-id
  instance_type = var.instance-type
  subnet_id = var.subnet-id
  vpc_security_group_ids = var.security-groups-ids
  associate_public_ip_address = true

  user_data = <<-EOF
            #!/bin/bash

            apt-get update
            apt-get install -y apache2

            cat <<EOT > /var/www/html/index.html
            ${var.html-content}
            EOT

            systemctl start apache2
            systemctl enable apache2
            EOF

    tags = {
        Name="Instance-${var.env-name}-web"
    }
}