variable "region" {
    default = "ap-northeast-2"
  
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
  
}
variable "subnet_cidr" {
  type ="list"
  default = ["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24"]
}

#variable "azs" {
 #   type = "list"
  #  default = ["ap-northeast-2a","ap-northeast-2b","ap-northeast-2c"]

  
#}

data "aws_availability_zones" "azs" {}

variable "list" {
    type = list
    default = ["naveen","siva","nikhal","Nikhil"]
  
}
variable "exmap" {
    type = map
    default = {
        "small" = "t2.nano"
        "medium" = "t2.micro"
        "large" = "t2.large"
    }
  
}