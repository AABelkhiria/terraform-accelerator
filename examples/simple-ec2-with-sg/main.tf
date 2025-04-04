# --- Provider Configuration ---
# Configure the AWS provider
provider "aws" {
  region = "eu-central-1"
}

# Find the latest Amazon Linux 2 AMI in the specified region
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

# Get default VPC details - needed for the Security Group
data "aws_vpc" "default" {
  default = true
}

# Get a default Subnet ID - needed for the EC2 Instance
# Note: Using default might place instance in any AZ. Specify AZ/subnet ID directly for more control.
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  # Optional: Filter by AZ if needed
  # filter {
  #   name   = "availability-zone"
  #   values = ["eu-central-1a"] # Example AZ in Frankfurt
  # }
}

# --- Security Group Creation using the SG Module ---
module "web_server_sg" {
  source = "git::https://github.com/AABelkhiria/terraform-accelerator.git//modules/sg?ref=main"

  name   = "web-server-example-sg" # Choose a name for the SG
  vpc_id = data.aws_vpc.default.id # Use the default VPC ID found above

  description = "Allow SSH from anywhere and all egress - Example SG"

  # Define ingress rules (Incoming traffic)
  ingress_rules = [
    {
      description = "Allow SSH from anywhere (TEMPORARY - NOT SECURE)"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      # WARNING: 0.0.0.0/0 allows access from ANY IP address.
      # Replace with your specific IP address like ["YOUR_IP/32"] for better security.
      cidr_blocks = ["0.0.0.0/0"]
    }
    # Add other ingress rules here if needed (e.g., for HTTP/HTTPS)
    # {
    #   description = "Allow HTTP"
    #   from_port   = 80
    #   to_port     = 80
    #   protocol    = "tcp"
    #   cidr_blocks = ["0.0.0.0/0"]
    # }
  ]

  # Egress rules (Outgoing traffic)
  # We are using the module's default `allow_all_egress = true`,
  # so no need to specify egress_rules unless we want something specific.
  # egress_rules = [] # Explicitly empty, or define specific rules

  tags = {
    Environment = "Development"
    CreatedBy   = "Terraform-Example"
    ManagedBy   = "Terraform-SG-Module"
  }
}

# --- Resource Creation using the Module ---
module "my_first_ec2" {
  source = "git::https://github.com/AABelkhiria/terraform-accelerator.git//modules/ec2?ref=main"

  # --- Required Variables ---
  # Use the AMI ID found by the data source above
  ami = data.aws_ami.amazon_linux_2.id

  # Specify the desired instance type
  instance_type = "t2.micro" # TODO: Replace with your desired instance type

  # Specify the Subnet ID where the instance should be launched or use the default one
  subnet_id = data.aws_subnets.default.ids[0] # TODO: Replace with your Subnet ID

  # --- Optional Variables ---
  # Specify the Key Pair name for SSH access (must exist in your AWS account/region)
  key_name = "ash_root_aws" # TODO: Replace with your Key Pair name (optional, but needed for SSH)

  # Define a name for the instance (will appear as the 'Name' tag)
  name = "my-example-instance"

  # Add additional tags
  tags = {
    Environment = "Development"
    CreatedBy   = "Terraform-Example"
  }

  # Example: Associate a specific Security Group (replace with your SG ID)
  vpc_security_group_ids = [module.web_server_sg.id]

  # Example: Disable public IP address
  # associate_public_ip_address = false

  # Example: Customize root volume size (e.g., 20GB)
  # root_block_device = {
  #   volume_size = 20
  # }

  # Example: Add user data script
  # user_data = <<-EOF
  #           #!/bin/bash
  #           yum update -y
  #           yum install -y httpd
  #           systemctl start httpd
  #           systemctl enable httpd
  #           echo "<h1>Deployed via Terraform Module</h1>" > /var/www/html/index.html
  #           EOF
}

# --- Outputs ---
# Display some of the outputs from the module
output "instance_id" {
  description = "The ID of the created EC2 instance."
  value       = module.my_first_ec2.instance_id
}

output "instance_public_ip" {
  description = "Public IP address of the created EC2 instance (if applicable)."
  value       = module.my_first_ec2.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the created EC2 instance."
  value       = module.my_first_ec2.private_ip
}

output "instance_name_tag" {
  description = "The 'Name' tag assigned to the instance."
  value = module.my_first_ec2.tags_all["Name"]
}

output "security_group_id" {
  description = "The ID of the Security Group created for the instance."
  value       = module.web_server_sg.id
}

output "ssh_command" {
  description = "Command to SSH into the instance (replace key path if needed)."
  value = "ssh -i ~/.ssh/${module.my_first_ec2.key_name}.pem ec2-user@${module.my_first_ec2.public_ip}"
}
