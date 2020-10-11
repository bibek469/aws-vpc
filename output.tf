output "vpc_cidr" {
  value = aws_vpc.main_vpc.*.cidr_block
}
output "vpc_id" {
  value = "aws_vpc.main_vpc.id"
}
output "public_subnet" {
  value = aws_subnet.public_subnet.*.id
}
output "private_subnet" {
  value = aws_subnet.private_subnet.*.id
}
output "elastic_ip" {
  value = "aws_eip.main_eip.*.id"
}
output "internet_gateway" {
  value = "aws_internet_gateway.main_gateway.id"
}
output "nat_gateway" {
  value = aws_nat_gateway.main_natgateway.*.id
}
output "security_group" {
  value=aws_security_group.main_vpc_sg.*.id
}
output "public_route_table"{
  value=aws_route_table.public_route_table.*.id
}
output "private_route_table"{
  value=aws_route_table.private_route_table.*.id
}