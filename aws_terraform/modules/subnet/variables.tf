variable "vpc_id" {
    type = string
    default = "vpc_main"
}

variable "subnet_cidr_block" {
    type = string
    default = "10.0.1.0/24"
}

variable "name" {
    type = string
    default = "subnet"
}

