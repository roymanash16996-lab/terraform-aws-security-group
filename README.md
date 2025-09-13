


# AWS Security Group Terraform Module


**Created by: Manash Roy**

This module provides a highly flexible and robust solution for managing AWS Security Groups and their rules using Terraform. It is designed for advanced use cases, supporting conditional resource creation, custom naming, lifecycle management, dynamic rule definitions, and tagging for traceability.

---

## Table of Contents
 [Features](#features)
 [Usage](#usage)
 [File Overview](#file-overview)
 [Example Usage](#example-usage)
 [Requirements](#requirements)
 [Resources](#resources)
 [Variables](#variables)
 [Rule Schema](#rule-schema)
 [Lifecycle and Conditional Creation](#lifecycle-and-conditional-creation)
 [Tagging](#tagging)
 [Outputs](#outputs)
 [Troubleshooting](#troubleshooting)
 [License](#license)
## Usage



### What is this module?

This Terraform module provides a comprehensive solution for managing AWS Security Groups and their associated rules. Security Groups are a fundamental part of AWS networking, acting as virtual firewalls that control inbound and outbound traffic for your resources, such as EC2 instances, load balancers, and Lambda functions. This module abstracts the complexity of security group management, allowing you to define, create, and manage security groups and their rules in a highly flexible, reusable, and maintainable way.

### Why use this module?

**1. Simplifies Security Group Management:**
Manually managing security groups and rules in AWS can be error-prone and time-consuming, especially as your infrastructure grows. This module automates the creation and configuration of security groups, ensuring consistency and reducing the risk of misconfiguration. By using Terraform’s declarative approach, you can version control your security policies and roll back changes if needed, providing a safer and more auditable workflow.

**2. Supports Advanced Use Cases:**
The module is designed for both simple and advanced scenarios. You can create a new security group or attach rules to an existing one, use custom naming or name prefixes, and enable lifecycle policies like `create_before_destroy` for zero-downtime deployments. It supports dynamic rule definitions, allowing you to specify ingress and egress rules as lists of objects, which is ideal for complex environments. You can also leverage advanced features such as referencing other security groups, using prefix lists, and supporting both IPv4 and IPv6 CIDR blocks.

**3. Conditional Resource Creation:**
Resources are created only when needed. For example, if you provide an existing security group ID, the module will not create a new group but will attach rules to the specified group. This makes it easy to integrate with existing infrastructure or migrate resources without disruption. The module’s logic ensures that only the necessary resources are created, reducing unnecessary AWS resource sprawl and keeping your environment clean.

**4. Automatic VPC and Region Selection:**
The module can automatically select the appropriate VPC and region for deployment based on your input variables. If you do not specify a VPC or region, it will use sensible defaults, reducing the need for manual configuration and minimizing errors. This is particularly useful in organizations with multiple VPCs or regions, as it helps standardize deployments and avoid misconfigurations.

**5. Enhanced Tagging and Traceability:**
All resources and rules are tagged with metadata such as creator, owner, timestamp, and custom tags. This improves traceability, auditing, and cost allocation, making it easier to manage resources in large organizations or multi-account setups. Tags can be used for automation, reporting, and compliance, and the module ensures that all resources are consistently tagged according to your requirements.

**6. Modular and Reusable:**
The module is built to be reusable across projects and teams. You can include it in your Terraform configuration, customize it with input variables, and use outputs to integrate with other modules or resources. This promotes best practices and reduces duplication of code. By using modules, you can share security policies across teams, enforce standards, and accelerate infrastructure delivery.

**7. Compliance and Best Practices:**
By using this module, you ensure that your security group configuration follows AWS and Terraform best practices. The module includes validation logic to prevent common mistakes, such as setting mutually exclusive rule attributes, and supports lifecycle management for safe updates. It also helps enforce compliance requirements by providing a clear, auditable record of your security group configuration.

### Who should use this module?

This module is ideal for:
- DevOps engineers and cloud architects who need to manage AWS Security Groups at scale.
- Teams looking for a standardized, maintainable approach to network security in AWS.
- Anyone new to Terraform or AWS who wants a reliable, well-documented starting point for security group management.
- Organizations with compliance, audit, or cost allocation requirements.
- Developers who want to automate infrastructure provisioning and security policy enforcement.

### Getting Started

To use this module, simply add it to your Terraform configuration and provide the necessary input variables. You can start with the example usage provided below, customize the rules and settings to fit your needs, and leverage the outputs for integration with other resources. The module is compatible with Terraform Registry, so you can easily reference it in your codebase and benefit from versioning and community support.

#### Step-by-Step Guide

1. **Install Terraform:**
  Download and install Terraform from the official website. Ensure you have the required version as specified in the Requirements section.

2. **Configure AWS Provider:**
  Set up your AWS credentials and provider configuration in your Terraform files. This module requires the AWS provider to be configured and authenticated.

3. **Add the Module to Your Configuration:**
  Reference the module in your Terraform code using the source URL. Specify the desired version for stability and repeatability.

4. **Set Input Variables:**
  Define the input variables for your use case, such as security group name, description, VPC, rules, and tags. Use the variable table and descriptions for guidance.

5. **Customize Rules:**
  Create ingress and egress rule objects according to your application’s requirements. Follow the rule schema to ensure correct configuration.

6. **Run Terraform Plan:**
  Execute `terraform plan` to preview the changes. Review the output to ensure the security group and rules are configured as expected.

7. **Apply the Configuration:**
  Run `terraform apply` to create or update the security group and rules in AWS. Monitor the output for resource creation and any errors.

8. **Integrate Outputs:**
  Use the module’s outputs to reference the security group in other resources, such as EC2 instances, load balancers, or Lambda functions.

9. **Maintain and Update:**
  Use version control to track changes, update the module version as needed, and collaborate with your team for ongoing maintenance.

### Practical Guidance and Best Practices

**Understand Your Security Requirements:**
Before deploying any security group, carefully assess the access needs of your resources. Use the module’s flexible rule schema to define only the necessary ingress and egress rules, following the principle of least privilege. For example, restrict SSH access to trusted IP ranges and limit outbound traffic to required destinations. Document your security policies and review them regularly to ensure they meet your organization’s needs.

**Leverage Conditional Logic:**
Take advantage of the module’s conditional resource creation. If you already have a security group, simply provide its ID to avoid creating duplicates. This is especially useful in environments where infrastructure is shared or managed by multiple teams. Use conditional logic to manage different environments (dev, staging, prod) with a single module configuration.

**Use Tagging for Organization:**
Apply meaningful tags to your security groups and rules. Tags such as `Environment`, `Owner`, and `Application` help with resource tracking, cost allocation, and compliance reporting. The module automatically adds metadata tags, but you can extend this with custom tags to fit your organization’s standards. Use tags to automate resource management, generate reports, and enforce policies.

**Integrate with Other Modules:**
Outputs from this module (security group ID, ARN, and name) can be referenced in other Terraform modules, such as EC2, ELB, or Lambda. This enables seamless integration and ensures that your resources are protected by the correct security groups. Use outputs to build complex infrastructure stacks and automate resource dependencies.

**Version Control and Collaboration:**
Store your Terraform configuration in version control (e.g., Git) and use the module’s versioning features to manage updates. Collaborate with your team by sharing module configurations and documenting changes, which helps maintain consistency and reliability across deployments. Use pull requests and code reviews to enforce standards and catch errors early.

**Testing and Validation:**
Before applying changes, use `terraform plan` to review the proposed modifications. The module’s validation logic will catch common mistakes, such as conflicting rule attributes or missing required fields. Always test in a non-production environment before rolling out changes to production. Use automated testing tools and CI/CD pipelines to validate your infrastructure code.

**Real-World Scenarios:**
Suppose you are launching a web application in AWS. You can use this module to create a security group that allows HTTP and HTTPS traffic from the internet, restricts SSH access to your office IP, and blocks all other inbound traffic. For backend services, you can define rules that only allow traffic from specific security groups, enhancing isolation and security.

In multi-account or multi-region setups, the module’s automatic region and VPC selection simplifies deployment. You can deploy the same configuration across different environments by adjusting input variables, ensuring consistent security policies everywhere. Use the module to enforce global security standards and automate deployments across AWS accounts.

**Advanced Scenarios:**
For organizations with strict compliance requirements, use the module’s tagging and output features to generate audit trails and reports. Integrate with monitoring and alerting tools to track changes and detect anomalies. Use the module in combination with other Terraform modules to build secure, scalable, and compliant cloud architectures.

**Security Best Practices:**
- Always follow the principle of least privilege when defining rules.
- Regularly review and update security group rules to remove unnecessary access.
- Use Terraform’s state management features to track changes and roll back if needed.
- Monitor AWS CloudTrail and Config for changes to security groups and rules.
- Use tags and outputs to automate compliance reporting and cost allocation.

**Troubleshooting Tips:**
If you encounter issues, check the module’s outputs and tags for clues. Common problems include missing rules, incorrect VPC selection, or provider version mismatches. Refer to the troubleshooting section for solutions and best practices. Use Terraform’s built-in logging and debugging features to diagnose problems and resolve issues quickly.

**Integration Examples:**
You can use this module in combination with other Terraform modules to build complete infrastructure stacks. For example, create a security group for a web server, reference its ID in an EC2 module, and automate deployment with CI/CD pipelines. Use outputs to pass security group information between modules and automate resource dependencies.

**Community and Support:**
The module is compatible with Terraform Registry, allowing you to benefit from community support, versioning, and documentation. Contribute improvements, report issues, and share best practices with other users to help improve the module and its ecosystem.

### Summary

This module streamlines the process of managing AWS Security Groups, making it easier, safer, and more efficient. Whether you are building a new environment or managing existing resources, it provides the flexibility and control you need to implement robust network security in AWS. By adopting this module, you reduce manual effort, improve consistency, and ensure your infrastructure is secure and compliant. The module’s advanced features, best practices, and integration capabilities make it an essential tool for any AWS or Terraform user looking to automate and standardize security group management.

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
Defines all AWS resources, including:

#### Data Sources
- **data.aws_caller_identity.current**: Always created. Used for tagging all resources with AWS account and user info.

#### Security Group Resources
- **aws_security_group.this-dbc**: Created when `security_group_id` is not provided, `use_name_prefix` is false, and `create_before_destroy` is false. Uses a fixed name and does not use create_before_destroy lifecycle.
- **aws_security_group.this-name-prefix-dbc**: Created when `security_group_id` is not provided, `use_name_prefix` is true, and `create_before_destroy` is false. Uses a name prefix and does not use create_before_destroy lifecycle.
- **aws_security_group.this-cbd**: Created when `security_group_id` is not provided, `use_name_prefix` is false, and `create_before_destroy` is true. Uses a fixed name and create_before_destroy lifecycle for zero-downtime replacement.
- **aws_security_group.this-name-prefix-cbd**: Created when `security_group_id` is not provided, `use_name_prefix` is true, and `create_before_destroy` is true. Uses a name prefix and create_before_destroy lifecycle for zero-downtime replacement.

#### Security Group Rule Resources
- **aws_vpc_security_group_ingress_rule.this**: Created for each item in `var.ingress_rules` when `local.this_sg_id` is set and the list is non-empty. Uses for_each to attach rules to the selected security group.
- **aws_vpc_security_group_egress_rule.this**: Created for each item in `var.egress_rules` when `local.this_sg_id` is set and the list is non-empty. Uses for_each to attach rules to the selected security group.

### variables.tf
Defines all input variables for configuration, rule schemas, network, and tagging. Each variable is documented with its purpose, use case, and default value. See the Variables section for details.

### locals.tf
Defines local values for conditional resource creation, selection, and output references. Centralizes logic for resource selection and configuration, improving maintainability and readability.

### network.conf.tf
Defines data sources for AWS region and VPC selection:
- **data.aws_region.default**: Created only if `security_group_id` is not provided. Retrieves the AWS region for resource deployment. Depends on `var.security_group_id` (count = 1 if null).
- **data.aws_vpc.default**: Created only if `vpc_name` is not provided (empty string) and `vpc_id` is not set. Retrieves the default VPC for resource placement. Depends on `var.vpc_name` and `var.vpc_id` (count = 1 if both are empty).
- **data.aws_vpc.provided-vpc**: Created only if `vpc_name` is provided (not empty) and `vpc_id` is not set. Retrieves a specific VPC by name. Depends on `var.vpc_name` and `var.vpc_id` (count = 1 if name is set and id is empty).
- **null_resource.abort_multiple_vpcs**: Created only if `vpc_name` is provided (not empty) and `vpc_id` is not set. Validates that only one VPC matches the provided name, aborts if multiple are found. Depends on `var.vpc_name` and `var.vpc_id`.

### outputs.tf
Defines outputs for security group ID, ARN, and name, using local references. Outputs are documented for downstream use, integration, and compliance.

### versions.tf
Specifies Terraform and AWS provider version requirements.

---


## Example Usage
```hcl
module "security_group" {
  source = "git::https://github.com/roymanash16996-lab/terraform-aws-security-group.git?ref=<commit-hash>"

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

## Requirements

- Terraform >= 1.5.7
- AWS Provider >= 6.12.0
- Null Provider >= 3.2.2 (required for null_resource validation)

---

## Resources
### Security Group Resources
- **aws_security_group.this-dbc**: Created when `security_group_id` is not provided, `use_name_prefix` is false, and `create_before_destroy` is false. Uses a fixed name and does not use create_before_destroy lifecycle.
- **aws_security_group.this-name-prefix-dbc**: Created when `security_group_id` is not provided, `use_name_prefix` is true, and `create_before_destroy` is false. Uses a name prefix and does not use create_before_destroy lifecycle.
- **aws_security_group.this-cbd**: Created when `security_group_id` is not provided, `use_name_prefix` is false, and `create_before_destroy` is true. Uses a fixed name and create_before_destroy lifecycle for zero-downtime replacement.
- **aws_security_group.this-name-prefix-cbd**: Created when `security_group_id` is not provided, `use_name_prefix` is true, and `create_before_destroy` is true. Uses a name prefix and create_before_destroy lifecycle for zero-downtime replacement.

### Security Group Rule Resources
- **aws_vpc_security_group_ingress_rule.this**: Created for each item in `var.ingress_rules` when `local.this_sg_id` is set and the list is non-empty. Uses for_each to attach rules to the selected security group.
- **aws_vpc_security_group_egress_rule.this**: Created for each item in `var.egress_rules` when `local.this_sg_id` is set and the list is non-empty. Uses for_each to attach rules to the selected security group.

### Data Sources
- **data.aws_caller_identity.current**: Always created. Used for tagging all resources with AWS account and user info.
- **data.aws_region.default**: Created only if `security_group_id` is not provided (i.e., a new security group is being created). Depends on `var.security_group_id` (count = 1 if null). Retrieves the AWS region for resource deployment and VPC selection.
- **data.aws_vpc.default**: Created only if both `vpc_name` and `vpc_id` are not provided (empty string). Depends on `var.vpc_name` and `var.vpc_id` (count = 1 if both are empty). Retrieves the default VPC for resource placement.
- **data.aws_vpc.provided-vpc**: Created only if `vpc_name` is provided (not empty) and `vpc_id` is not set. Depends on `var.vpc_name` and `var.vpc_id` (count = 1 if name is set and id is empty). Retrieves a specific VPC by name.
- **null_resource.abort_multiple_vpcs**: Created only if `vpc_name` is provided (not empty) and `vpc_id` is not set. Depends on `var.vpc_name` and `var.vpc_id`. Validates that only one VPC matches the provided name, aborts if multiple are found and instructs the user to provide a VPC ID instead.

---

---

## Variables

| variable_name              | description                                                                                           | required  | type         | default value |
|----------------------------|-------------------------------------------------------------------------------------------------------|-----------|--------------|---------------|
| [create_before_destroy](#create_before_destroy)      | Enable create_before_destroy lifecycle policy for zero-downtime replacement.                          | Optional  | bool         | true          |
| [use_name_prefix](#use_name_prefix)            | Use name_prefix for auto-generated SG names.                                                          | Optional  | bool         | false         |
| [name](#name)                       | The name of the security group. If omitted, Terraform assigns a random name.                          | Optional  | string       | null          |
| [description](#description)                | Description of the security group. Defaults to 'Security Group managed by Terraform'.                 | Optional  | string       | "Security Group managed by Terraform" |
| [revoke_rules_on_delete](#revoke_rules_on_delete)     | Revoke all rules when the SG is deleted. Defaults to true.                                            | Optional  | bool         | true          |
| [security_group_id](#security_group_id)          | ID of an existing SG to use. If provided, no new SG is created.                                       | Optional  | string       | null          |
| [ingress_rules](#ingress_rules)              | List of ingress rule objects. See Rule Schema below.                                                  | Optional  | list(object) | []            |
| [egress_rules](#egress_rules)               | List of egress rule objects. See Rule Schema below.                                                   | Optional  | list(object) | []            |
| [region](#region)                     | AWS region for deployment. Default is provider region.                                                | Optional  | string       | ""           |
| [vpc_name](#vpc_name)                   | Name of the VPC for deployment. If not provided, uses default VPC.                                   | Optional  | string       | ""           |
| [subnet_type](#subnet_type)                | Subnet type for the instance. Options: 'public', 'private-with-nat', 'private-isolated'.             | Optional  | string       | null          |
| [availability_zone](#availability_zone)          | Availability zone for the instance. Default is first AZ of selected VPC.                             | Optional  | string       | null          |
| [tags](#tags)                       | Map of custom tags to assign to the security group.                                                  | Optional  | map(string)  | {}            |

---

### Variable Descriptions

#### create_before_destroy
Enable create_before_destroy lifecycle policy for zero-downtime replacement of the security group. Set to true to ensure a new security group is created before the old one is destroyed.

#### use_name_prefix
If true, uses a name prefix for the security group instead of a fixed name. Useful for auto-generating unique names.

#### name
The name of the security group. If omitted, Terraform will assign a random name.

#### description
Description of the security group. Defaults to 'Security Group managed by Terraform'.

#### revoke_rules_on_delete
If true, all rules will be revoked when the security group is deleted. Defaults to true for safety.

#### security_group_id
ID of an existing security group to use. If provided, no new security group will be created and rules will be attached to this group.


#### ingress_rules
List of ingress rule objects. Each object defines a rule for incoming traffic. See Rule Schema below for details.
If not provided or left empty, no ingress rules will be created for the security group, and the group will not allow any inbound traffic by default.

#### egress_rules
List of egress rule objects. Each object defines a rule for outgoing traffic. See Rule Schema below for details.
If not provided or left empty, no egress rules will be created for the security group, and the group will not allow any outbound traffic by default.

#### region
AWS region for deployment. If not specified, uses the provider's default region.

#### vpc_name
Name of the VPC where the security group will be deployed. If not provided, the default VPC is used.

#### subnet_type
Type of subnet for the instance. Options are 'public', 'private-with-nat', or 'private-isolated'.

#### availability_zone
Availability zone for the instance. Defaults to the first AZ of the selected VPC.

#### tags
Map of custom tags to assign to the security group and its rules. Useful for organization and cost allocation.


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

- Security group resources are created only if `security_group_id` is not provided.
- The resource variant (`this-dbc`, `this-name-prefix-dbc`, `this-cbd`, `this-name-prefix-cbd`) is selected based on the values of `use_name_prefix` and `create_before_destroy`.
- If `security_group_id` is provided, no new security group is created; rules are attached to the existing group.
- Security group rule resources are created for each item in `ingress_rules` and `egress_rules` only when the corresponding list is non-empty and a security group ID is available.

---


## Tagging

All resources and rules are tagged with:
- `CreatedBy`: AWS caller identity ARN (`data.aws_caller_identity.current.arn`)
- `Owner`: AWS account ID (`data.aws_caller_identity.current.account_id`)
- `CreatedAt`: Timestamp of creation
- `Name`: Security group name
- Custom tags from `var.tags`

---

## Outputs

| output_name           | description                                 | type    |
|-----------------------|---------------------------------------------|---------|
| security_group_id     | The ID of the created or referenced security group. Use for referencing the security group in other modules or resources (e.g., EC2, ELB, Lambda). | string  |
| security_group_arn    | The ARN of the created security group. Use for IAM policies, cross-account access, or compliance reporting. | string  |
| security_group_name   | The name of the created security group. Use for logging, monitoring, or integration with systems that require the security group name. | string  |

| output_name           | description                                 | type    |
|-----------------------|---------------------------------------------|---------|
| security_group_id     | The ID of the created or referenced security group                | string  |
| security_group_arn    | The ARN of the created security group               | string  |
| security_group_name   | The name of the created security group              | string  |

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
Licensed by Self
