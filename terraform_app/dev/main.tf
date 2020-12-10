provider "aws" {
  region     = "us-west-2"
}

module "dev_vpc" {
    source = "../modules/vpc"
}
