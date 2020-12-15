provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}

resource "aws_key_pair" "jumphost" {
  key_name  = var.name
  public_key = var.public_key
}