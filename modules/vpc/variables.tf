variable "name" {
  description = "Base name for all resources"
  type        = string
}

variable "cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnets with AZ and CIDR"
  type = list(object({
    cidr = string
    az   = string
  }))
  default = []
}

variable "private_subnets" {
  description = "List of private subnets with AZ and CIDR"
  type = list(object({
    cidr = string
    az   = string
  }))
  default = []
}

variable "enable_nat_gateway" {
  description = "Create NAT gateways for private subnets"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in VPC"
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Enable VPC flow logging"
  type        = bool
  default     = false
}

variable "flow_log_destination_arn" {
  description = "ARN of flow log destination (CloudWatch or S3)"
  type        = string
  default     = null
}

variable "flow_log_iam_role_arn" {
  description = "ARN of IAM role for flow logs"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}
