
################################################################################
# Data Source: aws_region.default
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region
# Purpose: Retrieves the AWS region for resource deployment.
# Use Case: Ensures resources are created in the intended region, supporting multi-region deployments.
################################################################################
data "aws_region" "default" {
  count = local.create ? 1 : 0
}


################################################################################
# Data Source: aws_vpc.default
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
# Purpose: Retrieves the default VPC when no VPC name is provided.
# Use Case: Allows resources to be placed in the default VPC for simple or legacy deployments.
################################################################################
data "aws_vpc" "default" {
  count   = var.vpc_name == "" ? 1 : 0
  default = true

  region = local.region
}


################################################################################
# Data Source: aws_vpc.provided-vpc
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
# Purpose: Retrieves a specific VPC by name when provided.
# Use Case: Enables resource placement in a user-specified VPC for advanced or multi-tenant architectures.
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