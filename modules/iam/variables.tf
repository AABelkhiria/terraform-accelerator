variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "service_principal" {
  description = "AWS service principal for assume role policy"
  type        = string
  default     = "ec2.amazonaws.com"
}

variable "assume_role_policy" {
  description = "Custom assume role policy JSON document"
  type        = string
  default     = ""
}

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "Map of inline policy names and documents"
  type        = map(string)
  default     = {}
}

variable "permissions_boundary_arn" {
  description = "ARN of permissions boundary policy"
  type        = string
  default     = ""
}

variable "create_instance_profile" {
  description = "Whether to create an EC2 instance profile"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
