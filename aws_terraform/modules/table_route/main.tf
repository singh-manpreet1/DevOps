provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}

resource "aws_route" "r1" {
  count = var.ngw ? 0 : 1
  route_table_id = var.route_table_id
  destination_cidr_block = var.dest_cidr
  gateway_id = var.gateway_id
}

resource "aws_route" "r2" {
  count = var.ngw ? 1 : 0
  route_table_id = var.route_table_id
  destination_cidr_block = var.dest_cidr
  nat_gateway_id = var.nat_gateway_id
}