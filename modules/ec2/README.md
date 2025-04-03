# EC2 Instance Module

Terraform module for provisioning AWS EC2 instances with best-practice configurations.

## Features

- Secure default configurations
- Flexible storage options
- IAM instance profile integration
- Public/private IP management
- Tagging support
- Detailed monitoring options

## Usage Example

```hcl
module "app_server" {
  source = "git::https://github.com/AABelkhiria/terraform-accelerator.git//modules/ec2?ref=main"

  name                 = "app-server-prod"
  ami                  = "ami-0c55b159cbfafe1f0"
  instance_type        = "t3.medium"
  subnet_id            = module.network.public_subnet_ids[0]
  security_group_ids   = [module.security_group.web_sg_id]
  
  # Optional configurations
  iam_instance_profile = module.app_iam.instance_profile_name
  root_volume_size = 50
  root_block_device = {
    volume_size = 20
  }

  tags = {
    Environment = "production"
    Application = "web-app"
  }
}
```

## Inputs

### Core Configuration (Required)

| Name            | Description                                    | Type     | Required |
| --------------- | ---------------------------------------------- | -------- | :------: |
| `ami`           | ID of the Amazon Machine Image (AMI) to use.   | `string` |   yes    |
| `instance_type` | EC2 instance type (e.g., `t2.micro`, `m5.large`). | `string` |   yes    |
| `subnet_id`     | ID of the Subnet to launch the instance into.  | `string` |   yes    |

### Networking & Security (Optional)

| Name                          | Description                                               | Type           | Default |
| ----------------------------- | --------------------------------------------------------- | -------------- | ------- |
| `vpc_security_group_ids`      | List of Security Group IDs to attach.                     | `list(string)` | `[]`    |
| `associate_public_ip_address` | Assign a public IP address?                               | `bool`         | `true`  |
| `key_name`                    | Name of the EC2 Key Pair for SSH access (recommended).    | `string`       | `null`  |

### Naming & Automation (Optional)

| Name                   | Description                                               | Type           | Default          |
| ---------------------- | --------------------------------------------------------- | -------------- | ---------------- |
| `name`                 | Sets the 'Name' tag for the instance.                     | `string`       | `"ec2-instance"` |
| `tags`                 | Additional tags as a key-value map.                       | `map(string)`  | `{}`             |
| `user_data`            | Script to run automatically on instance launch.           | `string`       | `null`           |
| `iam_instance_profile` | Name of the IAM instance profile (role) to attach.        | `string`       | `null`           |

### Storage (Optional)

| Name                | Description                                                                                           | Type           | Default |
| ------------------- | ----------------------------------------------------------------------------------------------------- | -------------- | ------- |
| `root_block_device` | Customize the root EBS volume. Expects an object with optional keys: `volume_size`, `volume_type`, `delete_on_termination`. | `object({...})`| `{}`    |                                                                                                     | `bool`         | `false`    | No       |

## Outputs

These are the values exported by the module after the EC2 instance is created.

| Name                           | Description                                      |
| ------------------------------ | ------------------------------------------------ |
| `instance_id`                  | The unique ID of the EC2 instance.              |
| `instance_arn`                 | The Amazon Resource Name (ARN) of the instance.  |
| `public_ip`                    | Public IP address assigned (if enabled).         |
| `private_ip`                   | Private IP address assigned within the VPC.      |
| `public_dns`                   | Public DNS name assigned (if enabled).           |
| `primary_network_interface_id` | ID of the instance's primary network interface.   |
| `instance_state`               | The current state of the instance (e.g., running).|
| `tags_all`                     | Map of all tags applied to the instance.         |

## Integration with Other Modules

1. **VPC Module**:
   ```hcl
   subnet_id = module.vpc.public_subnet_ids[0]
   ```

2. **IAM Module**:
   ```hcl
   iam_instance_profile = module.app_iam.instance_profile_name
   ```

3. **Security Group Module**:
   ```hcl
   security_group_ids = [module.security_group.web_sg_id]
   ```

## Best Practices

- Always use IAM roles instead of access keys
- Enable encryption on all EBS volumes
- Use instance profiles from IAM module
- Prefer private IPs for internal communication
- Enable termination protection for production instances