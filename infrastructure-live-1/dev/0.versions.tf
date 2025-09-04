provider "aws" {
  region = local.aws_region
}

terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.9.0, < 7.0.0"
    }
  }

  backend "local" {
    path = "dev/terraform.tfstate"
  }
}
