provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}

resource "aws_lb_target_group_attachment" "my-alb-target-group-attachment1" {
  count = length(var.target_ids)
  target_group_arn = var.target_group_arn
  target_id        = var.target_ids[count.index]
  port             = var.port
}