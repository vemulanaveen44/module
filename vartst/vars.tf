provider "aws" {
    region = "ap-northeast-2"
  
}
variable "allportsall" {
    type=list(number)
    default = [443,80,3306,9200,80]
  
}
resource "aws_security_group" "allow_tls" {
    name = "allow_tls"
    dynamic "ingress"{
        for_each = var.allportsall
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
  
}
resource "aws_iam_user" "iamuser" {
  name ="iamuser.${count.index +1}"
  count = 3
}
output "arns" {
  value=aws_iam_user.iamuser[*].arn
  
}