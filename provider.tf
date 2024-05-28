terraform {
  cloud {
    organization = "eks_cluster_create"

    workspaces {
      name = "eks-cluster"
    }
  }
}

terraform {
  required_providers {
    aws = {
      version = "~> 5.51.1"
      source  = "hashicorp/aws"
    }
    # kubernetes = {
    #   version = "~> 2.30.0"
    #   source  = "hashicorp/kubernetes"
    # }
    # helm = {
    #   version = "~> 2.13.2"
    #   source  = "hashicorp/helm"
    # }
    # vault = {
    #   version = "~> 4.2.0"
    #   source  = "hashicorp/vault"
    # }
  }
}

provider "aws" {
  region     = "ap-south-1"
}