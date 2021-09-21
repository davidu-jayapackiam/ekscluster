



#
# Provider Configuration
#

provider "aws" {
  region  = "us-east-2"
  version = ">= 2.38.0"
}

terraform {
  backend "s3" {
    bucket = "terraform-statebackend"
    key = "terraformstatefile"
    region = "us-east-2"
    dynamodb_table = "terraform-state-lock"
  }
}