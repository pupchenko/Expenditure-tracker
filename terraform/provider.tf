provider "aws" {
  region = var.region
  version = "~> 4.67.0"
}
terraform {
  backend "s3" {}
}