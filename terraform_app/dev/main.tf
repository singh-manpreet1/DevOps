provider "aws" {
  region     = "us-west-2"
  access_key = "AKIARDMMB3BIITJGXR4R"
  secret_key = "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"
}

module "my_vpc" {
    source = "../modules/vpc"
    vpc_cidr = "192.168.0.0/16"
    tenancy = "default"
    vpc_id = "${module.my_vpc.vpc_id}"
    subnet_cidr = "192.168.1.0/24"
  
}