#
# Provider Configuration
#

 provider "aws" {
  region  = "us-east-2"
  version = ">= 2.38.0"
  }

# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

# Not required: currently used in conjuction with using
# icanhazip.com to determine local workstation external IP
# to open EC2 Security Group access to the Kubernetes cluster.
# See workstation-external-ip.tf for additional information.
provider "http" {}
/*
provider "aws" {
    access_key = "AKIA545UBMJ7LDZLNEO4"
    secret_key = "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"
    region = "us-east-2"
}
*/
