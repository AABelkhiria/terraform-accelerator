# Example: Simple EC2 Instance with Security Group

This example demonstrates how to use the reusable `ec2` and `sg` modules from this accelerator repository to create a basic AWS EC2 instance with an associated Security Group.

## Features

*   Creates a Security Group allowing SSH from anywhere (Warning: Insecure default!).
*   Launches an EC2 instance using the latest Amazon Linux 2 AMI.
*   Associates the created Security Group with the instance.
*   Uses data sources to find default VPC and Subnets, simplifying setup.

## Prerequisites

1.  **Terraform:** Install Terraform (>= 1.0).
2.  **AWS Credentials:** Configure your AWS credentials securely (e.g., via environment variables `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`, or via `~/.aws/credentials`). Ensure the credentials have permissions to create VPC, EC2, and related resources.
3.  **EC2 Key Pair:** (Optional, but required for SSH access) Create an EC2 Key Pair in the target AWS region you intend to use. You will need the name of this key pair.

## Configuration and Setup

Before running Terraform, ensure you have the necessary AWS configurations set up. Below are some key configurations to help you dynamically retrieve AWS resources.

*   **Configure the AWS Region:** Set the AWS region in your `terraform.tfvars` file or directly in the `provider` block. For example:

```terraform
provider "aws" {
    region = "us-east-1"
}
```

*   **Find the Latest Amazon Linux 2 AMI:** To get the latest Amazon Linux 2 AMI ID, use:

```terraform
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "ami_id" {
  value = data.aws_ami.amazon_linux_2.id
}
```

*   **Find the Default VPC:** To get the default VPC details (useful for Security Groups, Subnets, etc.), use:

```terraform
data "aws_vpc" "default" {
    default = true
}
```

## How to Use

1.  **Navigate to Example Directory:**
    ```bash
    cd examples/simple-ec2-with-sg
    ```

2.  **Initialize Terraform:**
    This downloads the necessary provider plugins.
    ```bash
    terraform init
    ```

3.  **Plan the Deployment:**
    Review the resources Terraform plans to create.
    ```bash
    terraform plan # Add -var-file=terraform.tfvars if not using the default filename
    ```

4.  **Apply the Configuration:**
    Create the resources in your AWS account.
    ```bash
    terraform apply # Add -var-file=terraform.tfvars if not using the default filename
    ```
    Type `yes` when prompted to confirm.

*   **⚠️ Important Security Note:** The default Security Group rule allows SSH (port 22) from `0.0.0.0/0` (any IP address). This is **highly insecure** and only intended for a quick start. For any real use case, modify the `ingress_rules` in `main.tf` to restrict the `cidr_blocks` to your specific IP address (`["YOUR_IP/32"]`).

## Connecting via SSH

*   Once `terraform apply` is complete, check the outputs for `instance_public_ip` and `ssh_info`.
*   If you provided a valid `key_pair_name`, use your private key file (`.pem`) corresponding to that name to connect:

    ```bash
    ssh -i <path/to/your-key-name>.pem ec2-user@<PUBLIC_IP>
    ```
    *(The default username for Amazon Linux 2 AMIs is `ec2-user`)*

## Cleaning Up

*   To destroy the resources created by this example and avoid further charges:
    ```bash
    terraform destroy
    ```
    Type `yes` when prompted.
