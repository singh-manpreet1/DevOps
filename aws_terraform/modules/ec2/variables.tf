
variable "subnet_id" {}
variable "instance_type" {}
variable "vpc_security_group_ids" {
  type = list(string)
}
variable "name" {}
variable "key_name" {}
variable "amount" {
  type = number
}