provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}

resource "aws_route_table_association" "subnet_association" {
  count = var.subnet ? 1 : 0
  subnet_id = var.subnet_id
  route_table_id = var.route_table_id
}

resource "aws_route_table_association" "gateway_association" {
  count = var.subnet ? 0 : 1
  gateway_id = var.gateway_id
  route_table_id = var.route_table_id
  
}