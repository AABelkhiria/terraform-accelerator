# IAM Role Module

This Terraform module creates an IAM role with optional managed policies, inline policies, a permissions boundary, and an instance profile (for EC2 instances).

## Usage

To use this module, include it in your Terraform configuration:

```terraform
module "iam_role" {
  source = "git::https://github.com/AABelkhiria/terraform-accelerator.git//modules/iam?ref=main"

  role_name = "my-application-role"
  service_principal = "ec2.amazonaws.com"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
  tags = {
    Environment = "Development"
    Project     = "MyApplication"
  }
}

output "role_arn" {
  value = module.iam_role.role_arn
}
```

## Variables

Here's a detailed explanation of each variable you can configure:

*   **`role_name`** (string, required): The name of the IAM role to create.  This name must be unique within your AWS account.

    Example:

    ```terraform
    role_name = "my-web-server-role"
    ```

*   **`service_principal`** (string, optional, default: `"ec2.amazonaws.com"`):  The AWS service principal that can assume this role.  This defines which AWS service is authorized to use the role.  Common values include:

    *   `ec2.amazonaws.com`:  For EC2 instances.
    *   `lambda.amazonaws.com`: For Lambda functions.
    *   `ecs-tasks.amazonaws.com`: For ECS tasks.
    *   `s3.amazonaws.com`: For S3.
    *   And others.

    Example:

    ```terraform
    service_principal = "lambda.amazonaws.com"
    ```

*   **`assume_role_policy`** (string, optional, default: `""`):  A custom assume role policy JSON document.  If provided, this overrides the default `assume_role_policy` created using the `service_principal`. Use this to create more complex assume role policies.  If you use this, you're responsible for providing a *valid* JSON document.  It is usually better to rely on the `service_principal` alone unless you have very specific requirements.

    Example:

    ```terraform
    assume_role_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::123456789012:root" # Replace with your account ID or another IAM entity.
          }
        }
      ]
    })
    ```

*   **`managed_policy_arns`** (list(string), optional, default: `[]`): A list of Amazon Resource Names (ARNs) of AWS managed policies to attach to the role.  Managed policies provide pre-defined sets of permissions.  Example policies: `arn:aws:iam::aws:policy/ReadOnlyAccess`, `arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess`, `arn:aws:iam::aws:policy/AWSLambdaBasicExecutionRole`

    Example:

    ```terraform
    managed_policy_arns = [
      "arn:aws:iam::aws:policy/ReadOnlyAccess",
      "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    ]
    ```

*   **`inline_policies`** (map(string), optional, default: `{}`): A map of inline policy names and JSON documents.  Inline policies are defined directly within the role.  Each key in the map is the policy name, and the value is the JSON document defining the policy.

    Example:

    ```terraform
    inline_policies = {
      "s3-read-write" = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action   = [
              "s3:GetObject",
              "s3:PutObject"
            ],
            Effect   = "Allow",
            Resource = "arn:aws:s3:::my-bucket/*"  # Replace with your bucket ARN
          }
        ]
      })
    }
    ```

*   **`permissions_boundary_arn`** (string, optional, default: `""`): The ARN of an IAM policy to use as a permissions boundary for the role. A permissions boundary limits the maximum permissions that the role can have.

    Example:

    ```terraform
    permissions_boundary_arn = "arn:aws:iam::aws:policy/MyCustomPermissionsBoundary"
    ```

*   **`create_instance_profile`** (bool, optional, default: `true`):  Whether to create an EC2 instance profile for the role.  Instance profiles are used to pass IAM roles to EC2 instances.  Set to `false` if you don't need an instance profile (e.g., if you're creating a role for a Lambda function).

    Example:

    ```terraform
    create_instance_profile = false
    ```

*   **`tags`** (map(string), optional, default: `{}`):  Resource tags to apply to the IAM role and instance profile (if created).

    Example:

    ```terraform
    tags = {
      Environment = "Production"
      Team        = "DevOps"
    }
    ```

## Outputs

The module provides the following outputs:

*   **`role_arn`**: The ARN of the created IAM role. This is a unique identifier for the role within AWS.

*   **`role_name`**: The name of the created IAM role.

*   **`instance_profile_arn`**: The ARN of the created EC2 instance profile (if `create_instance_profile` is `true`).  Will be an empty string if an instance profile was not created.

*   **`policy_arns`**: A list of ARNs of the attached managed policies.

*   **`inline_policy_names`**: A list of the names of the created inline policies.
