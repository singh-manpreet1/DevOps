variable "vpc_id" {
  type = string
  description = "ID of VPC"
}
variable "cidr_block" {
  type = string
  description = "subnet CIDR block"
}
variable "name" {
  type = string
  description = "Name of the Subnet"
}
variable "availability_zone_id" {
  type = string
  description = "The ID of the AVialability Zone to place the subnet in"
}
variable "map_public_ip_on_launch" {
  type = bool
  description = "Whether or not to assign a public IP to instances that reside in the subnet"
}