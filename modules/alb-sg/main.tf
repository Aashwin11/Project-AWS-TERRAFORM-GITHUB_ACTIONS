resource "aws_security_group" "sg-alb" {
  vpc_id = var.vpc-id
  name="${var.env-name}-alb-SG"
  description = "Security Group for ALB to EC2"

  ingress {
    description = "Allow the traffic from anywher to ALB "
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    description = "Allow the traffic from ALB to Anyhere"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name="${var.env-name}-alb-SG"
  }
}