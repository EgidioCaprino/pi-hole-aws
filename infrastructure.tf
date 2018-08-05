provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

data "http" "icanhazip" {
   url = "http://icanhazip.com"
}

resource "aws_key_pair" "pi_hole_ssh_key" {
  public_key = "${file("./id_rsa.pub")}"
}

locals {
  ip_address = "${replace(data.http.icanhazip.body, "\n", "")}"
}

resource "aws_security_group" "pi_hole_firewall" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${local.ip_address}/32"]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["${local.ip_address}/32"]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["${local.ip_address}/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${local.ip_address}/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "udp"
    cidr_blocks = ["${local.ip_address}/32"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${local.ip_address}/32"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "udp"
    cidr_blocks = ["${local.ip_address}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "pi_hole_server" {
  ami             = "ami-9b495971"
  instance_type   = "t2.micro"
  key_name        = "${aws_key_pair.pi_hole_ssh_key.key_name}"
  security_groups = ["${aws_security_group.pi_hole_firewall.name}"]
}
