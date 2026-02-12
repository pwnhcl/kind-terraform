resource "aws_instance" "ec2_instance" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t2.medium"
  key_name      = aws_key_pair.terra_key.key_name
  subnet_id     = data.aws_subnets.default.ids[0]

  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  availability_zone      = "ap-south-1a"
  
  root_block_device {
    volume_size = 25
    volume_type = "gp3"
    delete_on_termination = true
  }


  user_data = templatefile("${path.module}/userdata.sh.tpl", {
    kind_install = file("${path.module}/kind_install.sh")
    kind_config  = file("${path.module}/config.yml")
  })

  tags = {
    Name = "kind-terraform-instance"
  }
}