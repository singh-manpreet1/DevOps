provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}

module "VPC" {
    source = "../../modules/vpc"
    vpc_name = "dev_vpc"
    vpc_cidr = "10.11.0.0/16"
}

module "internet_gateway" {
    source = "../../modules/internet_gateway"
    vpc_id = module.VPC.vpc_id
    
}

module "public_subnet" {
    source = "../../modules/subnet"
    vpc_id = module.VPC.vpc_id
    subnet_cidr_block = "10.11.1.0/24"   //10.0.1.0/24
    name = "public subnet"

}


module "private_subnet" {
  source = "../../modules/subnet"
  vpc_id = module.VPC.vpc_id
  subnet_cidr_block = "10.11.2.0/24"    //10.0.2.0/24
    name = "private subnet"
}



module "route_table1" {
    source = "../../modules/route_table"
    vpc_id = module.VPC.vpc_id
    name = "public route table"
}

module "route_table_public_sub_assoc" {
  source = "../../modules/route_table_assoc"
  subnet = true
  subnet_id = module.public_subnet.subnet_id
  route_table_id = module.route_table1.route_table_id
}

module "route_1_sub1" {
  source = "../../modules/table_route"
  route_table_id = module.route_table1.route_table_id
  ngw = false
  dest_cidr = "0.0.0.0/0"
  gateway_id = module.internet_gateway.gateway_id
}

module "route_table2" {
    source = "../../modules/route_table"
    vpc_id = module.VPC.vpc_id
    name = "private route table"
}

module "route_table_private_sub_assoc" {
  source = "../../modules/route_table_assoc"
  subnet_id = module.private_subnet.subnet_id
  subnet = true
  route_table_id = module.route_table2.route_table_id
}

module "private_sub_route" {
  source = "../../modules/table_route"
  route_table_id = module.route_table2.route_table_id
  ngw = true
  dest_cidr = "0.0.0.0/0"
  nat_gateway_id = module.nat_gateway.nat_gateway_id
}


module "nat_gateway" {
    source = "../../modules/nat_gateway"
    eip_id = module.elastic_ip.eip_id
    subnet_id = module.public_subnet.subnet_id
}

module "elastic_ip" {
  source = "../../modules/eip"
  name = "NAT Gateway Elastic IP"
}

# module "alb_target_group" {
#   source = "../../modules/target_group"
#   port = 80  //port which target is listening on
#   protocol = "HTTPS"  //protocol to send traffic to target
#   target_type = "instance"
#   vpc_id = module.VPC.vpc_id
# }

# module "alb_tg_attachment" {
#   source = "../../modules/target_group_assoc"
#   target_group_arn = module.target_group.tg_attachment_id
#   target_id = ""//instance ids
#   port = 80
# }

# module "alb" {
#   source = "../../modules/target_group_assoc"
#   name = "application load balancer"
#   internal = false
#   load_balancer_type = "instance"
#   security_groups = [module.pub_security_group.security_group_id]
#   subnets = [module.public_subnet.subnet_id,module.private_subnet.subnet_id]
# }

module "ALB_security_group" {
  source = "../../modules/security_group"
  name = "ALB Security Group"
  description = "security group for application load balancer"
  vpc_id = module.VPC.vpc_id
  
}

module "ALB_Security_Group_Rule1" {
  source = "../../modules/security_group_rule"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.ALB_security_group.security_group_id

}

module "ALB_Security_Group_Rule2" {
  source = "../../modules/security_group_rule"
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.ALB_security_group.security_group_id

}

module "server_security_group" {
  source = "../../modules/security_group"
  name = "Server Security Group"
  description = "Security group for servers in private subnet"
  vpc_id = module.VPC.vpc_id
  
}

module "server_security_group_rule1" {
  source = "../../modules/server_sg_rule"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = module.server_security_group.security_group_id
  source_security_group_id = module.ALB_security_group.security_group_id
}

module "server_security_group_rule2" {
  source = "../../modules/server_sg_rule"
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = module.server_security_group.security_group_id
  source_security_group_id = module.ALB_security_group.security_group_id
}

# module "alb_listner" {
#   source = "../../modules/alb_listner"
#   load_balancer_arn = module.alb.alb_id
#   port = 80
#   protocol = "tcp"
#   type= "forward"
#   target_group_arn = module.target_group.target_group_id
  
# }

module "WebServer1_Dev" {
  source = "../../modules/ec2"
  subnet_id = module.private_subnet.subnet_id
  name = "My WebServer 1 Dev"
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.server_security_group.security_group_id]

}
module "WebServer2_Dev" {
  source = "../../modules/ec2"
  subnet_id = module.private_subnet.subnet_id
  name = "My WebServer 2 Dev"
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.server_security_group.security_group_id]

}
module "WebServer3_Dev" {
  source = "../../modules/ec2"
  subnet_id = module.private_subnet.subnet_id
  name = "My WebServer 13Dev"
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.server_security_group.security_group_id]

}

//609-261-9690



