### DEFAULT VPC ###

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

### SECURITY GROUP ###

resource "aws_security_group" "allow_echo_proxy" {
  name        = "allow_echo_proxy"
  description = "Allow inbound http traffic on ${var.port}"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description      = "ECHO PROXY"
    from_port        = var.port
    to_port          = var.port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_echo_proxy"
  }
}
