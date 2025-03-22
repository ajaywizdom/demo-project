terraform {
  backend "s3" {
    bucket = "aj-demo-project"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}