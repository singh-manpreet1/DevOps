provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}

resource "aws_alb_target_group" "my-target-group" {
  name        = var.name
  port        = var.port
  protocol    = var.protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id

  health_check {
    path     = var.health_check_path
    protocol = "HTTP"
    port     = var.target_group_port
    interval = 60
  }

 
}
