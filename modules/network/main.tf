data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

data "aws_ec2_instance_type" "bigip" {
  instance_type = var.bigip_instance_type
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway   = true
  enable_vpn_gateway   = false
  enable_dns_hostnames = true
}

resource "aws_security_group" "bigip" {
  name   = "bigip_ssh"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bigip" {
  instance_type = var.bigip_instance_type
  ami = "ami-09ae9af26d2e96786"

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.bigip.id]

  lifecycle {
    precondition {
      condition     = data.aws_ec2_instance_type.bigip.default_cores <= 4
      error_message = "Change the value of bigip_instance_type to a type that has 4 or fewer cores to avoid over provisioning."
    }
  }
}
