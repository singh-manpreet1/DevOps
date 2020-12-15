provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}

resource "aws_subnet" "Subnet" {
  vpc_id = var.vpc_id
  cidr_block = var.cidr_block
  availability_zone_id = var.availability_zone_id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = {
    Name = var.name
  }
}
