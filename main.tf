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
      "CreatedBy" = "Terraform"
      "Owner"     = data.aws_caller_identity.current.arn
      "CreatedAt" = timestamp()
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
      "CreatedBy" = "Terraform"
      "Owner"     = data.aws_caller_identity.current.arn
      "CreatedAt" = timestamp()
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
      "CreatedBy" = "Terraform"
      "Owner"     = data.aws_caller_identity.current.arn
      "CreatedAt" = timestamp()
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
      "CreatedBy" = "Terraform"
      "Owner"     = data.aws_caller_identity.current.arn
      "CreatedAt" = timestamp()
    },
    var.tags,
  )

}

#################################################################
# Security group ingress rules
#################################################################

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = local.create ? (
    length(var.ingress_rules) > 0 ? var.ingress_rules : {
      "default" = {
        ip_protocol = "-1"
      }
    }
  ) : {}

  security_group_id            = local.this_sg_id
  ip_protocol                  = each.value.ip_protocol
  from_port                    = lookup(each.value, "from_port", 0)
  to_port                      = lookup(each.value, "to_port", 0)
  cidr_ipv4                    = lookup(each.value, "cidr_ipv4", "0.0.0.0/0")
  cidr_ipv6                    = lookup(each.value, "cidr_ipv6", "::/0")
  prefix_list_id               = lookup(each.value, "prefix_list_id", "")
  referenced_security_group_id = lookup(each.value, "referenced_security_group_id", "")
  description                  = lookup(each.value, "description", "Default ingress rule to allow all traffic within the security group")
  region                       = local.region

  tags = merge(
    {
      "CreatedBy" = "Terraform"
      "Owner"     = data.aws_caller_identity.current.arn
      "CreatedAt" = timestamp()
    },
    var.tags,
  )
}

#################################################################
# Security group egress rules
#################################################################

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = local.create ? (
    length(var.egress_rules) > 0 ? var.egress_rules : {
      "default" = {
        ip_protocol = "-1"
      }
    }
  ) : {}

  security_group_id            = local.this_sg_id
  ip_protocol                  = each.value.ip_protocol
  from_port                    = lookup(each.value, "from_port", 0)
  to_port                      = lookup(each.value, "to_port", 0)
  cidr_ipv4                    = lookup(each.value, "cidr_ipv4", "0.0.0.0/0")
  cidr_ipv6                    = lookup(each.value, "cidr_ipv6", "::/0")
  prefix_list_id               = lookup(each.value, "prefix_list_id", "")
  referenced_security_group_id = lookup(each.value, "referenced_security_group_id", "")
  description                  = lookup(each.value, "description", "Default ingress rule to allow all traffic within the security group")
  region                       = local.region

  tags = merge(
    {
      "CreatedBy" = "Terraform"
      "Owner"     = data.aws_caller_identity.current.arn
      "CreatedAt" = timestamp()
    },
    var.tags,
  )
}