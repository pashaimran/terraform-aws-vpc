This Terraform module creates:-

1) VPC
2) private subnets in decalred AZ's
3) public subnets in declared AZ's
4) public route table
5) private route table
6) public route table association to igw
7) private route table association to ngw
8) elastic ip 
9) security group

1) VPC - Objects created once applied

  + resource "aws_vpc" "my_vpc" { 

      + arn                                  = (known after apply) 

      + cidr_block                           = "10.0.0.0/16" 

      + default_network_acl_id               = (known after apply) 

      + default_route_table_id               = (known after apply) 

      + default_security_group_id            = (known after apply) 

      + dhcp_options_id                      = (known after apply) 

      + enable_dns_hostnames                 = (known after apply) 

      + enable_dns_support                   = true 

      + enable_network_address_usage_metrics = (known after apply) 

      + id                                   = (known after apply) 

      + instance_tenancy                     = "default" 

      + ipv6_association_id                  = (known after apply) 

      + ipv6_cidr_block                      = (known after apply) 

      + ipv6_cidr_block_network_border_group = (known after apply) 

      + main_route_table_id                  = (known after apply) 

      + owner_id                             = (known after apply) 

      + tags                                 = { 

          + "Name" = "EKS-VPC" 

