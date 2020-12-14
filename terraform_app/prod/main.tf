provider "aws" {
  region     = "us-west-2"
}

module "prod_vpc" {
    source = "../modules/vpc"
    vpc_cidr = "172.0.0.0/16"
    public_cidrs = ["172.0.1.0/24", "172.0.2.0/24"]
    private_cidrs = ["172.0.3.0/24", "172.0.4.0/24"]

}
