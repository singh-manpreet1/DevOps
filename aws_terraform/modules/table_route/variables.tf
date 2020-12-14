variable "route_table_id" {}
variable "dest_cidr" {}
variable "gateway_id" {
  default = ""
}
variable "nat_gateway_id" {
  default = ""
}
variable "ngw" {
  type = bool
  description = "Determine if the connected gateway is NAT or Internet"
}