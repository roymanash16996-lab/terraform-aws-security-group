

################################################################################
# Data Source: aws_region.default
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region
# When: Created only if `security_group_id` is not provided (i.e., a new security group is being created).
# How: Instantiated as a data source with count = 1 when creating a new security group, otherwise not created.
# Purpose: Retrieves the AWS region for resource deployment, supporting multi-region logic.
################################################################################
data "aws_region" "default" {
  count = !var.security_group_id ? 1 : 0
}



################################################################################
# Data Source: aws_vpc.default
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
# When: Created only if `vpc_name` is not provided (i.e., use default VPC).
# How: Instantiated as a data source with count = 1 and default = true when no VPC name is given.
# Purpose: Retrieves the default VPC for resource placement in simple or legacy deployments.
################################################################################
data "aws_vpc" "default" {
  count   = var.vpc_name == "" ? 1 : 0
  default = true

  region = local.region
}



################################################################################
# Data Source: aws_vpc.provided-vpc
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
# When: Created only if `vpc_name` is provided (i.e., use a specific VPC).
# How: Instantiated as a data source with count = 1 and filter by VPC name when a VPC name is given.
# Purpose: Retrieves a specific VPC for resource placement in advanced or multi-tenant architectures.
################################################################################
data "aws_vpc" "provided-vpc" {
  # This data source is used to get information about a specific VPC if the VPC name is provided in the variable "vpc_name".
  count = var.vpc_name != "" ? 1 : 0

  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }

  region = local.region
}