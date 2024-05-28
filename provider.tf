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
#  access_key = "AKIAT3CB5XCR2YFK7FFK"
#  secret_key = "SNK95eqa9e814LEEqnolbvaWFkpgaFK8Gd/kWU+5"
#   token      = data.vault_aws_access_credentials.creds.security_token
# profile = "arn:aws:iam::<your account>:instance-profile/<your role name>"arn:aws:iam::264278751395:user/imran
}