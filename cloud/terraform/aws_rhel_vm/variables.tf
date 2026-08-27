variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
}

variable "name_tag" {
  description = "Base name used for EC2 and related resources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the RHEL instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}

variable "public_key" {
  description = "SSH public key material for the EC2 key pair"
  type        = string
}

variable "owner" {
  description = "Owner tag for cost attribution and inventory keyed groups"
  type        = string
  default     = "apd-demo"
}

variable "blueprint" {
  description = "Blueprint tag for inventory keyed groups"
  type        = string
  default     = "rhel9"
}

variable "deployment" {
  description = "Deployment tag for inventory keyed groups"
  type        = string
  default     = "terraform"
}

variable "purpose" {
  description = "Purpose tag for inventory keyed groups"
  type        = string
  default     = "demo"
}
