# ECR Repository Module

This Terraform module creates an AWS ECR (Elastic Container Registry) repository with options for encryption, image scanning, lifecycle policies, and repository policies.

## Usage

To use this module, include it in your Terraform configuration:

```terraform
module "ecr_repository" {
  source = "git::https://github.com/AABelkhiria/terraform-accelerator.git//modules/ecr?ref=main"

  repository_name      = "my-application-image"
  image_tag_mutability = "IMMUTABLE"
  encryption_type      = "KMS"
  kms_key_arn          = "arn:aws:kms:us-east-1:123456789012:key/your-kms-key-id"
  scan_on_push         = true
  tags = {
    Environment = "Production"
    Project     = "MyApplication"
  }
}

output "repository_url" {
  value = module.ecr_repository.repository_url
}
```

## Variables

Here's a detailed explanation of each variable you can configure:

*   **`repository_name`** (string, required): The name of the ECR repository.  This name *must* be lowercase and must be unique within your AWS account and region.

    Example:

    ```terraform
    repository_name = "my-web-app"
    ```

*   **`image_tag_mutability`** (string, optional, default: `"IMMUTABLE"`):  Determines whether image tags can be overwritten (MUTABLE) or not (IMMUTABLE).  `IMMUTABLE` is generally recommended for production environments to ensure image versioning is consistent.

    Allowed values: `"MUTABLE"` or `"IMMUTABLE"`.

    Example:

    ```terraform
    image_tag_mutability = "MUTABLE"  # Allows overwriting tags
    ```

*   **`encryption_type`** (string, optional, default: `"AES256"`): The type of server-side encryption to use for the repository. `AES256` uses AWS managed keys, while `KMS` uses a KMS key that you control.

    Allowed values: `"AES256"` or `"KMS"`.

    Example:

    ```terraform
    encryption_type = "KMS"
    ```

*   **`kms_key_arn`** (string, optional, default: `null`): The ARN of the KMS key to use for encryption if `encryption_type` is set to `"KMS"`.  This is *required* if `encryption_type` is `"KMS"`.

    Example:

    ```terraform
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/your-kms-key-id"  # Replace with your KMS key ARN
    ```

*   **`scan_on_push`** (bool, optional, default: `true`):  Enables or disables vulnerability scanning of images when they are pushed to the repository.  Setting this to `true` will trigger a scan after each image push.

    Example:

    ```terraform
    scan_on_push = false  # Disable scanning on push
    ```

*   **`lifecycle_policy`** (string, optional, default: `null`): A JSON-formatted string representing the lifecycle policy for the repository. Lifecycle policies define rules for automatically expiring images based on age or tag prefixes.  If this is `null`, no lifecycle policy is created.  You must provide a valid JSON document.

    Example:

    ```terraform
    lifecycle_policy = jsonencode({
      rules = [
        {
          rulePriority = 1
          description  = "Expire untagged images older than 14 days"
          selection = {
            tagStatus   = "untagged"
            countType   = "sinceImagePushed"
            countUnit   = "days"
            countNumber = 14
          }
          action = {
            type = "expire"
          }
        }
      ]
    })
    ```

*   **`repository_policy`** (string, optional, default: `null`): A JSON-formatted string representing the repository access policy.  This policy defines who can access the repository and what actions they can perform. If this is `null`, no repository policy is created. You must provide a valid JSON document.

    Example:

    ```terraform
    repository_policy = jsonencode({
      Version = "2008-10-17"
      Statement = [
        {
          Sid    = "AllowPull"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::123456789012:root"  # Replace with the account you want to allow pull access
          }
          Action = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetAuthorizationToken"
          ]
        }
      ]
    })
    ```

*   **`force_delete`** (bool, optional, default: `false`):  Forces deletion of the repository, even if it contains images.  Use with caution, as this will permanently delete all images in the repository. It should only be set to `true` when the repository needs to be deleted as part of infrastructure teardown.

    Example:

    ```terraform
    force_delete = true  # ONLY use when you really need to delete everything!
    ```

*   **`tags`** (map(string), optional, default: `{}`):  Additional tags to apply to the ECR repository.  These tags can be used for organization, cost allocation, and other purposes.

    Example:

    ```terraform
    tags = {
      Environment = "Development"
      Team        = "DevOps"
    }
    ```

## Outputs

The module provides the following outputs:

*   **`arn`**: The full ARN (Amazon Resource Name) of the created ECR repository.

*   **`registry_id`**: The AWS account ID of the registry where the repository exists.

*   **`repository_url`**: The URL of the repository, which can be used to push and pull images.

*   **`encryption_configuration`**: A list containing the encryption configuration details for the repository (encryption type and KMS key ARN, if applicable).

*   **`lifecycle_policy`**: The applied lifecycle policy document as a JSON string.  Returns `null` if no lifecycle policy was defined.

*   **`repository_policy`**: The applied repository access policy document as a JSON string. Returns `null` if no repository policy was defined.