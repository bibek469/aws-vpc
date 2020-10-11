/**
 * VPC
 */

resource "aws_vpc" "main_vpc" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = var.tenancy
  enable_dns_hostnames             = var.dns_hostnames
  enable_classiclink               = var.classic_link
  enable_dns_support               = var.dns_support
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = var.enable_ipv6
  tags                             = merge({ "ManagedBy" = "Terraform" }, { "Name" = "var.vpc_name" }, var.tag_Variables)
}
/**
 * Subnets
 */
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  count             = length(var.private_subnet) > 0 ? length(var.private_subnet) : 0
  cidr_block        = lookup(var.private_subnet[count.index], "cidr")
  availability_zone = lookup(var.private_subnet[count.index], "az")
  tags              = merge({ "ManagedBy" = "Terraform" }, { "Default_Name" = "${var.vpc_name}-pvt_sub_${count.index + 1}" }, var.tag_Variables)

}
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  count                   = length(var.public_subnet) > 0 ? length(var.public_subnet) : 0
  cidr_block              = lookup(var.public_subnet[count.index], "cidr")
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = lookup(var.public_subnet[count.index], "az")
  tags                    = merge({ "ManagedBy" = "Terraform" }, { "Default_Name" = "${var.vpc_name}-pub_sub_${count.index + 1}" }, var.tag_Variables)

}
/**
 * Gateway
 */
resource "aws_internet_gateway" "main_gateway" {
  vpc_id     = aws_vpc.main_vpc.id
  count      = length(var.public_subnet) > 0 || var.create_ig == true ? 1 : 0
  depends_on = [aws_subnet.public_subnet]
  tags       = merge({ "ManagedBy" = "Terraform" }, { "Default_Name" = "${var.vpc_name}-ig_${count.index + 1}" }, var.tag_Variables)
}

resource "aws_eip" "main_eip" {
  count      = length(var.private_subnet) > 0 || var.create_eip == true ? 1 : 0
  vpc        = true
  depends_on = [aws_internet_gateway.main_gateway]
  tags       = merge({ "ManagedBy" = "Terraform" }, { "Default_Name" = "${var.vpc_name}-eip_${count.index + 1}" }, var.tag_Variables)
}
resource "aws_nat_gateway" "main_natgateway" {
  count         = length(var.private_subnet) > 0 || var.create_nat_gateway == true ? 1 : 0
  allocation_id = aws_eip.main_eip[count.index].id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 1)
  depends_on    = [aws_internet_gateway.main_gateway, aws_subnet.public_subnet]
  tags          = merge({ "ManagedBy" = "Terraform" }, { "Default_Name" = "${var.vpc_name}ng_${count.index + 1}" }, var.tag_Variables)
}
/**
 * Route Tables
 */
resource "aws_route_table" "public_route_table" {
  count  = length(var.public_subnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.main_vpc.id
  tags   = merge({ "ManagedBy" = "Terraform" }, { "Default_Name" = "${var.vpc_name}-pub-rt" }, var.tag_Variables)
}
resource "aws_route" "Public_route" {
  count                  = length(var.public_subnet) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public_route_table[count.index].id
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = aws_internet_gateway.main_gateway[count.index].id
}

resource "aws_route_table" "private_route_table" {
  count  = length(var.private_subnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.main_vpc.id
  tags   = merge({ "ManagedBy" = "Terraform" }, { "Default_Name" = "${var.vpc_name}-default-pvt-rt" }, var.tag_Variables)
}
resource "aws_route" "private_route" {
  count                  = length(var.private_subnet) > 0 ? 1 : 0
  route_table_id         = aws_route_table.private_route_table[count.index].id
  destination_cidr_block = var.destination_cidr_block
  nat_gateway_id            = aws_nat_gateway.main_natgateway[count.index].id
}
/**
 * Route associations
 */
resource "aws_route_table_association" "pvt-rt-association" {
  count          = length(var.private_subnet) > 0 ? 1 : 0
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}

resource "aws_route_table_association" "pub-rt-association" {
  count          = length(var.public_subnet) > 0 ? 1 : 0
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table[count.index].id
}


# Security Group Creation
resource "aws_security_group" "main_vpc_sg" {
  count  = var.create_Security_Group ==true ? 1 : 0
  name   = "${var.vpc_name}-sg"
  vpc_id = aws_vpc.main_vpc.id
  tags   = merge({ "ManagedBy" = "Terraform" }, { "Default_Name" = "${var.vpc_name}-sg" }, var.tag_Variables)

}

# Ingress Security rule
resource "aws_security_group_rule" "inbound_rule" {
  count             = var.create_Security_Group ? length (var.ingress_rules) :0
  from_port         = lookup(var.port_protocol[count.index], "from_port")
  protocol          = lookup(var.port_protocol[count.index], "protocol")
  security_group_id = aws_security_group.main_vpc_sg[count.index].id
  to_port           = lookup(var.port_protocol[count.index], "to_port")
  type              = "ingress"
  cidr_blocks       = var.whitelist_ips
}

# All egress Access
resource "aws_security_group_rule" "all_outbound_access" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.main_vpc_sg[0].id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}
