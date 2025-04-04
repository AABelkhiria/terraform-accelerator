output "role_arn" {
  description = "ARN of the created IAM role"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Name of the created IAM role"
  value       = aws_iam_role.this.name
}

output "instance_profile_arn" {
  description = "ARN of the instance profile if created"
  value       = try(aws_iam_instance_profile.this[0].arn, "")
}

output "policy_arns" {
  description = "ARNs of attached managed policies"
  value       = aws_iam_role_policy_attachment.managed[*].policy_arn
}

output "inline_policy_names" {
  description = "Names of created inline policies"
  value       = keys(aws_iam_role_policy.inline)
}
