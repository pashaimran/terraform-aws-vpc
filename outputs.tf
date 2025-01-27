output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.my_vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private_subnets[*].id
}

# output "db_endpoint" {
#   description = "Endpoint of the RDS database"
#   value       = aws_db_instance.database.endpoint
# }

# output "k8s_api_server_dns" {
#   description = "DNS name for the Kubernetes API server"
#   value       = aws_route53_record.k8s_api_server.name
# }