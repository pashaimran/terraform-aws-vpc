terraform {
  cloud {
    organization = "eks_cluster_create"

    workspaces {
      name = "eks-cluster"
    }
  }
}

terraform {
#   required_version = "~> 1.8.4"
  required_providers {
    aws = {
      version = "~> 5.51.1"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
  access_key = ""
  secret_key = ""
}
