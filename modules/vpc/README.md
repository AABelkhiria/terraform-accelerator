# VPC Module

This Terraform module creates a Virtual Private Cloud (VPC) with public and private subnets, an Internet Gateway, NAT Gateways (optional), route tables, and VPC Flow Logs (optional).

## Usage

To use this module, include it in your Terraform configuration:

```tf
module "vpc" {
  source = "git::https://github.com/AABelkhiria/terraform-accelerator.git//modules/vpc?ref=main"

  name = "my-app"
  cidr_block = "10.0.0.0/16"
  public_subnets = [
    { cidr = "10.0.1.0/24", az = "us-east-1a" },
    { cidr = "10.0.2.0/24", az = "us-east-1b" },
  ]
  private_subnets = [
    { cidr = "10.0.11.0/24", az = "us-east-1a" },
    { cidr = "10.0.12.0/24", az = "us-east-1b" },
  ]
  enable_nat_gateway = true
  enable_flow_logs   = false # Change to true to enable vpc flow logs
  tags = {
    Environment = "Production"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
```

## Variables

Here's a detailed explanation of each variable you can configure:

*   **`name`** (string, required): A base name used for all resources created by the module (e.g., "my-app").  This helps with identifying and organizing resources.

    Example:

    ```terraform
    name = "web-cluster"
    ```

*   **`cidr_block`** (string, optional, default: `"10.0.0.0/16"`): The CIDR block for the VPC. Choose a CIDR block that doesn't overlap with any existing networks.

    Example:

    ```terraform
    cidr_block = "192.168.0.0/16"
    ```

*   **`public_subnets`** (list(object), optional, default: `[]`): A list of public subnets to create. Each subnet is defined by a map containing `cidr` (the subnet's CIDR block) and `az` (the Availability Zone).  Public subnets have direct access to the internet via the Internet Gateway.

    Example:

    ```terraform
    public_subnets = [
      { cidr = "10.0.1.0/24", az = "us-east-1a" },
      { cidr = "10.0.2.0/24", az = "us-east-1b" },
    ]
    ```

*   **`private_subnets`** (list(object), optional, default: `[]`): A list of private subnets to create. Each subnet is defined by a map containing `cidr` (the subnet's CIDR block) and `az` (the Availability Zone). Private subnets do not have direct access to the internet; they typically use NAT Gateways for outbound internet access.

    Example:

    ```terraform
    private_subnets = [
      { cidr = "10.0.11.0/24", az = "us-east-1a" },
      { cidr = "10.0.12.0/24", az = "us-east-1b" },
    ]
    ```

*   **`enable_nat_gateway`** (bool, optional, default: `true`): Determines whether to create NAT Gateways for the private subnets. NAT Gateways allow instances in the private subnets to initiate outbound traffic to the internet while preventing inbound connections from the internet.  If set to `true`, one NAT Gateway will be created *per public subnet*, and private subnet route tables will be configured accordingly.

    Example:

    ```terraform
    enable_nat_gateway = false  # Disable NAT Gateways
    ```

*   **`enable_dns_hostnames`** (bool, optional, default: `true`):  Enables DNS hostnames within the VPC.  When enabled, instances receive a public DNS hostname.

    Example:

    ```terraform
    enable_dns_hostnames = false
    ```

*   **`enable_dns_support`** (bool, optional, default: `true`): Enables DNS support within the VPC.  This is required for instances to resolve DNS queries.

    Example:

    ```terraform
    enable_dns_support = false
    ```

*   **`enable_flow_logs`** (bool, optional, default: `false`):  Enables VPC Flow Logs.  Flow Logs capture information about the IP traffic going to and from network interfaces in your VPC. This information can be used for security analysis, troubleshooting, and compliance.

    Example:

    ```terraform
    enable_flow_logs = true  # Enable VPC Flow Logs
    ```

*   **`flow_log_destination_arn`** (string, optional, default: `null`): The ARN of the destination for VPC Flow Logs.  This can be a CloudWatch Logs log group or an S3 bucket.  *Required* if `enable_flow_logs` is set to `true`.

    Example:

    ```terraform
    flow_log_destination_arn = "arn:aws:logs:us-east-1:123456789012:log-group:my-vpc-flow-logs"  # Replace with your CloudWatch log group ARN
    ```

*   **`flow_log_iam_role_arn`** (string, optional, default: `null`): The ARN of the IAM role that allows VPC Flow Logs to write to the specified destination.  *Required* if `enable_flow_logs` is set to `true`.

    Example:

    ```terraform
    flow_log_iam_role_arn = "arn:aws:iam::123456789012:role/VPCFlowLogsRole"  # Replace with your IAM role ARN
    ```

*   **`tags`** (map(string), optional, default: `{}`):  Additional tags to apply to all resources created by the module.  Tags are key-value pairs that can be used to organize and manage resources.

    Example:

    ```terraform
    tags = {
      Environment = "Staging"
      Team        = "Networking"
    }
    ```

## Outputs

The module provides the following outputs:

*   **`vpc_id`**: The ID of the created VPC.

*   **`public_subnet_ids`**: A list of IDs of the created public subnets.

*   **`private_subnet_ids`**: A list of IDs of the created private subnets.

*   **`nat_gateway_ips`**: A list of public IP addresses assigned to the NAT Gateways.  The number of IPs will match the number of public subnets if `enable_nat_gateway` is `true`.

*   **`internet_gateway_id`**: The ID of the created Internet Gateway.

*   **`public_route_table_id`**: The ID of the public route table.

*   **`private_route_table_ids`**: A list of IDs of the private route tables.

*   **`vpc_cidr_block`**: The CIDR block of the created VPC.
