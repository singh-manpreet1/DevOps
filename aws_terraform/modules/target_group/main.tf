provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}

resource "aws_lb_target_group" "lb_target" {

  port = var.port
  protocol = var.protocol
  vpc_id = var.vpc_id
  name = var.name
  target_type = var.target_type
  load_balancing_algorithm_type = var.load_balancing_algorithm_type
  deregistration_delay = 30
  health_check {
    enabled = true
    # interval = 5
    port = var.port
    protocol = var.health_check_protocol
    # timeout = 4
  }
}