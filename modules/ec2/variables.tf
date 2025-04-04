# ./variables.tf

variable "ami" {
  description = "The AMI ID to use for the EC2 instance."
  type        = string
  # No default, this is required.
}

variable "instance_type" {
  description = "The type of instance to start (e.g., t2.micro, m5.large)."
  type        = string
  # No default, this is required.
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the instance into."
  type        = string
  # No default, this is required for explicit placement.
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with the instance."
  type        = list(string)
  default     = []
  # Optional, but highly recommended for network access control.
}

variable "key_name" {
  description = "The key name of the Key Pair to use for the instance (for SSH access)."
  type        = string
  default     = null
  # Optional, but needed for SSH access to Linux instances.
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "The value for the 'Name' tag."
  type        = string
  default     = "ec2-instance"
}

variable "user_data" {
  description = "User data script to execute on instance launch."
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance."
  type        = bool
  default     = true
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with the instance."
  type        = string
  default     = null
}

variable "root_block_device" {
  description = "Configuration block for the root block device. Allows customization of size, type, etc."
  type = object({
    volume_size           = optional(number) # Default determined by AMI
    volume_type           = optional(string, "gp3")
    delete_on_termination = optional(bool, true)
    # encrypted             = optional(bool) # Add if needed
    # iops                  = optional(number) # Add if needed (for io1/io2/gp3)
    # throughput            = optional(number) # Add if needed (for gp3)
  })
  default = {} # Use AWS defaults if not specified
}
