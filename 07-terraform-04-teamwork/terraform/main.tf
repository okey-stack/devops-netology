provider "aws" {
  region  = var.region
  profile = "default"
  default_tags {
    tags = var.tags
  }
}

locals {
  instance_type = {
    test = "t2.micro"
    prod = "t3.micro"
  }
  instance_count = {
    test = 1
    prod = 2
  }
  instance_ami = {
    "t2.micro" = data.aws_ami.ubuntu.id
    "t3.micro" = data.aws_ami.ubuntu.id
  }
}

data "aws_caller_identity" "this" {}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = local.instance_type[terraform.workspace]
  availability_zone           = var.az
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ssh.name]
  count                       = local.instance_count[terraform.workspace]
  tags = {
    Name = "Ubuntu-server"
  }
  depends_on = [aws_security_group.ssh]
}

resource "aws_instance" "back" {
  for_each                    = local.instance_ami
  ami                         = each.value
  instance_type               = each.key
  availability_zone           = var.az
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ssh.name]
  tags = {
    Name = "Ubuntu-server"
  }
  depends_on = [aws_security_group.ssh]
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_vpc" "default" {
  default = true
  state   = "available"
}

resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allow ssh traffic to instance"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}