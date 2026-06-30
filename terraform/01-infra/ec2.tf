module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  # Ensure the key pair is created before the EC2 instance
  depends_on = [ module.key_pair ]
  name = "mongo-instance"

  instance_type = "t3.micro"
  key_name      = "${var.name}-key-pair"
  monitoring    = true
  subnet_id     = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.security_group.id]

  ami                         = data.aws_ami.hc-base-ubuntu-2404["amd64"].id
  associate_public_ip_address = true
# Not needed for now
#  vpc_security_group_ids      = [aws_security_group.vault.id]
  iam_instance_profile        = aws_iam_instance_profile.mongodb.name

  user_data = templatefile("${path.module}/templates/mongo-user-data-sh.tftpl",{
    mongo_uri  = var.mongo_uri
    s3_bucket  = module.s3_bucket.s3_bucket_id
    private_ip = module.ec2_instance.private_ip
  })


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "${var.name}-key-pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDfMvcmry3YeawklPykexcfy2enT1/wpz9+C2wyPhvm8UcvfS87UsG+YiyAZAjpLJ5o3TA7FmxE/dVXnMbyU7vTdyfxwFw3kGYhQztT4dbexNM+9ykw6ynsPigRx5bjDtxKjrvhot/SH9UXwQnP3K/HkR8C+GlthmWjGhMwqck7/HkpFVGsJ2DzFSLdWK+5AfnG3fw6c/qU0421ou7ZpOCwEaNJRnWV2+pEdEIiMP89VNbocH4UlPjH8VfWlUdeyAglGq5B2NyIHq+nZppx8t+GgvxMB+Gh/byLOVKSGlkmgVYLszpEh3+sRZAvAs/g7klKW75MQ+RZMfxLebFo8gYqU73B+MuQ8R4V3bVwhKKCwdfzvH/fd8VIYiSe+Gr49qCAonB0ZYE+2xF6X9csy6kXpW3YAvpIQ7/lKA/6iXJOT+Nr9H2gfsBvC7Zj1CRikLC8UmqS6OFg2Whs1W+7vlKdZFJCozP7eaev1lkSdUoNskRQkyMdcgOXvpkhw3oqYmM= tfe_key"
}

data "aws_ami" "hc-base-ubuntu-2404" {
  for_each = toset(["amd64", "arm64"])

  filter {
    name   = "name"
    values = [format("ubuntu/images/*/ubuntu-jammy-22.04-%s-server-*", each.value)]
  }

  # Matches images built in June 2025 (e.g., ...server-20250615)
#  name_regex = "-202506[0-12]{2}$"

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  most_recent = true
  owners      = ["099720109477"]
}
