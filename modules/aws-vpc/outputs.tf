output "vpc_id" {
  value = aws_vpc.vpc.id
}
/**
output "subnet_ids" {
  value = aws_subnet.subnet.*.id
}
**/

output "subnet_order" {
  value = [for subnet_name in keys(var.cidr_block) : aws_subnet.subnet[subnet_name]]
}