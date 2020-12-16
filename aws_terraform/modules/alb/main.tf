provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}

resource "aws_lb" "alb" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnets

  access_logs {
    bucket = var.log_bucket
    prefix = var.s3_prefix
    enabled = true
  }

  tags = {
    Environment = "dev"
  }
}
