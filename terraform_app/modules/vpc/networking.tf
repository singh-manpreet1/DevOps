#data "aws_availability_zones" "available" {}

provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}


resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.tenancy

  tags = {
    Name = "main_vpc"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "internet gateway"
  }
}

#Public route table
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "my public route table"
  }
}

#Private Route table
resource "aws_default_route_table" "private_route" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = "private route table"
  }
}

#public subnet
resource "aws_subnet" "public_subnets" {
  count = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.public_cidrs[count.index]}"
  

  tags = {
    Name = "public subnet - ${count.index + 1}"
  }
}

#Private subnet 
resource "aws_subnet" "private_subnets" {
  count = 2
  vpc_id     = "${aws_vpc.main.id}" 
  cidr_block = "${var.private_cidrs[count.index]}"

  tags = {
    Name = "private subnet - ${count.index + 1}"
  }
}

#public subnet route table association 
resource "aws_route_table_association" "pub_sub_assoc" {
  count = "${length(aws_subnet.public_subnets)}"
  subnet_id      = "${aws_subnet.public_subnets.*.id[count.index]}"
  route_table_id = "${aws_route_table.public_route.id}"
  depends_on = [aws_route_table.public_route, aws_subnet.public_subnets]
}

#private subnet route table association 
resource "aws_route_table_association" "priv_sub_assoc" {
  count = "${length(aws_subnet.private_subnets)}"
  subnet_id      = "${aws_subnet.private_subnets.*.id[count.index]}"
  route_table_id = "${aws_default_route_table.private_route.id}"
  depends_on = [aws_default_route_table.private_route, aws_subnet.private_subnets]
}

#security group 
resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { 
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security group"
  }
}


output "vpc_id" {
    value = "${aws_vpc.main.id}"
  
}