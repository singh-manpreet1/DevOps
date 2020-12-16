variable "name" {}
variable "internal" {
    type = bool
  }
variable "load_balancer_type" {}
variable "security_groups" {}
variable "subnets" {} 

variable "log_bucket" {
    type = string
    description = "Bucket ID of the Logs Bucket for the Load Balancer"
}
variable "s3_prefix" {
    type = string
    description = "Prefix of Logs"
}


  




