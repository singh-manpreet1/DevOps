provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}

resource "aws_s3_bucket" "main" {
  bucket = var.bucket
  acl = var.acl
  tags = {
    Name = var.name
  }
}