# output "instance_id" {
#   value = aws_instance.main.id
# }

output "instances_id" {
  value = aws_instance.main.*.id
}

output "instances" {
  value = aws_instance.main
}


