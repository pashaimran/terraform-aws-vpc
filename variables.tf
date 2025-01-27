variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

# New variable for additional tags
variable "additional_subnet_tags" {
  type = map(string)
  description = "Additional tags to be applied to all subnets."
}

variable "create_eip" {
  type    = bool
  default = true
}

variable "create_igw" {
  type    = bool
  default = true
}

variable "create_nat_gateway" {
  type    = bool
  default = true
}

variable "create_security_groups" {
  type    = bool
  default = true
}

# variable "db_name" {
#   description = "Name of the database"
#   type        = string
# }

# variable "db_username" {
#   description = "Username for the database"
#   type        = string
# }

# variable "db_password" {
#   description = "Password for the database"
#   type        = string
#   sensitive   = true
# }