terraform {
  backend "s3" {
    bucket = "terraform-state-backend"
    key = "terraformstatefile"
    region = "us-east-2"
    dynamodb_table = "terraform-state-lock"
  }
}