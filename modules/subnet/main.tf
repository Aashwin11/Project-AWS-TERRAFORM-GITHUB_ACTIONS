resource "aws_subnet" "main-subnets" {
  vpc_id = var.vpc-id
  count=length(var.subnet-cidr-blocks-list)
  cidr_block = var.subnet-cidr-blocks-list[count.index]
  availability_zone = element(var.availability-zones-list, count.index)

  tags = {
    Name="public-subnet-${count.index+1}-env-${var.env-name}"
  }
}