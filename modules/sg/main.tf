resource "aws_security_group" "this" {
  name        = var.name
  description = coalesce(var.description, "Security group managed by Terraform")
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
      prefix_list_ids  = ingress.value.prefix_list_ids
      security_groups  = ingress.value.source_security_group_ids
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description      = egress.value.description
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks     = egress.value.cidr_blocks
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
      prefix_list_ids  = egress.value.prefix_list_ids
      security_groups  = egress.value.security_group_ids
    }
  }

  dynamic "egress" {
    for_each = local.create_default_egress ? [1] : []
    content {
      description      = "Default outbound allowance"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

locals {
  create_default_egress = var.allow_all_egress && length(var.egress_rules) == 0
}
