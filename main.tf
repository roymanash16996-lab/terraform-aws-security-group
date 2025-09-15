#################################################################
# Caller Identity and other data sources
#################################################################

################################################################################
# Data Source: aws_caller_identity
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
# When: Always created. Used for tagging all resources with AWS account and user info.
# How: Instantiated as a data source, no arguments required.
################################################################################
data "aws_caller_identity" "current" {}

#################################################################
# Security group resource (standard and create_before_destroy variants)
#################################################################

################################################################################
# Resource: aws_security_group.this-dbc
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# When: Created when `security_group_id` is not provided and `create_before_destroy` is false.
# How: Resource is instantiated with a name from `local.sg_name`, which is either the base name or includes a datetime suffix if name_prefix is used.
# Lifecycle: Does not use create_before_destroy; downtime is possible during updates.
# Example: Used for legacy systems or environments where downtime is acceptable.
# Logic: The count is 1 if no external security_group_id is provided and create_before_destroy is false, otherwise 0.
################################################################################
resource "aws_security_group" "this-dbc" {
  count = var.security_group_id == null && !var.create_before_destroy ? 1 : 0

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
      "Name"      = var.name
    },
    var.tags,
  )
}

################################################################################
# Resource: aws_security_group.this-cbd
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# When: Created when `security_group_id` is not provided and `create_before_destroy` is true.
# How: Resource is instantiated with a name from `local.sg_name`, which includes a datetime suffix for uniqueness if name_prefix or create_before_destroy is used.
# Lifecycle: Uses create_before_destroy for zero-downtime replacement during updates.
# Example: Used for production workloads, blue/green deployments, or environments requiring high availability.
# Logic: The count is 1 if no external security_group_id is provided and create_before_destroy is true, otherwise 0.
################################################################################
resource "aws_security_group" "this-cbd" {
  count = var.security_group_id == null && var.create_before_destroy ? 1 : 0

  name_prefix            = "${var.name}-" # Trailing dash for readability with random suffix
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
      "Name"      = var.name
    },
    var.tags,
  )
}

#################################################################
# Security group ingress rules
#################################################################

#================================================================================
# Resource: aws_vpc_security_group_ingress_rule.this
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule
# When: Created for each item in `var.ingress_rules` when `local.this_sg_id` is set and the list is non-empty.
# How: Uses for_each with zipmap to create a rule for each ingress object, attaching to the selected security group.
# Logic: Only creates rules if a security group ID is available and the ingress rules list is not empty.
# Example: Allowing SSH from a specific IP, HTTP from a load balancer, or custom rules for microservices.
#================================================================================
resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = local.this_sg_id != null && length(var.ingress_rules) > 0 ? zipmap(
    [for idx in range(length(var.ingress_rules)) : tostring(idx)],
    var.ingress_rules
  ) : {}

  security_group_id = local.this_sg_id
  ip_protocol       = each.value.ip_protocol
  from_port         = lookup(each.value, "from_port")
  to_port           = lookup(each.value, "to_port")

  cidr_ipv4                    = contains(keys(each.value), "cidr_ipv4") && each.value.cidr_ipv4 != "" ? each.value.cidr_ipv4 : null
  cidr_ipv6                    = contains(keys(each.value), "cidr_ipv6") && each.value.cidr_ipv6 != "" ? each.value.cidr_ipv6 : null
  prefix_list_id               = contains(keys(each.value), "prefix_list_id") && each.value.prefix_list_id != "" ? each.value.prefix_list_id : null
  referenced_security_group_id = contains(keys(each.value), "referenced_security_group_id") && each.value.referenced_security_group_id != "" ? each.value.referenced_security_group_id : null

  description = lookup(each.value, "description", "Default ingress rule to allow all traffic within the security group")
  region      = local.region

  tags = merge(
    {
      "CreatedBy" = data.aws_caller_identity.current.arn
      "Owner"     = data.aws_caller_identity.current.account_id
    },
    var.tags,
  )
}

#################################################################
# Security group egress rules
#################################################################

#================================================================================
# Resource: aws_vpc_security_group_egress_rule.this
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule
# When: Created for each item in `var.egress_rules` when `local.this_sg_id` is set and the list is non-empty.
# How: Uses for_each with zipmap to create a rule for each egress object, attaching to the selected security group.
# Logic: Only creates rules if a security group ID is available and the egress rules list is not empty.
# Example: Restricting outbound traffic to a database subnet, or allowing only specific external API endpoints.
#================================================================================
resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = local.this_sg_id != null && length(var.egress_rules) > 0 ? zipmap(
    [for idx in range(length(var.egress_rules)) : tostring(idx)],
    var.egress_rules
  ) : {}

  security_group_id = local.this_sg_id
  ip_protocol       = each.value.ip_protocol
  from_port         = lookup(each.value, "from_port")
  to_port           = lookup(each.value, "to_port")

  cidr_ipv4                    = contains(keys(each.value), "cidr_ipv4") && each.value.cidr_ipv4 != "" ? each.value.cidr_ipv4 : null
  cidr_ipv6                    = contains(keys(each.value), "cidr_ipv6") && each.value.cidr_ipv6 != "" ? each.value.cidr_ipv6 : null
  prefix_list_id               = contains(keys(each.value), "prefix_list_id") && each.value.prefix_list_id != "" ? each.value.prefix_list_id : null
  referenced_security_group_id = contains(keys(each.value), "referenced_security_group_id") && each.value.referenced_security_group_id != "" ? each.value.referenced_security_group_id : null

  description = lookup(each.value, "description", "Default egress rule to allow all traffic")
  region      = local.region

  tags = merge(
    {
      "CreatedBy" = data.aws_caller_identity.current.arn
      "Owner"     = data.aws_caller_identity.current.account_id
    },
    var.tags,
  )
}


resource "aws_vpc_security_group_egress_rule" "allow-all-ipv4" {

  count = var.egress_rules == [] && var.allow_all_egress_ipv4 && local.this_sg_id != null ? 1 : 0

  security_group_id = local.this_sg_id
  ip_protocol       = "-1"
  cidr_ipv4        = "0.0.0.0/0"
  description       = "Allow all outbound IPv4 traffic"
  region            = local.region

  tags = merge(
    {
      "CreatedBy" = data.aws_caller_identity.current.arn
      "Owner"     = data.aws_caller_identity.current.account_id
    },
    var.tags,
  )
}

resource "aws_vpc_security_group_egress_rule" "allow-all-ipv6" {

  count = var.egress_rules == [] && var.allow_all_egress_ipv6 && local.this_sg_id != null ? 1 : 0

  security_group_id = local.this_sg_id
  ip_protocol       = "-1"
  cidr_ipv6        = "::/0"
  description       = "Allow all outbound IPv6 traffic"
  region            = local.region

  tags = merge(
    {
      "CreatedBy" = data.aws_caller_identity.current.arn
      "Owner"     = data.aws_caller_identity.current.account_id
    },
    var.tags,
  )
}