output "no_of_azs" {
  value       = data.aws_availability_zones.azs.names
  description = "number of AZs in the region"
}

output "vpc_id" {
  value = aws_vpc.demo.id
  description = "VPC id"
}

output "private_subnets" {
  value = aws_subnet.private[*].id
  description = "Private subnets ids"
}

output "public_subnets" {
  value = aws_subnet.public[*].id
  description = "Private subnets ids"
}