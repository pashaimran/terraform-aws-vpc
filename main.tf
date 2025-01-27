# VPC
# This block creates the main VPC with a CIDR block of "10.0.0.0/16". This provides a total of 65,536 IP addresses (2^16 - 2 reserved addresses) for the VPC. The VPC is named "EKS VPC" using the tags block.
provider "aws" {
  region = var.aws_region
}

terraform {
  #required_version = ">= 1.9.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.63.1"
    }
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

# data "aws_availability_zones" "available" {
#   state = "available"
# }

# Public subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  #availability_zone       = data.aws_availability_zones.available.names[count.index] // used to automatically allocate az's
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
        Name = "public Subnet ${count.index + 1}"
    },
    var.additional_subnet_tags
  )
}


# Private subnets
resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    {
        Name = "Private Subnet ${count.index + 1}"
    },
    var.additional_subnet_tags
  )
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  count  = var.create_igw ? 1 : 0
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}


# NAT gateway
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
# The allocation_id = aws_eip.nat_eip[0].id line links the NAT gateway to the Elastic IP you created earlier. 
# This association ensures that the NAT gateway uses the specified EIP for outbound traffic.
  subnet_id     = aws_subnet.public_subnets[0].id

# The subnet_id = aws_subnet.public_subnets[0].id line places the NAT gateway in one of the public subnets. 
# NAT gateways must be deployed in a public subnet to route traffic from private subnets to the internet.
  
  depends_on = [aws_internet_gateway.igw]  # Ensures the IGW is created first
  tags = {
    Name = "NAT Gateway"
  }
}

# Elastic IP for NAT gateway

resource "aws_eip" "nat_eip" {
  count = var.create_eip ? 1 : 0
  domain = "vpc"
}

# Route tables and associations
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id  # Reference with index [0]
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[0].id  # Reference with index [0]
  }

  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_routes" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_routes" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

# # Security groups
# resource "aws_security_group" "k8s_api_server" {
#   count = var.create_security_groups ? 1 : 0
#   name   = "Kubernetes API Server"
#   vpc_id = aws_vpc.my_vpc.id

#   ingress {
#     from_port   = 6443
#     to_port     = 6443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

resource "aws_security_group" "k8s_worker_nodes" {
  count = var.create_security_groups ? 1 : 0
  name   = "Kubernetes Worker Nodes"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Or specify a more restrictive CIDR block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_security_group" "database_security_group" {
#   name   = "Database Security Group"
#   vpc_id = aws_vpc.my_vpc.id

#   ingress {
#     from_port       = 3306
#     to_port         = 3306
#     protocol        = "tcp"
#     security_groups = [aws_security_group.k8s_worker_nodes.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }


# # Database
# resource "aws_db_subnet_group" "database_subnets" {
#   name       = "database-subnets"
#   subnet_ids = aws_subnet.private_subnets[*].id
# }

# resource "aws_db_instance" "database" {
#   engine                 = "mysql"
#   engine_version         = "8.0.28"
#   instance_class         = "db.t3.medium"
#   allocated_storage      = 100
#   storage_type           = "gp2"
#   db_name                = var.db_name
#   username               = var.db_username
#   password               = var.db_password
#   db_subnet_group_name   = aws_db_subnet_group.database_subnets.name
#   vpc_security_group_ids = [aws_security_group.database_security_group.id]
#}