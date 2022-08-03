### ECHO PROXY ### 

resource "aws_instance" "linux_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_echo_proxy.id]

  user_data = templatefile("${path.module}/template/sdm_ssh_install/install.tftpl", { HTTP_PORT = "${var.port}" })

  tags = {
    Name       = var.instance_name
    Creator    = var.creator
    ExpiryDate = "2022-12-31"
  }

  volume_tags = {
    Name = var.instance_name
  }
}
