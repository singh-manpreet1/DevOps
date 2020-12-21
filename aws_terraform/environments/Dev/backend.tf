terraform {
  backend "s3" {
    bucket = "dev-alb-logs-bucket"
    key    = "terraform.tfstate" // dev-tf
    region = "us-east-1"
  }
}