provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}


resource "aws_iam_policy" "policy" {
  name = var.name
  description = var.description
  policy = var.policy
}



