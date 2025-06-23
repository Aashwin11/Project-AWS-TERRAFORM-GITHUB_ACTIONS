resource "aws_security_group" "sg-ec2" {
  vpc_id = var.vpc-id
  name="${var.env-name}-ec2-SG"
  description = "Security Group for AWS EC2"

  ingress {
    description = "Allow the traffic from ALB to EC2 "
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [var.alb-sg-id]
  }
  egress{
    description = "Allow the traffic from EC2 to Anyhere"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name="${var.env-name}-ec2-SG"
  }
}