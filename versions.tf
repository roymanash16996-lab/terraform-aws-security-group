
################################################################################
# Terraform Block Documentation
# Purpose: Sets minimum required versions for Terraform and AWS provider.
# Use Case: Ensures compatibility, stability, and access to required features and bug fixes.
#
# Details:
# - required_version: Specifies the minimum Terraform version to prevent usage of unsupported or deprecated features. Version 1.5.7+ is required for module compatibility and lifecycle improvements.
# - required_providers: Locks the AWS provider to version 6.12.0 or newer, ensuring access to the latest security group resources and bug fixes.
# - Also locks the null provider to version 3.2.2 or newer, required for validation and abort logic using null_resource.
# - source: Explicitly sets the provider source to HashiCorp's official registry for reliability and security.
#
# Rationale:
# - Using pinned versions helps avoid breaking changes and ensures reproducible builds.
# - Upgrading Terraform, AWS provider, or null provider may require code changes; review release notes before upgrading.
# - For multi-team or CI/CD environments, these constraints help maintain consistent infrastructure behavior.
#
# References:
# - Terraform required_version: https://developer.hashicorp.com/terraform/language/settings#specifying-a-required-terraform-version
# - AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
# - Null Provider: https://registry.terraform.io/providers/hashicorp/null/latest/docs
################################################################################
terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.12.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.2"
    }
  }
}