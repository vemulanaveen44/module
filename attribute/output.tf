provider "aws" {
    region = "ap-northeast-2"
    
     
}
variable "cidr" {
    type=list
    default = ["10.1.0.0/16","11.1.0.0/16"]
  
}
variable "vpcname" {
    type=list
    default = ["naveen_vpc"]
  
}
variable "subnetcidr" {
    type=list
    default = ["10.1.1.0/24","10.1.2.0/24"]
  
}
variable "subnetnames" {
    type=list
    default = ["naveen-public","naveen-private"]
  
}
resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr[count.index]
    instance_tenancy = "default"
   enable_dns_hostnames = true
   enable_dns_support = true
    count = 1
    tags = {
      "Name" = var.vpcname[count.index]
      count = 1
    }
  
}
resource "aws_internet_gateway" "naveenigw" {
    vpc_id = aws_vpc.myvpc[0].id
    tags = {
      "Name" = "naveen-igw"
    }
  
}

resource "aws_subnet" "naveen_subnet" {
    vpc_id = aws_vpc.myvpc[0].id
    availability_zone = "ap-northeast-2c"
    map_public_ip_on_launch = true

    cidr_block = var.subnetcidr[count.index]
    count=2
    
    tags = {
        Name = var.subnetnames[count.index]
        
    }
}
resource "aws_route_table" "rpu" {
    vpc_id = aws_vpc.myvpc[0].id
    route {
    cidr_block = "12.1.0.0/16"
     vpc_peering_connection_id = aws_vpc_peering_connection.vpcpeering.id
    }
    route   {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.naveenigw.id
      
    } 
    
  tags = {
    "Name" = "naveen-public"
  }
}
resource "aws_route_table" "rpriv" {
    vpc_id = aws_vpc.myvpc[0].id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.naveen-nat.id
    }
    tags = {
      "Name" = "naveen-private"
    }
  
}
resource "aws_route_table_association" "naveen_public" {
  subnet_id     = aws_subnet.naveen_subnet[0].id
  route_table_id = aws_route_table.rpu.id
}
resource "aws_route_table_association" "naveen_private" {
  subnet_id     = aws_subnet.naveen_subnet[1].id
  route_table_id = aws_route_table.rpriv.id
}
resource "aws_security_group" "naveen" {
    name = "naveen-sg"
    description = "Only Http connection Inbound"
    vpc_id = aws_vpc.myvpc[0].id
    ingress {
        from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }

ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
}
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
tags = {
    Name= "naveen sg"
    description= "naveen sg all allow"
}
}
resource "aws_key_pair" "deployer" {
  key_name   = "naveen-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAuZ6a2AHIrSNhhPtUfQ7h8wyrCc6oX2LmZ3e6etxqmwgihXOna3bDMZgb/i5zSJqcfcGa72iK0Mru4wW3vg+78wvT1R7lfanEHy7v0tUkTLxqtvruVb9wxmWN60jLdfyWD+xRrI0eLVnpCdjPmgfz5uekppAqFFoPmw5OeyoAKGDphmQA46Wz+qxMxLqtti0ZGJKzloSWEBkMBEzA1G/FIdNti0mqPCM74QDm/j441DiqgjbNbzY1I7y7LqH03fzqdEv641a7i6k3/2mVYDYFJ2hDc20sl77ozuRmhPdR0wWRkRcH2M0oMBcAvAq4L1YeyjTGOaFcme3bXEyoRPo3uQ== rsa-key-20210306"
}
resource "aws_instance" "naveenec2" {
ami = "ami-06f3207f56dc1ca18"
instance_type = "t2.micro"
associate_public_ip_address = "true"
vpc_security_group_ids = [aws_security_group.naveen.id]
subnet_id = aws_subnet.naveen_subnet[0].id
key_name = "naveen-key"
 tags = {
     Name = "naveen_ec2"
    
 }
 
}
resource "aws_instance" "naveenec2-priv" {
ami = "ami-06f3207f56dc1ca18"
instance_type = "t2.micro"
associate_public_ip_address = "true"
vpc_security_group_ids = [aws_security_group.naveen.id]
subnet_id = aws_subnet.naveen_subnet[1].id
key_name = "naveen-key"
 tags = {
     Name = "naveen_private"
    
 }
 
}
# Nat gate way configuration
resource "aws_eip" "nat-eip" {
    vpc = true
  
}
resource "aws_nat_gateway" "naveen-nat" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id = aws_subnet.naveen_subnet[0].id
  tags = {
    "Name" = "naveen-nat"
  }
}
/*
output "vpcid" {

  value = aws_vpc.myvpc[1].id
}
*/
resource "aws_vpc" "siva_vpc" {
  cidr_block       = "12.1.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "siva_vpc"
  }
}
resource "aws_subnet" "siva_private_subnet" {
    vpc_id = aws_vpc.siva_vpc.id
    cidr_block = "12.1.1.0/24"
    availability_zone = "ap-northeast-2c"
    tags = {
        Name = "siva_private"
        
    }
}
resource "aws_internet_gateway" "siva_gw" {
    vpc_id = aws_vpc.siva_vpc.id
    tags = {
        Name = "sivagw"
    }
}
resource "aws_route_table" "siva_route" {
    vpc_id = aws_vpc.siva_vpc.id
	route{
    cidr_block = var.cidr[0]
     vpc_peering_connection_id = aws_vpc_peering_connection.vpcpeering.id
	 }
    route   {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.siva_gw.id
      
    } 
}
resource "aws_route_table_association" "siva_private_subnet" {
  subnet_id     = aws_subnet.siva_private_subnet.id
  route_table_id = aws_vpc.siva_vpc.main_route_table_id
  
}


resource "aws_security_group" "siva" {
    name = "siva-sg"
    description = "Only Http connection Inbound"
    vpc_id = aws_vpc.siva_vpc.id
    ingress {
        from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }

ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
}
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
tags = {
    Name= "siva sg"
    description= "siva sg all allow"
}
}

resource "aws_key_pair" "siva" {
  key_name   = "siva-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAuZ6a2AHIrSNhhPtUfQ7h8wyrCc6oX2LmZ3e6etxqmwgihXOna3bDMZgb/i5zSJqcfcGa72iK0Mru4wW3vg+78wvT1R7lfanEHy7v0tUkTLxqtvruVb9wxmWN60jLdfyWD+xRrI0eLVnpCdjPmgfz5uekppAqFFoPmw5OeyoAKGDphmQA46Wz+qxMxLqtti0ZGJKzloSWEBkMBEzA1G/FIdNti0mqPCM74QDm/j441DiqgjbNbzY1I7y7LqH03fzqdEv641a7i6k3/2mVYDYFJ2hDc20sl77ozuRmhPdR0wWRkRcH2M0oMBcAvAq4L1YeyjTGOaFcme3bXEyoRPo3uQ== rsa-key-20210306"
}

resource "aws_instance" "sivaec2" {
ami = "ami-06f3207f56dc1ca18"
instance_type = "t2.micro"
associate_public_ip_address = "true"
vpc_security_group_ids = [aws_security_group.siva.id]
subnet_id = aws_subnet.siva_private_subnet.id
key_name = "siva-key"
 tags = {
     Name = "siva_ec2"
    
 }
 
}
#vpc peering
data "aws_caller_identity" "current" {}
resource "aws_vpc_peering_connection" "vpcpeering" {
    peer_owner_id = data.aws_caller_identity.current.account_id
    peer_vpc_id = aws_vpc.siva_vpc.id
    vpc_id = aws_vpc.myvpc[0].id
    auto_accept = true
  
}