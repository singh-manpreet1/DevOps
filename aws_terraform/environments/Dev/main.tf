provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/manpreetsingh/.aws/credentials"
  profile = "default"
}

module "availability_zones" {
  source = "../../modules/availability_zones"
}

module "VPC" {
    source = "../../modules/vpc"
    vpc_name = "dev_vpc"
    vpc_cidr = "10.12.0.0/16"
}

module "internet_gateway" {
    source = "../../modules/internet_gateway"
    vpc_id = module.VPC.vpc_id
    
}

module "public_subnet" {
  source = "../../modules/subnet"
  vpc_id = module.VPC.vpc_id
  cidr_block = "10.12.1.0/24"
  name = "dev_public_subnet"
  availability_zone_id = module.availability_zones.availability_zones[0]
  map_public_ip_on_launch = true
}


module "private_subnet" {
  source = "../../modules/subnet"
  vpc_id = module.VPC.vpc_id
  cidr_block = "10.12.2.0/24"
  name = "dev_private-subnet"
  availability_zone_id = module.availability_zones.availability_zones[1]
  map_public_ip_on_launch = false
}

module "route_table1" {
    source = "../../modules/route_table"
    vpc_id = module.VPC.vpc_id
    name = "dev_public_rt"
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
    name = "dev_private_rt"
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
  name = "NAT_Gateway_Elastic_IP"
}

module "ALB_security_group" {
  source = "../../modules/security_group"
  name = "dev_alb_sg"
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
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = module.ALB_security_group.security_group_id

}

module "ALB_Security_Group_Rule2" {
  source = "../../modules/security_group_rule"
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = module.ALB_security_group.security_group_id

}

module "ALB_security_group_rule_3" {
  source = "../../modules/security_group_rule"
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "all"
  security_group_id = module.ALB_security_group.security_group_id
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}



module "server_security_group" {
  source = "../../modules/security_group"
  name = "dev_server_sg"
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
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = module.server_security_group.security_group_id
  source_security_group_id = module.ALB_security_group.security_group_id
}

module "server_security_group_rule3" {
  source = "../../modules/server_sg_rule"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = module.server_security_group.security_group_id
  source_security_group_id = module.Jumphost_security_group.security_group_id
}

module "server_security_group_rule4" {
  source = "../../modules/server_sg_rule"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = module.server_security_group.security_group_id
  source_security_group_id = module.Jumphost_security_group.security_group_id
}

module "server_security_group_rule5" {
  source = "../../modules/security_group_rule"
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "all"
  security_group_id = module.server_security_group.security_group_id
  cidr_blocks = ["0.0.0.0/0"]
}

module "server_security_group_rule6" {
  source = "../../modules/server_sg_rule"
  type = "ingress"
  from_port = 8090
  to_port = 8090
  protocol = "tcp"
  security_group_id = module.server_security_group.security_group_id
  source_security_group_id = module.ALB_security_group.security_group_id
}

module "server_security_group_rule7" {
  source = "../../modules/server_sg_rule"
  type = "ingress"
  from_port = 8090
  to_port = 8090
  protocol = "tcp"
  security_group_id = module.server_security_group.security_group_id
  source_security_group_id = module.Jumphost_security_group.security_group_id
}



module "Jumphost_security_group" {
  source = "../../modules/security_group"
  name = "dev_jumphost_sg"
  description = "security group for jumphost"
  vpc_id = module.VPC.vpc_id
  
}

module "bastion_sg_rule1" {
  source = "../../modules/security_group_rule"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = module.Jumphost_security_group.security_group_id
  cidr_blocks = ["73.150.47.189/32"]
}

module "bastion_sg_rule_2" {
  source = "../../modules/security_group_rule"
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "all"
  security_group_id = module.Jumphost_security_group.security_group_id
  cidr_blocks = ["0.0.0.0/0"]
}

module "bastion_sg_rule_3" {
  source = "../../modules/server_sg_rule"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = module.Jumphost_security_group.security_group_id
  source_security_group_id = module.server_security_group.security_group_id
}

module "key_pair" {
  source = "../../modules/key_pair"
  name = "jumphost"
  public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDc8f0IYs0nrUFo8nP1IMf/LIzvwGDMRSU/h4QXnohb+Q+G0zlYc76axlC60DVZOg3jXY5c6Vky5pHN7yNeMahTncM5WER8uSwkYVImznq3CyZQatNdj12flRP6lULb2oMIaBNrP/VhfYqwVVL2kDwGpHylpE3WCCoYiwJiCJezRT8SCGURaEowWuNxHlgJfVnzkSnG1hlEUmqlW6Y8ZS9W55LKJrqOnjx4jMH93FP3IZWSnCPM2LofD6rF7sep8FnQzDmTNsy02EXEJ2C0oFgiwOl5qPgHGGH65D0imZxe/bZFeCHx8Rj2sl3tb9Jo8A4vQs9k2LgFUVLiikORGjE/P5nrHsnR4uTTySuSl0zg1MGXpgXbZLn9dpLCGTjk5k5OMh23RLBoJqjBKabNd2ZdTaUCsgnizOhDi5lOzbVG5+LbkK9HYgcqS9P7h0udbHSke77uO7LqU5t4mI5hxtHsS3B8xmzXGD4qqo6mQQaJaOCcgnzyOv3k0gbL5hCiiL8= manpreetsingh@Manpreets-MacBook-Pro.local"
}


