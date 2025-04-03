resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = var.vpc_security_group_ids
  key_name               = var.key_name
  user_data              = var.user_data # Can be plain text or base64 encoded

  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = var.iam_instance_profile

  # Terraform handles merging the nested block based on non-null values in the object.
  root_block_device {
    # If var.root_block_device.volume_size is null, the attribute won't be sent.
    volume_size           = var.root_block_device.volume_size
    volume_type           = var.root_block_device.volume_type
    delete_on_termination = var.root_block_device.delete_on_termination
  }

  tags = merge(
    var.tags,
    {
      "Name" = var.name # Ensure the Name tag is set
    }
  )

  # Add lifecycle rules if needed, e.g.:
  # lifecycle {
  #   create_before_destroy = true
  # }
}
