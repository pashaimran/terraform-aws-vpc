## VPC and Internet Gateway are the two most important resources, and we will define them at the beginning of the file.

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.vpc_name}-VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name} IG"
  }
}


## The number of subnets will be determined by the list of AZs passed from the variable.

## Each AZ will have one private subnet and one public subnet, so we use count to iterate through each AZ.

resource "aws_subnet" "public_subnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.azs, count.index)
  cidr_block        = element(var.public_subnet_cidrs, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.azs, count.index)
  cidr_block        = element(var.private_subnet_cidrs, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}


## A NAT gateway serves as a gateway to the outside world, allowing EC2 instances and other resources within private subnets
## to connect to the Internet.

## One NAT gateway per Availability Zone (AZ) is created to minimize cloud costs.

## Each NAT gateway needs an elastic IP address.

## To generate elastic IP addresses and NAT gateways, we iterate over the total number of AZs using Terraform’s count function.

resource "aws_eip" "nat_gateways" {
  count = length(aws_subnet.private_subnets)
  vpc   = true
}

resource "aws_nat_gateway" "nat_gw" {
  count         = length(aws_subnet.private_subnets)
  allocation_id = element(aws_eip.nat_gateways, count.index).id
  subnet_id     = element(aws_subnet.private_subnets, count.index).id
}


// A route table has a set of rules, called routes, that tell your subnet where to send network traffic.

# We’re going to make two different kinds of route tables. One kind of route table is for public subnets, and the other kind is for private subnets.

# Public subnet route table: All packets going to cidr block (“0.0.0.0/0”) would be sent to the Internet gateway.
# Public subnet rout table: All traffic going to cidr block (“0.0.0.0/0”) would be sent to the NAT gateway in that AZ.
# Public subnet’s route table and its route_table_association 

resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public Subnet Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_subnets.id
}

## Private subnet’s route table and its route_table_association

resource "aws_route_table" "private_subnets" {
  count  = length(aws_nat_gateway.nat_gw)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.nat_gw, count.index).id
  }

  tags = {
    Name = "Private Subnet Route Table"
  }
}

resource "aws_route_table_association" "private_subnet_asso" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = element(aws_route_table.private_subnets[*].id, count.index)
}

