# resource "aws_instance" "ec2_instance" {
#   ami           = "ami-02b8269d5e85954ef"
#   instance_type = "t2.medium"
#   key_name      = aws_key_pair.terra_key.key_name
#   subnet_id     = data.aws_subnets.default.ids[0]

#   vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
#   availability_zone      = "ap-south-1a"

#   root_block_device {
#     volume_size = 25
#     volume_type = "gp3"
#     delete_on_termination = true
#   }


#   user_data = templatefile("${path.module}/userdata.sh.tpl", {
#     kind_install = file("${path.module}/kind_install.sh")
#     kind_config  = file("${path.module}/config.yml")
#   })

#   tags = {
#     Name = "kind-terraform-instance"
#   }
# }

resource "aws_instance" "k3s_nodes" {
  count         = var.instance_count
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t3.small"
  key_name      = aws_key_pair.terra_key.key_name
  subnet_id     = data.aws_subnets.default.ids[0]

  # ✅ FIXED
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  root_block_device {
    volume_size           = 10
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "k3s-node${count.index + 1}"
  }

  user_data = <<-EOF
              #!/bin/bash

              hostnamectl set-hostname k3s-node${count.index + 1}
              timedatectl set-timezone Asia/Kolkata
              apt update -y



              EOF
}

# resource "aws_ebs_volume" "longhorn_ebs" {
#   count             = 3
#   availability_zone = aws_instance.k3s_nodes[count.index].availability_zone

#   size = 10
#   type = "gp3"

#   tags = {
#     Name = "longhorn-disk-${count.index + 1}"
#   }
# }
# resource "aws_volume_attachment" "longhorn_attach" {
#   count = 3

#   device_name = "/dev/xvdb"

#   volume_id   = aws_ebs_volume.longhorn_ebs[count.index].id
#   instance_id = aws_instance.k3s_nodes[count.index].id

#   force_detach = true
# }