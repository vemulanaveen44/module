provider "aws" {
  region = "ap-northeast-2"

}
module "myinstance" {
  source = "../modules/ec2"
  instance_type = "m4.large"
}