variable "repository_name" {
  description = "Name of the ECR repository (must be lowercase)"
  type        = string
}

variable "image_tag_mutability" {
  description = "Tag immutability setting (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "IMMUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "Must be either 'MUTABLE' or 'IMMUTABLE'"
  }
}

variable "encryption_type" {
  description = "Encryption type for the repository (AES256 or KMS)"
  type        = string
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "Must be either 'AES256' or 'KMS'"
  }
}

variable "kms_key_arn" {
  description = "ARN of KMS key to use for encryption (required if encryption_type is KMS)"
  type        = string
  default     = null
}

variable "scan_on_push" {
  description = "Enable vulnerability scanning on push"
  type        = bool
  default     = true
}

variable "lifecycle_policy" {
  description = "JSON formatted lifecycle policy document"
  type        = string
  default     = null
}

variable "repository_policy" {
  description = "JSON formatted repository access policy"
  type        = string
  default     = null
}

variable "force_delete" {
  description = "Force delete repository even if it contains images"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags for the repository"
  type        = map(string)
  default     = {}
}
