provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = var.name
  role = var.role
}

