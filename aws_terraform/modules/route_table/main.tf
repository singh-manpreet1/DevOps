provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}


resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id
  tags = {
    Name = var.name
  }
}


