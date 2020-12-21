provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}


resource "aws_iam_role_policy_attachment" "attachment" {
  role = var.role
  policy_arn = var.policy_arn
}

