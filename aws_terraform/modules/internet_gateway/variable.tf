variable "vpc_id" {
    type = string
    default = "module.VPC.vpc_id"

}

variable "name" {
    type = string
    default = "Dev_Internet_Gateway"
}