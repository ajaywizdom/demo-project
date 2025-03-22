# cretae VPC
resource "aws_vpc" "demo" {
  cidr_block           = var.vpc_config.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "demo-vpc"
  }
}

# Define private subnets for each AZ dynamically
resource "aws_subnet" "private" {
  count = length(data.aws_availability_zones.azs.names)

  vpc_id                  = aws_vpc.demo.id
  cidr_block              = cidrsubnet(var.vpc_config.private_subnet_cidr, 3, count.index)
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  map_public_ip_on_launch = false # Private subnet
  lifecycle {
    ignore_changes = [tags]
  }
  tags = {
    Name = "private-subnet-${data.aws_availability_zones.azs.names[count.index]}"
  }
}


# Define private subnets for each AZ dynamically
resource "aws_subnet" "public" {
  count = length(data.aws_availability_zones.azs.names)

  vpc_id                  = aws_vpc.demo.id
  cidr_block              = cidrsubnet(var.vpc_config.public_subnet_cidr, 2, count.index)
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  map_public_ip_on_launch = false # Public subnet
  lifecycle {
    ignore_changes = [tags]
  }
  tags = {
    Name = "public-subnet-${data.aws_availability_zones.azs.names[count.index]}"
  }
}

# Create route table for private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.demo.id
  lifecycle {
    ignore_changes = [tags]
  }
  tags = {
    Name = "private-route-table"
  }
}

# Create route table for public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.demo.id
  lifecycle {
    ignore_changes = [tags]
  }
  tags = {
    Name = "public-route-table"
  }
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private" {
  count          = length(data.aws_availability_zones.azs.names)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count          = length(data.aws_availability_zones.azs.names)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = element(aws_route_table.public[*].id, count.index)
}

resource "aws_internet_gateway" "demo" {
  vpc_id = aws_vpc.demo.id
  tags = {
    Name = "demo-igw"
  }
}

resource "aws_route" "demo" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.demo.id
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.demo.id
}

resource "aws_eip" "demo" {
  #   domain = "vpc"
}
resource "aws_nat_gateway" "demo" {
  allocation_id = aws_eip.demo.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "demo-nat-gateway"
  }
}