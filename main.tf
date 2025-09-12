#################################################################
# Caller Identity and other data sources
#################################################################

################################################################################
# Data Source: aws_caller_identity
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
# Reason: Retrieves AWS account and user information for tagging and traceability.
# Use Case: Used to tag all resources with the identity of the user/account running Terraform, enabling auditability and ownership tracking in multi-account environments.
################################################################################
data "aws_caller_identity" "current" {}

#################################################################
# Security group with name
#################################################################


# =============================================================================
# Resource: aws_security_group.this-dbc
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# Reason: Creates a security group with a fixed name when create_before_destroy is not required.
# Use Case: Use when you need a predictable, static security group name for integration with other resources or external systems, and downtime during replacement is acceptable.
# Example: Integrating with legacy systems or scripts that expect a specific security group name.
# =============================================================================
resource "aws_security_group" "this-dbc" {

  count = local.create && var.create_security_group && !var.use_name_prefix && !var.create_before_destroy ? 1 : 0

  name                   = var.name
  description            = var.description
  revoke_rules_on_delete = var.revoke_rules_on_delete

  vpc_id = local.vpc_id

  lifecycle {
    create_before_destroy = false
  }

  tags = merge(
    {
      "CreatedBy" = data.aws_caller_identity.current.arn
      "Owner"     = data.aws_caller_identity.current.account_id
      "CreatedAt" = timestamp()
      "Name"      = var.name
    },
    var.tags,
  )
}

#################################################################
# Security group with name_prefix
#################################################################


# =============================================================================
# Resource: aws_security_group.this-name-prefix-dbc
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# Reason: Creates a security group with a name prefix for auto-generated names when create_before_destroy is not required.
# Use Case: Use when you want Terraform to generate unique security group names for each deployment, avoiding naming collisions in shared or multi-tenant environments.
# Example: Deploying multiple environments (dev, staging, prod) in the same AWS account.
# =============================================================================
resource "aws_security_group" "this-name-prefix-dbc" {

  count = local.create && var.create_security_group && var.use_name_prefix && !var.create_before_destroy ? 1 : 0

  name_prefix            = "${var.name}-"
  description            = var.description
  revoke_rules_on_delete = var.revoke_rules_on_delete

  vpc_id = local.vpc_id

  lifecycle {
    create_before_destroy = false
  }

  tags = merge(
    {
      "CreatedBy" = data.aws_caller_identity.current.arn
      "Owner"     = data.aws_caller_identity.current.account_id
      "CreatedAt" = timestamp()
      "Name"      = var.name
    },
    var.tags,
  )
}

#################################################################
# Security group with create_before_destroy and name
#################################################################


# =============================================================================
# Resource: aws_security_group.this-cbd
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# Reason: Creates a security group with a fixed name and enables create_before_destroy for zero-downtime replacement.
# Use Case: Use when you require a static security group name and need to avoid downtime during updates (e.g., production workloads with high availability requirements).
# Example: Rolling out security group changes in a blue/green deployment scenario.
# =============================================================================
resource "aws_security_group" "this-cbd" {

  count = local.create && var.create_security_group && !var.use_name_prefix && var.create_before_destroy ? 1 : 0

  name                   = var.name
  description            = var.description
  revoke_rules_on_delete = var.revoke_rules_on_delete

  vpc_id = local.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      "CreatedBy" = data.aws_caller_identity.current.arn
      "Owner"     = data.aws_caller_identity.current.account_id
      "CreatedAt" = timestamp()
      "Name"      = var.name
    },
    var.tags,
  )

}

#################################################################
# Security group with create_before_destroy and name_prefix
#################################################################


# =============================================================================
# Resource: aws_security_group.this-name-prefix-cbd
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# Reason: Creates a security group with a name prefix and enables create_before_destroy for zero-downtime replacement.
# Use Case: Use when you want unique, auto-generated security group names and require zero-downtime updates, suitable for CI/CD pipelines and ephemeral environments.
# Example: Automated deployments for feature branches or short-lived test environments.
# =============================================================================
resource "aws_security_group" "this-name-prefix-cbd" {

  count = local.create && var.create_security_group && var.use_name_prefix && var.create_before_destroy ? 1 : 0

  name_prefix            = "${var.name}-"
  description            = var.description
  revoke_rules_on_delete = var.revoke_rules_on_delete

  vpc_id = local.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      "CreatedBy" = data.aws_caller_identity.current.arn
      "Owner"     = data.aws_caller_identity.current.account_id
      "CreatedAt" = timestamp()
      "Name"      = var.name
    },
    var.tags,
  )

}

