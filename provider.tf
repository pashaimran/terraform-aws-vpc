terraform {
  cloud {
    organization = "aws-infra-practice" # Replace with your Terraform Cloud organization

    workspaces {
      name = "vpc-creation" # Replace with your workspace name in Terraform Cloud
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.63.1" # Keep your existing AWS provider version
    }
  }
}