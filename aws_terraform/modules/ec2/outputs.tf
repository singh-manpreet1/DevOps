# output "instance_id" {
#   value = aws_instance.main[count.index].id
# }

output "instance_id" {
  value = join("" , aws_instance.main[*].id)
}