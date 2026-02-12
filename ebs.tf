resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.ec2_instance.id
}


resource "aws_ebs_volume" "example" {
  availability_zone = "ap-south-1a"
  size              = 5
  type              = "gp3"

  tags = {
    Name = "MyEBSVolume"
  }
}