provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}

resource "aws_lb_target_group_attachment" "my-alb-target-group-attachment1" {
  target_group_arn = var.target_group_arn
  target_id        = var.target_id
  port             = var.port
}