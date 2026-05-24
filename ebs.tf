# resource "aws_volume_attachment" "ebs_att" {
#   device_name = "/dev/sdh"
#   volume_id   = aws_ebs_volume.example.id
#   instance_id = aws_instance.ec2_instance.id
# }


# resource "aws_ebs_volume" "example" {
#   availability_zone = "ap-south-1a"
#   size              = 5
#   type              = "gp3"

#   tags = {
#     Name = "MyEBSVolume"
#   }
# }

resource "aws_ebs_volume" "longhorn_ebs" {
  count             = 3
  availability_zone = aws_instance.k3s_nodes[count.index].availability_zone

  size = 5
  type = "gp3"

  tags = {
    Name = "longhorn-disk-${count.index + 1}"
  }
}
resource "aws_volume_attachment" "longhorn_attach" {
  count = 3

  device_name = "/dev/xvdb"

  volume_id   = aws_ebs_volume.longhorn_ebs[count.index].id
  instance_id = aws_instance.k3s_nodes[count.index].id

  force_detach = true
}