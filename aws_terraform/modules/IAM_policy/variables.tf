variable "name" {}
variable "description" {}
variable "policy" {
  type = string
  default = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Deny",
      "Resource": "*"
    }
  ]
}
  POLICY
}

  
