resource "aws_instance" "myec2" {
    ami = data.aws_ami.amzon.image_id
  instance_type = var.instance_type
  tags = {
    Name = "naveen-ec2"
  }
}