#################################################################
# Security group ingress rules
#################################################################


# =============================================================================
# Resource: aws_vpc_security_group_ingress_rule.this
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule
# Reason: Manages individual ingress rules for the security group, allowing fine-grained control over inbound traffic.
# Use Case: Use to define granular inbound access policies, such as allowing only specific ports, protocols, or source CIDRs/security groups. Supports dynamic rule sets for microservices or multi-tier architectures.
# Example: Allowing SSH from a specific IP, or HTTP from a load balancer security group.
# =============================================================================
resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = local.create && length(var.ingress_rules) > 0 ? zipmap(
    [for idx in range(length(var.ingress_rules)) : tostring(idx)], 
    var.ingress_rules
  ) : {}

  security_group_id            = local.this_sg_id
  ip_protocol                  = each.value.ip_protocol
  from_port                    = lookup(each.value, "from_port", 0)
  to_port                      = lookup(each.value, "to_port", 0)

  cidr_ipv4                 = contains(keys(each.value), "cidr_ipv4") && each.value.cidr_ipv4 != "" ? each.value.cidr_ipv4 : null
  cidr_ipv6                 = contains(keys(each.value), "cidr_ipv6") && each.value.cidr_ipv6 != "" ? each.value.cidr_ipv6 : null
  prefix_list_id            = contains(keys(each.value), "prefix_list_id") && each.value.prefix_list_id != "" ? each.value.prefix_list_id : null
  referenced_security_group_id = contains(keys(each.value), "referenced_security_group_id") && each.value.referenced_security_group_id != "" ? each.value.referenced_security_group_id : null

  description                  = lookup(each.value, "description", "Default ingress rule to allow all traffic within the security group")
  region                       = local.region

  tags = merge(
    {
      "CreatedBy" = data.aws_caller_identity.current.arn
      "Owner"     = data.aws_caller_identity.current.account_id
      "CreatedAt" = timestamp()
    },
    var.tags,
  )
}

#################################################################
# Security group egress rules
#################################################################


# =============================================================================
# Resource: aws_vpc_security_group_egress_rule.this
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule
# Reason: Manages individual egress rules for the security group, allowing fine-grained control over outbound traffic.
# Use Case: Use to restrict or allow outbound traffic from resources, such as limiting access to specific services, networks, or compliance boundaries.
# Example: Allowing outbound traffic only to a specific database subnet or external API endpoint.
# =============================================================================
resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = local.create && length(var.egress_rules) > 0 ? zipmap(
    [for idx in range(length(var.egress_rules)) : tostring(idx)],
    var.egress_rules
  ) : {}

  security_group_id = local.this_sg_id
  ip_protocol       = each.value.ip_protocol
  from_port         = lookup(each.value, "from_port", 0)
  to_port           = lookup(each.value, "to_port", 0)

  cidr_ipv4                 = contains(keys(each.value), "cidr_ipv4") && each.value.cidr_ipv4 != "" ? each.value.cidr_ipv4 : null
  cidr_ipv6                 = contains(keys(each.value), "cidr_ipv6") && each.value.cidr_ipv6 != "" ? each.value.cidr_ipv6 : null
  prefix_list_id            = contains(keys(each.value), "prefix_list_id") && each.value.prefix_list_id != "" ? each.value.prefix_list_id : null
  referenced_security_group_id = contains(keys(each.value), "referenced_security_group_id") && each.value.referenced_security_group_id != "" ? each.value.referenced_security_group_id : null

  description = lookup(each.value, "description", "Default egress rule to allow all traffic")
  region      = local.region

  tags = merge(
    {
      "CreatedBy" = data.aws_caller_identity.current.arn
      "Owner"     = data.aws_caller_identity.current.account_id
      "CreatedAt" = timestamp()
    },
    var.tags,
  )
}
