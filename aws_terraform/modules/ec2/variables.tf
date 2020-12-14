# variable "ami" {}

# variable "instance_type" {
#     default = "t2.micro"
# }

# variable "subnet_id" {}


# variable "name" {}



variable "subnet_id" {
    type = string
    description = "Subnet ID to associate the instance with"
}
variable "name" {
    type = string
    description = "Instance name"
}
variable "instance_type" {
    type =  string
    description = "Type of ec2 instance"
}
variable "vpc_security_group_ids" {
  
}
