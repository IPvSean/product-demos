output "instance_public_ips" {
  description = "Public IP addresses of provisioned instances"
  value       = aws_instance.rhel_server[*].public_ip
}

output "instance_ids" {
  description = "EC2 instance IDs"
  value       = aws_instance.rhel_server[*].id
}

output "instance_names" {
  description = "Name tags of provisioned instances"
  value       = aws_instance.rhel_server[*].tags.Name
}
