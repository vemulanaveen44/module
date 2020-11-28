provider "aws" {
    region = "ap-northeast-2"
    shared_credentials_file = "C:/Users/naveenvemula/Desktop/teraform/cred"
}
resource "aws_vpc" "naveen_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "naveen_vpc"
  }
}
resource "aws_subnet" "naveen_private_subnet" {
    vpc_id = aws_vpc.naveen_vpc.id
    cidr_block = "10.0.0.0/26"
    availability_zone = "ap-northeast-2c"
    tags = {
        Name = "naveen_private"
        
    }
}
resource "aws_internet_gateway" "naveen_gw" {
    vpc_id = aws_vpc.naveen_vpc.id
    tags = {
        Name = "naveengw"
    }
}
resource "aws_route_table_association" "naveen_private_subnet" {
  subnet_id     = aws_subnet.naveen_private_subnet.id
  route_table_id = aws_vpc.naveen_vpc.main_route_table_id
  
}
resource "aws_route" "naveen_route" {
    route_table_id = aws_vpc.naveen_vpc.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.naveen_gw.id
}

resource "aws_security_group" "naveen" {
    name = "naveen-sg"
    description = "Only Http connection Inbound"
    vpc_id = aws_vpc.naveen_vpc.id
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA3pWpF48VDGMotw4YfQO3FNXSHQ6bS821WYFkqPyNr0bAIkuOYt4edVVRvgF+rDLvSrOn89yNQJYwJRMm4kB1EhW9/LJglrMQaejihPWoiu30/PWORBBT5B9kF8nViEQKwcos4F3vNLKfOm7zzkTNBZ1lD6SpBkSNozMv9u2JLk+mB5RPMKybgH6BUXrokvFVNsxPi8vnnGl61Ls8CjiIalUWHW+AiVfGxgmlAryo25YFgJJrPt61B2LHMMzmcALUNm3CY5RtOYbVtRzECpkyRDZ0WGfZ8k6DyzAFwXNcVHfLwEcpmoJmjORH52H8PCThz+O0Vd+7hbypdpb5W3hHWw== rsa-key-20201126"
}
resource "aws_instance" "naveenec2" {
ami = "ami-06f3207f56dc1ca18"
instance_type = "t2.micro"
associate_public_ip_address = "true"
vpc_security_group_ids = aws_security_group.naveen.id
subnet_id = aws_subnet.naveen_private_subnet.id
key_name = "naveen-key"
 tags = {
     Name = "naveen_ec2"
    
 }
 
}


resource "aws_ebs_volume" "volume" {
  availability_zone = "ap-northeast-2c"
  size              = 1
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.volume.id
  instance_id = aws_instance.naveenec2.id
}


output "ip_addr" {
    value = [aws_instance.naveenec2.availability_zone,aws_instance.naveenec2.public_ip,aws_instance.naveenec2.tags.Name]
    
}







