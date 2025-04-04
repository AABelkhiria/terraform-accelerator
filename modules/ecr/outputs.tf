output "arn" {
  description = "Full ARN of the repository"
  value       = aws_ecr_repository.this.arn
}

output "registry_id" {
  description = "Registry ID where the repository exists"
  value       = aws_ecr_repository.this.registry_id
}

output "repository_url" {
  description = "URL of the repository"
  value       = aws_ecr_repository.this.repository_url
}

output "encryption_configuration" {
  description = "Encryption configuration details"
  value       = aws_ecr_repository.this.encryption_configuration
}

output "lifecycle_policy" {
  description = "Applied lifecycle policy document"
  value       = try(aws_ecr_lifecycle_policy.this[0].policy, null)
}

output "repository_policy" {
  description = "Applied repository access policy"
  value       = try(aws_ecr_repository_policy.this[0].policy, null)
}
