# ./outputs.tf

output "instance_id" {
  description = "The ID of the created EC2 instance."
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "The ARN of the created EC2 instance."
  value       = aws_instance.this.arn
}

output "primary_network_interface_id" {
  description = "The ID of the primary network interface."
  value       = aws_instance.this.primary_network_interface_id
}

output "private_ip" {
  description = "The private IP address assigned to the instance."
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable."
  value       = aws_instance.this.public_ip # Will be null if associate_public_ip_address is false
}

output "public_dns" {
  description = "The public DNS name assigned to the instance, if applicable."
  value       = aws_instance.this.public_dns # Will be null if associate_public_ip_address is false or no public DNS assigned
}

output "instance_state" {
  description = "The state of the instance."
  value       = aws_instance.this.instance_state
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including default tags."
  value       = aws_instance.this.tags_all
}
