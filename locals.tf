################################################################################
# Locals Block Documentation
# Purpose: Defines local values for conditional resource creation, selection, and output references.
# Use Case: Centralizes logic for resource selection and configuration, improving maintainability and readability.
################################################################################
locals {

  # Selects the correct security group ID based on creation flags and user input
  # Use Case: Ensures the correct security group is referenced for rule attachment, whether created by this module or provided externally.
  this_sg_id = coalesce(
    var.security_group_id == null && var.use_name_prefix && var.create_before_destroy ? aws_security_group.this-name-prefix-cbd[0].id : null,
    var.security_group_id == null && var.use_name_prefix && !var.create_before_destroy ? aws_security_group.this-name-prefix-dbc[0].id : null,
    var.security_group_id == null && !var.use_name_prefix && var.create_before_destroy ? aws_security_group.this-cbd[0].id : null,
    var.security_group_id == null && !var.use_name_prefix && !var.create_before_destroy ? aws_security_group.this-dbc[0].id : null,
    var.security_group_id
  )

  # Selects the created security group object for output and tagging
  # Use Case: Provides access to the full security group resource for outputs and advanced referencing.
  created_security_group = var.security_group_id == null ? coalesce(
    var.security_group_id == null && var.use_name_prefix && var.create_before_destroy ? aws_security_group.this-name-prefix-cbd[0] : null,
    var.security_group_id == null && var.use_name_prefix && !var.create_before_destroy ? aws_security_group.this-name-prefix-dbc[0] : null,
    var.security_group_id == null && !var.use_name_prefix && var.create_before_destroy ? aws_security_group.this-cbd[0] : null,
    var.security_group_id == null && !var.use_name_prefix && !var.create_before_destroy ? aws_security_group.this-dbc[0] : null
  ) : null

  # Determines the VPC ID to use for security group creation
  # Use Case: Supports both default and user-specified VPCs for flexible network placement.
  vpc_id = var.vpc_name == "" ? data.aws_vpc.default[0].id : data.aws_vpc.provided-vpc[0].id

  # Determines the AWS region for resource deployment
  # Use Case: Allows explicit region selection or defaults to the provider's region for portability.
  region = var.region != "" ? var.region : data.aws_region.default[0].region
}