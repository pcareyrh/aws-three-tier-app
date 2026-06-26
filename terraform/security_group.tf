resource "aws_ec2_managed_prefix_list" "private_subnets" {
  name           = "${var.name}-private-subnets"
  address_family = "IPv4"
  max_entries    = length(module.vpc.private_subnets_cidr_blocks)

  dynamic "entry" {
    for_each = module.vpc.private_subnets_cidr_blocks

    content {
      cidr        = entry.value
      description = "Private subnet ${entry.key}"
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.name}-sg-mongo"
  description = "patrick-mongo security group"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = {
    mongodb = {
      from_port   = 27017
      to_port     = 27017
      ip_protocol = "tcp"
      prefix_list_id = aws_ec2_managed_prefix_list.private_subnets.id
      description = "MongoDB from internal"
    }
    ssh = {
      from_port   = 22
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "SSH from external"
    }
    self-all = {
      ip_protocol                  = "-1"
      referenced_security_group_id = "self"
      description                  = "All traffic from members of this SG"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = {
    Environment = "dev"
  }
}