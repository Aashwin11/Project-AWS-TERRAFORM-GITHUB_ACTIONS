terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws-region
}

# ------------------------VPC -----------------------------
module "vpc"{
    source="./modules/vpc"
    vpc-cidr-block = var.vpc-cidr-block
    env-name = terraform.workspace
}

# -------------------SUBNET--------------------------------
module "subnet" {
  source="./modules/subnet"
  vpc-id = module.vpc.vpc-id
  subnet-cidr-blocks-list=var.public-subnet-cidrs
  availability-zones-list=var.availability-zones
  env-name = terraform.workspace
}

# -------------------IGW-------------------
module "igw" {
  source = "./modules/igw"
  vpc-id = module.vpc.vpc-id
  env-name = terraform.workspace
}

#------------------ROUTE TABLE---------------------
module "route_table"{
    source = "./modules/route_table"
    vpc-id = module.vpc.vpc-id
    igw-id = module.igw.igw-id
    subnet-ids = module.subnet.subnet-blocks-ids
    env-name = terraform.workspace
}

# ---------------------------ALB-SG----------------------------
module "alb-sg" {
  source = "./modules/alb-sg"
  vpc-id = module.vpc.vpc-id
  env-name = terraform.workspace
}

# -------------------------EC2 SG----------------------------
module "ec2-sg" {
  source = "./modules/ec2_sg"
  vpc-id = module.vpc.vpc-id
  env-name = terraform.workspace
  alb-sg-id = module.alb-sg.alb-sg-id
}


# --------EC2 Instance 1 (dev/prod specific)---------
module "ec2_a" {
  source = "./modules/ec2"
  ami-id = var.ami-id
  subnet-id = module.subnet.subnet-blocks-ids[0]
  instance-type = var.instance-type
  security-groups-ids=[module.ec2-sg.ec2-sg-id]
  html-content = file("${path.module}/html/${terraform.workspace}/a.html")
  env-name=terraform.workspace
}

# --------EC2 Instance 2 (dev/prod specific)---------
module "ec2_b" {
  source = "./modules/ec2"
  ami-id = var.ami-id
  subnet-id = module.subnet.subnet-blocks-ids[1]
  instance-type = var.instance-type
  security-groups-ids=[module.ec2-sg.ec2-sg-id]
  html-content = file("${path.module}/html/${terraform.workspace}/b.html")
  env-name=terraform.workspace
}

# -----------ALB -----------------------
module "alb" {
  source = "./modules/alb"
  vpc-id = module.vpc.vpc-id
  subnet-ids =module.subnet.subnet-blocks-ids
  alb-name = "${terraform.workspace}-alb"
  isntance-ids=[module.ec2_a.instance-id,module.ec2_b.instance-id]
  alb-sg-id=module.alb-sg.alb-sg-id
  env-name = terraform.workspace
}

terraform {
  backend "s3" {
    bucket="bucket-terraform-github-actions-project"
    key="envs/${terraform.workspace}/terraform.tfstate"
    region=us-east-1
    dynamodb_table = "terrraform-lock"
  }
}