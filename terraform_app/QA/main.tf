provider "aws" {
  region     = "us-west-2"
}

module "QA_vpc" {
    source = "../modules/vpc"
}
