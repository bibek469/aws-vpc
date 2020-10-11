variable "vpc_name" {
  description = "The CIDR block for the VPC."
  type = string
  default     = ""
}

variable "vpc_cidr" {
  description= "VPC CIDR value "
  default = ""
}
variable "public_subnet" {
  description = "List of public subnets"
  type = list
  default = []
}
variable "private_subnet" {
  description = "List of Private subnets"
  type        = list
  default = []
}
variable "tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default = "default"
}
variable "dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = false
}
variable "classic_link" {
  description = "Should be true to enable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic."
  type        = bool
  default     = false
}
variable "dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}
variable "enable_classiclink_dns_support" {
  description = "Should be true to enable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic."
  type        = bool
  default     = false
}
variable "enable_ipv6" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block."
  type        = bool
  default     = false
}
variable "tag_Variables" {
  type = map
  default={}
}
variable "create_ig" {
  description= "controls if user wants to create internet gateway set TRUE if we need to create"
  type=bool

}
variable "map_public_ip_on_launch" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address."
  type=bool
  default="false"
}
variable "create_eip"{
  description= "set true if we want to create it"
  type= bool

}
variable "create_nat_gateway" {
  description= "set true if we want to create it"
  type= bool

}

variable "create_public_route" {
  description = "set if you want to create the external route"
  type = bool

}
variable "destination_cidr_block" {
  description = "The destination CIDR block "

}
variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  type        = list(string)
  default     = []
}
variable "create_Security_Group" {
  description = "Whether to create security group and all rules"
  type        = bool
  default     = true
}

variable "whitelist_ips" {
  type = list
  default=[]

}
variable "port_protocol" {
  description = "List of to_port, from_port and protocol "
  type        = list
  default =[]
}