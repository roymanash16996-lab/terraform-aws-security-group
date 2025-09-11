data "aws_region" "default" {
  count = local.create ? 1 : 0
}

data "aws_vpc" "default" {
  count   = var.vpc_name == "" ? 1 : 0
  default = true

  region = local.region
}

data "aws_vpc" "provided-vpc" {
  # This data source is used to get information about a specific VPC if the VPC name is provided in the variable "vpc_name".
  count = var.vpc_name != "" ? 1 : 0

  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }

  region = local.region
}