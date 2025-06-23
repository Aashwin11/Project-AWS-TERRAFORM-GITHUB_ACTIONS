terraform {
  backend "s3" {
    bucket="bucket-terraform-github-actions-project"
    key="envs/dev/terraform.tfstate"
    region=us-east-1
    dynamodb_table = "terrraform-lock"
  }
}