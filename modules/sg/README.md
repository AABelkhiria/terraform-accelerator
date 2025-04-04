# Security Group Module

Terraform module for creating AWS Security Groups with flexible ingress/egress rules.

## Features

- Dynamic ingress/egress rule configuration
- Default all-outbound traffic allowance
- IPv4/IPv6 support
- Integration with other security groups
- Tagging support

## Usage Example

```hcl
module "web_sg" {
  source = "git::https://github.com/AABelkhiria/terraform-accelerator.git//modules/security-group?ref=main"

  name        = "web-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Security group for web servers"

  ingress_rules = [
    {
      description = "HTTP access"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "SSH access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      source_security_group_ids = [module.bastion_sg.id]
    }
  ]

  tags = {
    Environment = "production"
  }
}
```

## Input Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `name` | Security group name | `string` | Required |
| `vpc_id` | VPC ID | `string` | Required |
| `ingress_rules` | List of ingress rules | `list(object)` | `[]` |
| `egress_rules` | List of egress rules | `list(object)` | `[]` |
| `allow_all_egress` | Allow all outbound traffic if no egress rules | `bool` | `true` |
| `tags` | Additional tags | `map(string)` | `{}` |

### Rule Object Properties
```hcl
{
  description                = "Rule description"
  from_port                  = 80
  to_port                    = 80
  protocol                   = "tcp"
  cidr_blocks               = ["10.0.0.0/16"]
  ipv6_cidr_blocks          = ["2001:db8::/32"]
  prefix_list_ids           = ["pl-12345678"]
  source_security_group_ids = ["sg-12345678"] # For ingress rules
  security_group_ids        = ["sg-87654321"] # For egress rules
}
```

## Best Practices

1. **Least Privilege**: Only open necessary ports
2. **Security Group References**: Use security group IDs instead of CIDR blocks when possible
3. **Tagging**: Include environment and purpose in tags
4. **Protocol Selection**: Use specific protocols instead of `-1` (all protocols)
5. **Validation**: Use network policies to validate rules

## Integration with Other Modules

```hcl
module "app_server" {
  # ...
  security_group_ids = [module.web_sg.id]
}

module "lb" {
  # ...
  security_groups    = [module.web_sg.id]
}
```
