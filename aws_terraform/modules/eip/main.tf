provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}

resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = var.name
  }
}