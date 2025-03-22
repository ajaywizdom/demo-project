# fetching region
data "aws_region" "region" {}

# fetching azs
data "aws_availability_zones" "azs" {
  state = "available"
}

