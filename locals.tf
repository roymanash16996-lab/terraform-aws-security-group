locals {
  create = var.create

  this_sg_id = coalesce(
    var.create_security_group && var.use_name_prefix && var.create_before_destroy ? aws_security_group.this-name-prefix-cbd[0].id : null,
    var.create_security_group && var.use_name_prefix && !var.create_before_destroy ? aws_security_group.this-name-prefix-dbc[0].id : null,
    var.create_security_group && !var.use_name_prefix && var.create_before_destroy ? aws_security_group.this-cbd[0].id : null,
    var.create_security_group && !var.use_name_prefix && !var.create_before_destroy ? aws_security_group.this-dbc[0].id : null,
    var.security_group_id
  )

  vpc_id = var.vpc_name == "" ? data.aws_vpc.default[0].id : data.aws_vpc.provided-vpc[0].id

  region = var.region != "" ? var.region : data.aws_region.default[0].name
}