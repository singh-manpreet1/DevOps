provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}


resource "aws_iam_role" "role" {
  name = var.name
  assume_role_policy = var.assume_role_policy
  
}


