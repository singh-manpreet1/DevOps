variable "type" {}
variable "from_port" {}
variable "to_port" {}
variable "protocol" {}
variable "security_group_id" {}
variable "cidr_blocks" {
    default = []
}

variable "ipv6_cidr_blocks" {
    default = []
  
}

