terraform {
  backend "s3" {
    bucket = "terraform-statebackend"
    key = "terraformstatefile"
    region = "us-east-2"
    dynamodb_table = "terraform-state-lock"
  }
}