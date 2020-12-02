provider "aws" {
    region = "ap-northeast-2"
    
     
}

# count examples it will create 3 users with like user1 user2 user3
/*
resource "aws_iam_user" "iamuser" {
    #name = "user${count.index}"
    name = var.iamusers[count.index]
    path = "/system"
    count = 3
  
}
*/
variable "iamusers" {
    type = list
    default = ["naveen","lucky","nikhil"]
  
}

# count with with condition
variable "istest" {
    default=false
}
resource "aws_iam_user" "true" {
    name = "naveen1"
    path = "/system"
    count = var.istest == true ? 1 : 0
}
resource "aws_iam_user" "false" {
    name = var.iamusers[count.index]
    path = "/system"
    count = var.istest == false ? 3 : 0
  
}



