variable "aws_region" {
  default     = "ap-south-1"
  description = "choose region to deploy"
  type        = string
}

variable "vpc_config" {
  type = object({
    vpc_cidr_block      = string
    public_subnet_cidr  = string
    private_subnet_cidr = string
  })
  default = {
    vpc_cidr_block      = "10.0.0.0/16"
    public_subnet_cidr  = "10.0.1.0/24"
    private_subnet_cidr = "10.0.2.0/24"
  }
}