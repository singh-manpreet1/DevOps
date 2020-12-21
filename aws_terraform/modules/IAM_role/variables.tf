variable "name" {}

variable "assume_role_policy" {
  type = string
  default = <<EOF
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
    EOF
}