provider "aws" {
  region = "ap-northeast-2"

}
module "myinstance" {
  source = "../modules/ec2"
}