module "kafka_server" {
   source = "../../modules/ec2"
   subnet_id = module.private_subnet.subnet_id
   name = "dev_kafka_server"
   instance_type = "t2.small"
   vpc_security_group_ids = [module.server_security_group.security_group_id]
   key_name = "jumphost"
   amount = 2 
   iam_instance_profile = module.iam_instance_profile.name

 }

 module "zookeeper_server" {
  source = "../../modules/ec2_ssh"
  subnet_id = module.private_subnet.subnet_id
  name = "dev_zookeeper_server"
  instance_type = "t2.small"
  vpc_security_group_ids = [module.server_security_group.security_group_id]
  key_name = "jumphost"
  iam_instance_profile = module.iam_instance_profile.name

}

module "Bastion_Jumphost" {
  source = "../../modules/ec2_ssh"
  subnet_id = module.public_subnet.subnet_id
  name = "dev_Bastion_Host"
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.Jumphost_security_group.security_group_id]
  key_name = "jumphost"
  iam_instance_profile = module.iam_instance_profile.name

}

 module "Dev_Webserver" {
   source = "../../modules/ec2"
   subnet_id = module.private_subnet.subnet_id
   name = "dev_webserver"
   instance_type = "t2.micro"
   vpc_security_group_ids = [module.server_security_group.security_group_id]
   key_name = "jumphost"
   amount = 3 
   iam_instance_profile = module.iam_instance_profile.name

 }


module "Alb_Target_Group" {
  source = "../../modules/target_group"
  name = "dev-server-tg"
  port = 80  //port which target is listening on
  protocol = "HTTP"  //protocol to send traffic to target
  target_type = "instance"
  vpc_id = module.VPC.vpc_id
  load_balancing_algorithm_type = "round_robin"
  health_check_protocol = "HTTP"
  path = "/"
} 

module "Alb_Target_Attachment" {
  source = "../../modules/target_group_assoc"
  target_group_arn = module.Alb_Target_Group.target_group_arn
  target_ids = module.Dev_Webserver.instances_id
  port = 80
}


module "Application_Load_Balancer" {
  source = "../../modules/alb"
  name = "ALB"
  internal = false
  load_balancer_type = "application"
  security_groups = [module.ALB_security_group.security_group_id]
  subnets = [module.public_subnet.subnet_id,module.private_subnet.subnet_id]
  log_bucket = module.s3.bucket_name
  s3_prefix = "Logs_ALB"
}

module "alb_listner" {  
  source = "../../modules/alb_listener"
  load_balancer_arn = module.Application_Load_Balancer.alb_arn
  port = 80
  protocol = "HTTP"
  type= "forward"
  target_group_arn = module.Alb_Target_Group.target_group_id
}

module "api_Target_Group" {
  source = "../../modules/target_group"
  name = "dev-data-api-tg"
  port = 8090  //port which target is listening on
  protocol = "HTTP"  //protocol to send traffic to target
  target_type = "instance"
  vpc_id = module.VPC.vpc_id
  load_balancing_algorithm_type = "round_robin"
  health_check_protocol = "HTTP"
  path = "/User/a"
} 

module "api_Target_Attachment" {
  source = "../../modules/target_group_assoc"
  target_group_arn = module.api_Target_Group.target_group_arn
  target_ids = module.Dev_Webserver.instances_id
  port = 8090
}

module "api_Load_Balancer" {
  source = "../../modules/alb"
  name = "dev-data-api-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [module.ALB_security_group.security_group_id]
  subnets = [module.public_subnet.subnet_id,module.private_subnet.subnet_id]
  log_bucket = module.s3.bucket_name
  s3_prefix = "api_Logs_ALB"
}

module "data_api_listner" {  
  source = "../../modules/alb_listener"
  load_balancer_arn = module.api_Load_Balancer.alb_arn
  port = 80
  protocol = "HTTP"
  type= "forward"
  target_group_arn = module.api_Target_Group.target_group_id
  
}


module "s3" {
  source = "../../modules/s3"
  bucket = "dev-alb-logs-s3-bucket"
  acl = "public-read-write"
  name = "Dev-Alb-logs-s3-bucket"

}

module "ec2_to_s3_policy" {
  source = "../../modules/IAM_policy"
  name = "ec2_to_s3"
  description = "Gives EC2 instances  acess to S3 Buckets"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["s3:*"],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
  EOF
}

module "ec2_to_s3_role" {
  source = "../../modules/IAM_role"
  name = "ec2_to_s3_access"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
  EOF
}

module "ec2_to_s3_policy_attachment" {
  source = "../../modules/IAM_policy_attach"
  role = module.ec2_to_s3_role.role_name
  policy_arn = module.ec2_to_s3_policy.policy_arn
}

module "iam_instance_profile" {
  source = "../../modules/IAM_instance"
  name = "dev_ec2_s3_instance"
  role = module.ec2_to_s3_role.role_name
}









