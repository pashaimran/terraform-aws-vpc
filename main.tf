module "vpc" {
  source  = "app.terraform.io/eks_cluster_create/vpc/aws"
  version = "1.0.1"
  vpc_name             = "eks_vpc"
  vpc_cidr_block       = "10.0.0.0/16"
  azs                  = ["ap-south-1a", "ap-south-1b"]
  public_subnet_cidrs  = ["100.0.1.0/24", "100.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}

# https://medium.com/@thearaseng/create-and-publish-your-own-aws-vpc-terraform-module-on-the-terraform-registry-687480dce74a
# https://antonputra.com/amazon/create-eks-cluster-using-terraform-modules/#deploy-aws-load-balancer-controller
