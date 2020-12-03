provider "aws" {
    region = "ap-northeast-2"
    
     
}
variable "allports" {
    type = list
    default = [22,443,80,8080,9200,53]
  
}

resource "aws_security_group" "nscg" {
    name = "allow_tls"
    dynamic "ingress" {
       for_each = var.allports
       content  {
           from_port = ingress.value
           to_port = ingress.value
           protocol = "tcp"
           cidr_blocks = ["0.0.0.0/0"]
       }
    }

  
}

