# Terraform Accelerator

## Overview
`terraform-accelerator` is a repository designed to help you quickly bootstrap Terraform projects by providing reusable modules for common cloud infrastructure components.

## Repository Structure
```
terraform-accelerator/
├── modules/
│   ├── iam/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── README.md
│   ├── ecr/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── README.md
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── README.md
├── examples/  # TBD
```

## Usage
To use a module from this repository in your Terraform configuration, reference it as follows:

```hcl
module "ecr" {
  source = "git::https://github.com/AABelkhiria/terraform-accelerator.git//modules/ecr?ref=main"
  # Add required variables
}
```

Replace `ecr` with `iam` or `vpc` depending on the module you want to use.

## Modules
Each module contains:
- `main.tf`: Defines the Terraform resources.
- `variables.tf`: Defines the input variables required for the module.
- `outputs.tf`: Defines the output values of the module.
- `README.md`: Documentation specific to the module.

## Examples
Examples are currently under development. They will provide ready-to-use Terraform configurations demonstrating module usage.

## Contributing
Feel free to open issues and submit pull requests to improve the repository.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
