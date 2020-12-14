provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}


resource "aws_internet_gateway" "internet_GW" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.name
  }
}