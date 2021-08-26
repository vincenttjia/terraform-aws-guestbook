terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

locals {
  region = var.Region 
}

# Configure the AWS Provider
provider "aws" {
  region = local.region
  shared_credentials_file = "C:\\Users\\vincent\\.aws\\credentials"
  profile = "default"
}

