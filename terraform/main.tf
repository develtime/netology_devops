provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_vpc" "netology_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "netology"
  }
}

resource "aws_subnet" "netology_subnet" {
  vpc_id            = aws_vpc.netology_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "netology"
  }
}

resource "aws_network_interface" "netology_iface" {
  subnet_id   = aws_subnet.netology_subnet.id
  private_ips = ["10.0.1.10"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "demo_host" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.netology_iface.id
    device_index         = 0
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }

  tags = {
    Name = "netology"
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
