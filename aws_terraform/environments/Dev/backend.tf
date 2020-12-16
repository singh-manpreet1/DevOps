terraform {
  backend "s3" {
    bucket = "dev-alb-logs-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}