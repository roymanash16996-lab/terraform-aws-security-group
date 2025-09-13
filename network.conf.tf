

################################################################################
# Data Source: aws_region.default
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region
# Creation Logic: Created only if `security_group_id` is not provided (i.e., a new security group is being created).
# Variable Dependency: Depends on `var.security_group_id`. If null, count = 1; otherwise, count = 0.
# Use Case: Retrieves the AWS region for resource deployment, supporting multi-region logic and ensuring resources are placed in the correct region. Used for region-aware resource placement and VPC selection.
# Logic: Region is determined by local.region, which is set from var.region or this data source.
################################################################################
data "aws_region" "default" {
  count = var.security_group_id == null ? 1 : 0
}



################################################################################
# Data Source: aws_vpc.default
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
# Creation Logic: Created only if both `vpc_name` and `vpc_id` are not provided (empty string), indicating use of the default VPC.
# Variable Dependency: Depends on `var.vpc_name` and `var.vpc_id`. If both are empty, count = 1 and default = true; otherwise, count = 0.
# Use Case: Retrieves the default VPC for resource placement in simple, legacy, or quick-start deployments where a specific VPC is not required. Ensures compatibility with environments lacking custom VPCs.
# Logic: Region is set from local.region for consistency with other resources.
################################################################################
data "aws_vpc" "default" {
  count   = var.vpc_name == "" && var.vpc_id == "" ? 1 : 0
  default = true

  region = local.region
}



################################################################################
# Data Source: aws_vpc.provided-vpc
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
# Creation Logic: Created only if `vpc_name` is provided (not empty) and `vpc_id` is not set, indicating use of a specific VPC by name.
# Variable Dependency: Depends on `var.vpc_name` and `var.vpc_id`. If `vpc_name` is set and `vpc_id` is not, count = 1; otherwise, count = 0.
# Use Case: Retrieves a specific VPC for resource placement in advanced, multi-tenant, or production architectures where VPC selection is required by name. Ensures the correct VPC is selected for complex deployments.
# Logic: Region is set from local.region for consistency. Filter uses tag:Name for VPC selection.
################################################################################
data "aws_vpc" "provided-vpc" {
  # This data source is used to get information about a specific VPC if the VPC name is provided in the variable "vpc_name".
  count = var.vpc_name != "" && var.vpc_id == "" ? 1 : 0

  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }

  region = local.region
}

################################################################################
# Resource: null_resource.abort_multiple_vpcs
# Documentation: https://developer.hashicorp.com/terraform/language/resources/null_resource
# Creation Logic: Created only if `vpc_name` is provided (not empty string) and `vpc_id` is not set.
# Variable Dependency: Depends on `var.vpc_name` and `var.vpc_id`. If `vpc_name` is set and `vpc_id` is not, count = 1; otherwise, count = 0.
# Use Case: Validates that only one VPC matches the provided name. If multiple VPCs are found, aborts with an error and instructs the user to provide a VPC ID instead.
# Purpose: Prevents ambiguous VPC selection and enforces best practices for unique resource identification, especially in environments with non-unique VPC names.
# Logic: Uses precondition lifecycle to enforce single VPC match; error message guides user to provide VPC ID if needed.
################################################################################
resource "null_resource" "abort_multiple_vpcs" {
  count = var.vpc_name != "" && var.vpc_id == "" ? 1 : 0

  lifecycle {
    precondition {
      condition     = length(data.aws_vpc.provided-vpc[*].id) == 1
      error_message = "Multiple VPCs matched the filter for name '${var.vpc_name}'. Please provide VPC ID instead."
    }
  }
}