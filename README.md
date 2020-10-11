### VPC Module For AWS

## What does this Module do ?
This module will create a VPC in AWS. VPC have various resource attached to it .This Modules can launch a VPC in public and Private subnet in different azs as per the user input .This Module Provides the flexibility of creating the aws resources according to the user input.

### List of resources Created by this modules
```
1. VPC
2. Subnet
3. Internet Gateway
4. Nat Gateway
5. Elastic Ip
6. Route Tables
7. Route associations
8. Security Groups along with  ingress rule

```

### Examples 
```
module "vpc" {
  source   = ""../modules/aws/vpc"
  vpc_name = "demo"			
  public_subnet = [		
    {
      cidr = "10.0.0.0/24",
      az   = "ap-southeast-2a"
    },
    {
      cidr = "10.0.1.0/24",
      az   = "ap-southeast-2b"
    },
    {
      cidr = "10.0.2.0/24",
      az   = "ap-southeast-2c"
    }
  ]
  private_subnet = [		
    {
      cidr = "10.0.3.0/24",
      az   = "ap-southeast-2a"
    },
    {
      cidr = "10.0.4.0/24",
      az   = "ap-southeast-2b"
    },
    {
      cidr = "10.0.5.0/24",
      az   = "ap-southeast-2c"
    }
  ]
  tag_Variables = {
    "Environment"="Testing",
    "foo"	 ="bar",
    "upside"	 ="down" 
  }
 
  create_ig = "true"              
  create_eip = "true"		          
  create_nat_gateway = "true"		  
  create_public_route = "true"		
  create_Security_Group="true"		
  destination_cidr_block = "0.0.0.0/0". 
  port_protocol = [
    {
      from_port = "80",
      to_port   = "90",
      protocol  = "tcp"
    },
  ]
  ingress_rules=["http-80-tcp"]         
  whitelist_ips = [ "192.168.23.34/32"]    
  tenancy = "default"		          
  dns_hostnames = "false"		   
  classic_link = "false"		          
  dns_support = "true"		                 
  enable_classiclink_dns_support = "false"	  
  enable_ipv6 = "false"			         
  ```

### Author
This module is maintened by Bibek Roniyar

### License
MIT License
Copyright (c) [2020] [Bibek Roniyar]
See LICENSE for full details.