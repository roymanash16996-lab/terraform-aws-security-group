#################################################################
# Caller Identity and other data sources
#################################################################
data "aws_caller_identity" "current" {}

#################################################################
# Security group with name
#################################################################

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
