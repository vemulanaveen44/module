data "aws_ami" "amzon"{
 owners = ["amazon"] 
 most_recent = true
 name_regex = "^amzn2-ami-hvm.*gp2$"
 
}      
variable "instance_type" {
  default = "t2.nano"
}