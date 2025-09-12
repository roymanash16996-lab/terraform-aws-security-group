


# AWS Security Group Terraform Module


**Created by: Manash Roy**

This module provides a highly flexible and robust solution for managing AWS Security Groups and their rules using Terraform. It is designed for advanced use cases, supporting conditional resource creation, custom naming, lifecycle management, dynamic rule definitions, and tagging for traceability.

---

## Table of Contents
- [Features](#features)
- [File Overview](#file-overview)
- [Resource Logic](#resource-logic)
- [Variable Reference](#variable-reference)
- [Rule Schema](#rule-schema)
- [Lifecycle and Conditional Creation](#lifecycle-and-conditional-creation)
- [Tagging](#tagging)
- [Example Usage](#example-usage)
- [Outputs](#outputs)
- [Requirements](#requirements)
- [Troubleshooting](#troubleshooting)
- [License](#license)

---

## Features
- **Conditional Security Group Creation**: Create security groups only when required, or use an existing group by ID.
- **Custom Naming**: Choose between a fixed name or a name prefix for auto-generated names.
- **Lifecycle Management**: Enable `create_before_destroy` for zero-downtime replacements.
- **Dynamic Rule Management**: Define ingress and egress rules as lists of objects, supporting all major AWS rule types.
- **Advanced Tagging**: All resources and rules are tagged with creator, owner, timestamp, and custom tags.
- **Flexible VPC/Region Selection**: Deploy into any VPC or region, with automatic selection if not specified.

---


## File Overview


### main.tf
Defines all AWS resources:

#### Data Sources
- **data.aws_caller_identity.current**: Retrieves AWS account identity and ARN for tagging.

#### Security Group Resources
- **aws_security_group.this-dbc**: Security group with name, no create_before_destroy
- **aws_security_group.this-name-prefix-dbc**: Security group with name_prefix, no create_before_destroy
- **aws_security_group.this-cbd**: Security group with name, create_before_destroy
- **aws_security_group.this-name-prefix-cbd**: Security group with name_prefix, create_before_destroy

#### Security Group Rule Resources
- **aws_vpc_security_group_ingress_rule.this**: Ingress rules for the security group
- **aws_vpc_security_group_egress_rule.this**: Egress rules for the security group

### variables.tf
Defines all input variables for configuration, rule schemas, network, and tagging.

### locals.tf
Local values for resource selection, conditional logic, and output references.

### network.conf.tf
Data sources for AWS region and VPC selection, supporting both default and named VPCs.

### outputs.tf
Outputs for security group ID, ARN, and name, using local references.

### versions.tf
Specifies Terraform and AWS provider version requirements.

---


## Resources

### Security Group Resources
- **aws_security_group.this-dbc**: Created when using a fixed name and no create_before_destroy lifecycle.
- **aws_security_group.this-name-prefix-dbc**: Created when using a name prefix and no create_before_destroy lifecycle.
- **aws_security_group.this-cbd**: Created when using a fixed name and create_before_destroy lifecycle.
- **aws_security_group.this-name-prefix-cbd**: Created when using a name prefix and create_before_destroy lifecycle.

### Security Group Rule Resources
- **aws_vpc_security_group_ingress_rule.this**: Manages ingress rules for the security group, created for each item in `var.ingress_rules`.
- **aws_vpc_security_group_egress_rule.this**: Manages egress rules for the security group, created for each item in `var.egress_rules`.

### Data Sources
- **data.aws_caller_identity.current**: Retrieves AWS account identity for tagging.

---

---


## Variables

| variable_name              | description                                                                                           | optional | required | type         |
|----------------------------|-------------------------------------------------------------------------------------------------------|----------|---------|--------------|
| create                     | Flag to create the security group or rules. If false, assumes SG is managed outside this module.      | Yes      | No      | bool         |
| create_security_group      | Flag to create the security group. If false, assumes SG is managed outside this module.               | Yes      | No      | bool         |
| create_before_destroy      | Enable create_before_destroy lifecycle policy for zero-downtime replacement.                          | Yes      | No      | bool         |
| use_name_prefix            | Use name_prefix for auto-generated SG names.                                                          | Yes      | No      | bool         |
| name                       | The name of the security group. If omitted, Terraform assigns a random name.                          | Yes      | No      | string       |
| description                | Description of the security group. Defaults to 'Security Group managed by Terraform'.                 | Yes      | No      | string       |
| revoke_rules_on_delete     | Revoke all rules when the SG is deleted. Defaults to true.                                            | Yes      | No      | bool         |
| security_group_id          | ID of an existing SG to use. If provided, no new SG is created.                                       | Yes      | No      | string       |
| ingress_rules              | List of ingress rule objects. See Rule Schema below.                                                  | Yes      | No      | list(object) |
| egress_rules               | List of egress rule objects. See Rule Schema below.                                                   | Yes      | No      | list(object) |
| region                     | AWS region for deployment. Default is provider region.                                                | Yes      | No      | string       |
| vpc_name                   | Name of the VPC for deployment. If not provided, uses default VPC.                                   | Yes      | No      | string       |
| subnet_type                | Subnet type for the instance. Options: 'public', 'private-with-nat', 'private-isolated'.             | Yes      | No      | string       |
| availability_zone          | Availability zone for the instance. Default is first AZ of selected VPC.                             | Yes      | No      | string       |
| tags                       | Map of custom tags to assign to the security group.                                                  | Yes      | No      | map(string)  |


---

## Rule Schema

Both `ingress_rules` and `egress_rules` are lists of objects with the following keys:

| Key                        | Type    | Default           | Description |
|----------------------------|---------|-------------------|-------------|
| ip_protocol                | string  | (required)        | Protocol (e.g., "tcp", "udp", "icmp", "-1") |
| from_port                  | number  | 0                 | Start port |
| to_port                    | number  | 0                 | End port |
| cidr_ipv4                  | string  | "0.0.0.0/0"       | IPv4 CIDR block (mutually exclusive) |
| cidr_ipv6                  | string  | "::/0"           | IPv6 CIDR block (mutually exclusive) |
| prefix_list_id             | string  | ""               | AWS prefix list ID (mutually exclusive) |
| referenced_security_group_id| string  | ""               | Referenced security group ID (mutually exclusive) |
| description                | string  | See variables.tf  | Rule description |

**Note:** For each rule, only one of `cidr_ipv4`, `cidr_ipv6`, `prefix_list_id`, or `referenced_security_group_id` should be set.

---

## Lifecycle and Conditional Creation

- Security group resources are only created if `local.create` and `var.create_security_group` are true.
- The resource variant is selected based on `use_name_prefix` and `create_before_destroy`.
- If `security_group_id` is provided, no new security group is created; rules are attached to the existing group.

---


## Tagging

All resources and rules are tagged with:
- `CreatedBy`: AWS caller identity ARN (`data.aws_caller_identity.current.arn`)
- `Owner`: AWS account ID (`data.aws_caller_identity.current.account_id`)
- `CreatedAt`: Timestamp of creation
- `Name`: Security group name
- Custom tags from `var.tags`

---

## Example Usage
```hcl
module "security_group" {
  source = "./Registry/Security-Group"

  name                  = "my-sg"
  description           = "My security group"
  vpc_name              = "my-vpc"
  create_security_group = true
  use_name_prefix       = false
  create_before_destroy = true

  ingress_rules = [
    {
      ip_protocol = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow SSH"
    },
    {
      ip_protocol = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow HTTP"
    }
  ]

  egress_rules = [
    {
      ip_protocol = "-1"
      description = "Allow all outbound traffic"
    }
  ]

  tags = {
    Environment = "dev"
    Owner       = "your-name"
  }
}
```

---


## Outputs

| output_name           | description                                 | type    |
|-----------------------|---------------------------------------------|---------|
| security_group_id     | The ID of the security group                | string  |
| security_group_arn    | The ARN of the security group               | string  |
| security_group_name   | The name of the security group              | string  |

---

## Requirements

- Terraform >= 1.5.7
- AWS Provider >= 6.12.0

---

## Troubleshooting

- **No Security Group Created:**
  - Ensure `create` and `create_security_group` are both `true`.
  - If using an existing group, set `security_group_id` and set `create_security_group` to `false`.
- **Rule Not Applied:**
  - Check that your rule object matches the schema and only one mutually exclusive attribute is set.
- **VPC Not Found:**
  - Confirm `vpc_name` is correct, or leave blank to use the default VPC.
- **Provider Version Issues:**
  - Ensure your Terraform and AWS provider versions meet the requirements in `versions.tf`.

---

## License
Self
