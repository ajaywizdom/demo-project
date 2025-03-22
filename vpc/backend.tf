terraform {
  backend "s3" {
    bucket = "aj-demo-project"
    key    = "vpc.tfstate"
    region = "ap-south-1"
  }
}