resource "aws_route_table" "rt-main" {
  vpc_id = var.vpc-id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id=var.igw-id
  }

  tags = {
    Name="rt-main-${var.env-name}"
  }
}

resource "aws_route_table_association" "rta-main" {
  for_each = {
    for idx, subnet_id in var.subnet-ids : "subnet-${idx}" => subnet_id
  }

  subnet_id = each.value
  route_table_id = aws_route_table.rt-main.id
}