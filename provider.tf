terraform {
  cloud {
    organization = "eks_cluster_create"

    workspaces {
      name = "eks-cluster"
    }
  }
}

terraform {
  # required_version = "~> 1.3.2"
  required_providers {
    aws = {
      version = "~> 5.51.1"
      source  = "hashicorp/aws"
    }
  }
}