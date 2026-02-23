terraform {
  backend "s3" {
    bucket = "cat-use1-ap13-tf-backend-s3"
    key = "infra/SCP/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}