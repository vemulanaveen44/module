provider "aws" {
    region = var.region
    
}


# count examples it will create 3 users with like user1 user2 user3
resource "aws_iam_user" "iamuser" {
    #name = "user${count.index}"
    name = var.iamusers[count.index]
    path = "/system"
    count = 3
  
}
variable "iamusers" {
    type = list
    default = ["naveen","lucky","nikhil"]
  
}

