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

locals {
  application_type_map = {
    "default" = {
      "instancies" = {
        "netology_1" = {
          "ami"           = data.aws_ami.ubuntu.id
          "instance_type" = "t3.micro"
          "tags"          = { "project" : "netology" }
        }
      }
    }
    "stage" = {
      "instancies" = {
        "netology_1" = {
          "ami"           = data.aws_ami.ubuntu.id
          "instance_type" = "t3.micro"
          "tags"          = { "project" : "netology" }
        }
      }
    }
    "prod" = {
      "instancies" = {
        "netology_1" = {
          "ami"           = data.aws_ami.ubuntu.id
          "instance_type" = "t3.micro"
          "tags"          = { "project" : "netology" }
        }
        "netology_2" = {
          "ami"           = data.aws_ami.ubuntu.id
          "instance_type" = "t3.micro"
          "tags"          = { "project" : "netology" }
        }
      }
    }
  }
}

module "ec2_multiple" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = local.application_type_map[terraform.workspace].instancies

  name = "host_${each.key}"

  ami           = each.value.ami
  instance_type = each.value.instance_type

  tags = each.value.tags
}
