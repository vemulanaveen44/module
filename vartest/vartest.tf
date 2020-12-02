provider "aws" {
    region = var.region
    
}


resource "aws_vpc" "naveen_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

 tags = {
    Name = "naveen_vpc"
  }
}

output "listout" {
    

    value = [var.list[0], var.list[1]]
    
  
}

output "map" {
  value = var.exmap["small"]
}

  resource "aws_subnet" "naveen_private_subnet" {
      count = length(data.aws_availability_zones.azs.names)
    vpc_id = aws_vpc.naveen_vpc.id
    cidr_block = element(var.subnet_cidr,count.index)
    availability_zone = element(data.aws_availability_zones.azs.names,count.index)
  
    tags = {
        Name = "naveen_private-${count.index+1}"
        
    }
}


