################################################################################
# Locals Block Documentation
# Purpose: Defines local values for conditional resource creation, selection, and output references.
# Use Case: Centralizes logic for resource selection and configuration, improving maintainability and readability.
# Logic: Updated to reflect simplified resource selection based on create_before_destroy and user input.
################################################################################
locals {

  # Selects the correct security group ID for rule attachment
  # When: If no security_group_id is provided, chooses between create_before_destroy and standard resource.
  # How: Uses coalesce to select the created resource ID, or falls back to user-provided security_group_id.
  # Rationale: Ensures rules are attached to the correct SG, whether created by this module or provided externally.
  this_sg_id = coalesce(
    var.security_group_id == null && var.create_before_destroy ? aws_security_group.this-cbd[0].id : null,
    var.security_group_id == null && !var.create_before_destroy ? aws_security_group.this-dbc[0].id : null,
    var.security_group_id
  )

  # Selects the created security group object for output and tagging
  # When: Only set if a new security group is created by this module (security_group_id is null).
  # How: Chooses the correct resource object based on create_before_destroy flag.
  # Rationale: Provides access to the full resource for outputs and advanced referencing, or null if using an external SG.
  created_security_group = var.security_group_id == null ? coalesce(
    var.security_group_id == null && var.create_before_destroy ? aws_security_group.this-cbd[0] : null,
    var.security_group_id == null && !var.create_before_destroy ? aws_security_group.this-dbc[0] : null
  ) : null

  # Determines the VPC ID to use for security group creation
  # Use Case: Supports both default and user-specified VPCs for flexible network placement.
  vpc_id = var.vpc_id == "" ? data.aws_vpc.default[0].id : var.vpc_id
  # Note: If vpc_id is provided directly, it takes precedence over vpc_name-based lookups.
  # Determines the AWS region for resource deployment
  # Use Case: Allows explicit region selection or defaults to the provider's region for portability.
  region = var.region != "" ? var.region : data.aws_region.default[0].region

  # Generates a unique datetime suffix for resource naming
  # Purpose: Ensures unique resource names for environments where name_prefix or create_before_destroy is used
  # How: Uses the current timestamp formatted as YYYYMMDDHHmmss
  # Example: "my-sg-20250914123045"
  datetime_suffix = formatdate("YYYYMMDDHHmmss", timestamp())

  # Computes the security group name based on naming strategy
  # When: If use_name_prefix or create_before_destroy is true, appends datetime suffix for uniqueness
  # How: Concatenates var.name with datetime_suffix, otherwise uses var.name directly
  # Rationale: Prevents naming collisions and supports zero-downtime replacement scenarios
  # Example: Used for CI/CD, ephemeral, or multi-environment deployments
  sg_name = var.use_name_prefix || var.create_before_destroy ? "${var.name}-${local.datetime_suffix}" : var.name
}