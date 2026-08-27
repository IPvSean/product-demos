provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "rhel_server" {
  name_prefix = "${var.name_tag}-sg-"
  description = "Security group for Terraform demo RHEL server"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.name_tag}-sg"
    managed-by = "aap-product-demos"
    apd        = "true"
    deployment = var.deployment
    purpose    = var.purpose
    owner      = var.owner
    blueprint  = var.blueprint
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.name_tag}-keypair"
  public_key = var.public_key

  tags = {
    Name       = "${var.name_tag}-keypair"
    managed-by = "aap-product-demos"
    apd        = "true"
    deployment = var.deployment
    purpose    = var.purpose
    owner      = var.owner
    blueprint  = var.blueprint
  }
}

resource "aws_instance" "rhel_server" {
  count = var.instance_count

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.rhel_server.id]

  tags = {
    Name        = "${var.name_tag}-${count.index + 1}"
    managed-by  = "aap-product-demos"
    apd         = "true"
    deployment  = var.deployment
    purpose     = var.purpose
    owner       = var.owner
    blueprint   = var.blueprint
    Provisioner = "Terraform"
    Manager     = "Ansible"
  }

  lifecycle {
    create_before_destroy = true
  }
}
