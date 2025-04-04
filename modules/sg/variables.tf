variable "name" {
    description = "Security group name"
    type        = string
  }
  
  variable "description" {
    description = "Security group description"
    type        = string
    default     = null
  }
  
  variable "vpc_id" {
    description = "VPC ID where security group will be created"
    type        = string
  }
  
  variable "ingress_rules" {
    description = "List of ingress rules"
    type = list(object({
      description                = optional(string, "Managed by Terraform")
      from_port                 = number
      to_port                   = number
      protocol                  = optional(string, "tcp")
      cidr_blocks               = optional(list(string), [])
      ipv6_cidr_blocks          = optional(list(string), [])
      prefix_list_ids           = optional(list(string), [])
      source_security_group_ids = optional(list(string), [])
    }))
    default = []
  }
  
  variable "egress_rules" {
    description = "List of egress rules"
    type = list(object({
      description       = optional(string, "Managed by Terraform")
      from_port         = number
      to_port           = number
      protocol          = optional(string, "tcp")
      cidr_blocks       = optional(list(string), [])
      ipv6_cidr_blocks  = optional(list(string), [])
      prefix_list_ids    = optional(list(string), [])
      security_group_ids = optional(list(string), [])
    }))
    default = []
  }
  
  variable "allow_all_egress" {
    description = "Allow all outbound traffic if no egress rules specified"
    type        = bool
    default     = true
  }
  
  variable "tags" {
    description = "Additional tags for the security group"
    type        = map(string)
    default     = {}
  }
  