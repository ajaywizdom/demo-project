output "no_of_azs" {
  value       = data.aws_availability_zones.azs.names
  description = "number of AZs in the region"
}