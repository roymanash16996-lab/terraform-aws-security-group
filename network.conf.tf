

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
  count   = var.vpc_id == "" ? 1 : 0
  default = true

  region = local.region
}