resource "aws_internet_gateway" "igw-main" {
  vpc_id = var.vpc-id

  tags={
    Name="main-igw-${var.env-name}"
  }
}