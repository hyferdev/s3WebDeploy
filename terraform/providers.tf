# terraform/providers.tf

terraform {
  required_version = "~> 1.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "remote" {
    organization = "your-tfc-organization"
    workspaces {
      prefix = "your-project-name-"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Application = "hyfer_website"
      Environment = var.environment_name
      ManagedBy   = "Terraform"
    }
  }
}
