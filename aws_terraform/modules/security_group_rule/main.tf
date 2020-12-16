provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}


resource "aws_security_group_rule" "rule_without_source" {
  type              = var.type
  from_port         = var.from_port
  to_port           = var.to_port
  protocol          = var.protocol
  cidr_blocks       = var.cidr_blocks
  ipv6_cidr_blocks = var.ipv6_cidr_blocks
  security_group_id = var.security_group_id

}



