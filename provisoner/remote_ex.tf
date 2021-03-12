provider "aws" {
  region = "ap-northeast-2"

}




resource "aws_vpc" "siva_vpc" {
  cidr_block           = "12.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "siva_vpc"
  }
}
resource "aws_subnet" "siva_private_subnet" {
  vpc_id            = aws_vpc.siva_vpc.id
  cidr_block        = "12.1.1.0/24"
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
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.siva_gw.id

  }

}
resource "aws_route_table_association" "siva_private_subnet" {
  subnet_id      = aws_subnet.siva_private_subnet.id
  route_table_id = aws_route_table.siva_route.id

}


resource "aws_security_group" "siva" {
  name        = "siva-sg"
  description = "Only Http connection Inbound"
  vpc_id      = aws_vpc.siva_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "siva sg"
    description = "siva sg all allow"
  }
}

resource "aws_key_pair" "siva" {
  key_name   = "siva-key"
  public_key = file("./pub")
}

resource "aws_instance" "sivaec2" {
  ami                         = "ami-06f3207f56dc1ca18"
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [aws_security_group.siva.id]
  subnet_id                   = aws_subnet.siva_private_subnet.id
  key_name                    = "siva-key"

  
  
    
    provisioner "file" {
        source = "./test"
        destination = "/tmp/test"
        connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./private.ppk")
      host        = self.public_ip
    }
    }
    provisioner "file" {
    content     = "ami used: ${self.public_ip}"
    destination = "/tmp/test1"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./private.ppk")
      host        = self.public_ip
    }
    }
     provisioner "remote-exec" {
    inline = [
      "cat /tmp/test",
      "cat /tmp/test1"

      
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./private.ppk")
      host        = self.public_ip
    
     }
    
     
  
     }
     provisioner "local-exec" {
        command = "echo ${aws_instance.sivaec2.public_ip} > a.txt "
     }
}






    

    

