#################################################################
# Creation Configurations
#################################################################

# -----------------------------------------------------------------------------
# Variable: create_before_destroy
# Purpose: Enables zero-downtime replacement of security groups.
# Use Case: Set to true for production or critical workloads where downtime is unacceptable during updates.
# -----------------------------------------------------------------------------
variable "create_before_destroy" {
  description = "Flag to enable create_before_destroy lifecycle policy on the security group. Useful when you want to replace the security group without downtime."
  type        = bool
  default     = true
}

#################################################################
# Security Group Configurations
#################################################################


# -----------------------------------------------------------------------------
# Variable: use_name_prefix
# Purpose: Determines whether to use a name prefix for auto-generated security group names.
# Use Case: Set to true for multi-environment deployments to avoid naming collisions.
# -----------------------------------------------------------------------------
variable "use_name_prefix" {
  description = "Flag to use name_prefix instead of name for the security group. If true, the security group name will be auto-generated with the provided prefix."
  type        = bool
  default     = false
}


# -----------------------------------------------------------------------------
# Variable: name
# Purpose: Sets the name of the security group.
# Use Case: Use for integration with systems that require a specific security group name.
# -----------------------------------------------------------------------------
variable "name" {
  description = "The name of the security group. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = "terraform"
  validation {
    condition     = var.name == null || length(var.name) > 3
    error_message = "The security group name must be either omitted or longer than 3 characters."
  }
}


# -----------------------------------------------------------------------------
# Variable: description
# Purpose: Sets the description for the security group.
# Use Case: Use to provide context or compliance information for the security group.
# -----------------------------------------------------------------------------
variable "description" {
  description = "The description of the security group. Defaults to 'Security Group managed by Terraform'."
  type        = string
  default     = "Security Group managed by Terraform"
}


# -----------------------------------------------------------------------------
# Variable: revoke_rules_on_delete
# Purpose: Ensures all rules are revoked when the security group is deleted.
# Use Case: Set to true for security best practices and compliance.
# -----------------------------------------------------------------------------
variable "revoke_rules_on_delete" {
  description = "Flag to revoke all rules when the security group is deleted. Defaults to true."
  type        = bool
  default     = true
}



# -----------------------------------------------------------------------------
# Variable: security_group_id
# Purpose: Allows use of an externally managed security group.
# Use Case: Provide when you want to manage rules for a security group created outside this module.
# Logic: If set, no new security group is created; rules are attached to the provided group.
# Default: null (module creates a new security group unless overridden).
# -----------------------------------------------------------------------------
variable "security_group_id" {
  description = "The ID of an existing security group to use. If provided, the module will not create a new security group."
  type        = string
  default     = null

  validation {
    condition     = var.security_group_id == null || (
                      length(trimspace(var.security_group_id)) > 0 &&
                      !contains(split(",", var.security_group_id), "")
                    )
    error_message = "security_group_id must be either null or a non-empty single security group ID without commas."
  }
}

#################################################################
# Security Group Rules Configurations
#################################################################


# -----------------------------------------------------------------------------
# Variable: ingress_rules
# Purpose: Defines a list of ingress rules for the security group.
# Use Case: Specify granular inbound access policies for your resources. Each rule supports only one source type (CIDR, prefix list, or security group).
# Example: Allow SSH from a specific IP, HTTP from a load balancer, or custom rules for microservices.
# -----------------------------------------------------------------------------
variable "ingress_rules" {
  /*
   * A list of ingress rules to apply to the security group.
   * Each rule should be a map with the following keys:
   * - ip_protocol: The protocol to allow (e.g., "tcp", "udp", "icmp", "-1" for all).
   * - from_port: The starting port for the rule.
   * - to_port: The ending port for the rule.
   * - cidr_ipv4: (Optional) The IPv4 CIDR block to allow. Mutually exclusive with cidr_ipv6, prefix_list_id, and referenced_security_group_id.
   * - cidr_ipv6: (Optional) The IPv6 CIDR block to allow. Mutually exclusive with cidr_ipv4, prefix_list_id, and referenced_security_group_id.
   * - prefix_list_id: (Optional) The ID of an AWS prefix list to allow. Mutually exclusive with cidr_ipv4, cidr_ipv6, and referenced_security_group_id.
   * - referenced_security_group_id: (Optional) The ID of a referenced security group to allow. Mutually exclusive with cidr_ipv4, cidr_ipv6, and prefix_list_id.
   * - description: (Optional) A description for the rule.
   *
   * By default, allows all inbound traffic. To restrict inbound traffic, provide specific rules.
   * To remove all inbound traffic, provide an empty list.
   */
  description = "A list of ingress rules to apply to the security group. Each rule should be a map with the following keys: ip_protocol, from_port, to_port, cidr_ipv4, cidr_ipv6, prefix_list_id, referenced_security_group_id, description. For each rule, provide only one of the following mutually exclusive attributes: cidr_ipv4, cidr_ipv6, prefix_list_id, or referenced_security_group_id. By default, allows all inbound traffic. If you want to restrict inbound traffic, provide specific rules. If you want to remove all inbound traffic, provide an empty list."
  type = list(object({
    ip_protocol                  = string
    from_port                    = optional(number, )
    to_port                      = optional(number, )
    cidr_ipv4                    = optional(string, "")
    cidr_ipv6                    = optional(string, "")
    prefix_list_id               = optional(string, "")
    referenced_security_group_id = optional(string, "")
    description                  = optional(string, "Default ingress rule description")
  }))
  default = []

  # Validation: Ensures each ingress rule specifies exactly one mutually exclusive source type (CIDR, prefix list, or security group).
  validation {
    condition = alltrue([
      for rule in var.ingress_rules : (
        (
          (rule.cidr_ipv4 != "" ? 1 : 0) +
          (rule.cidr_ipv6 != "" ? 1 : 0) +
          (rule.prefix_list_id != "" ? 1 : 0) +
          (rule.referenced_security_group_id != "" ? 1 : 0)
        ) == 1
      )
    ])
    error_message = "Each ingress rule must specify exactly one of: cidr_ipv4, cidr_ipv6, prefix_list_id, or referenced_security_group_id. Multiple or none are not allowed."
  }
}


# -----------------------------------------------------------------------------
# Variable: egress_rules
# Purpose: Defines a list of egress rules for the security group.
# Use Case: Specify granular outbound access policies for your resources. Each rule supports only one destination type (CIDR, prefix list, or security group).
# Example: Allow outbound traffic only to a database subnet, or restrict access to specific external APIs.
# -----------------------------------------------------------------------------
variable "egress_rules" {
  /*
   * A list of egress rules to apply to the security group.
   * Each rule should be a map with the following keys:
   * - ip_protocol: The protocol to allow (e.g., "tcp", "udp", "icmp", "-1" for all).
   * - from_port: The starting port for the rule.
   * - to_port: The ending port for the rule.
   * - cidr_ipv4: (Optional) The IPv4 CIDR block to allow. Mutually exclusive with cidr_ipv6, prefix_list_id, and referenced_security_group_id.
   * - cidr_ipv6: (Optional) The IPv6 CIDR block to allow. Mutually exclusive with cidr_ipv4, prefix_list_id, and referenced_security_group_id.
   * - prefix_list_id: (Optional) The ID of an AWS prefix list to allow. Mutually exclusive with cidr_ipv4, cidr_ipv6, and referenced_security_group_id.
   * - referenced_security_group_id: (Optional) The ID of a referenced security group to allow. Mutually exclusive with cidr_ipv4, cidr_ipv6, and prefix_list_id.
   * - description: (Optional) A description for the rule.
   *
   * By default, allows all outbound traffic. To restrict outbound traffic, provide specific rules.
   * To remove all outbound traffic, provide an empty list.
   */
  description = "A list of egress rules to apply to the security group. Each rule should be a map with the following keys: ip_protocol, from_port, to_port, cidr_ipv4, cidr_ipv6, prefix_list_id, referenced_security_group_id, description. For each rule, provide only one of the following mutually exclusive attributes: cidr_ipv4, cidr_ipv6, prefix_list_id, or referenced_security_group_id. By default, allows all outbound traffic. If you want to restrict outbound traffic, provide specific rules. If you want to remove all outbound traffic, provide an empty list."
  type = list(object({
    ip_protocol                  = string
    from_port                    = optional(number, )
    to_port                      = optional(number, )
    cidr_ipv4                    = optional(string, "")
    cidr_ipv6                    = optional(string, "")
    prefix_list_id               = optional(string, "")
    referenced_security_group_id = optional(string, "")
    description                  = optional(string, "Default egress rule description")
  }))
  default = []

  # Validation: Ensures each egress rule specifies exactly one mutually exclusive destination type (CIDR, prefix list, or security group).
  validation {
    condition = alltrue([
      for rule in var.egress_rules : (
        (
          (rule.cidr_ipv4 != "" ? 1 : 0) +
          (rule.cidr_ipv6 != "" ? 1 : 0) +
          (rule.prefix_list_id != "" ? 1 : 0) +
          (rule.referenced_security_group_id != "" ? 1 : 0)
        ) == 1
      )
    ])
    error_message = "Each egress rule must specify exactly one of: cidr_ipv4, cidr_ipv6, prefix_list_id, or referenced_security_group_id. Multiple or none are not allowed."
  }
}

#################################################################
# Network Configurations
#################################################################


# -----------------------------------------------------------------------------
# Variable: region
# Purpose: Sets the AWS region for resource deployment.
# Use Case: Override the default provider region for multi-region deployments.
# -----------------------------------------------------------------------------
variable "region" {
  description = "AWS region to deploy the instance. Default is the region configured in AWS provider."
  type        = string
  default     = ""
}


# -----------------------------------------------------------------------------
# Variable: vpc_name
# Purpose: Specifies the VPC for resource placement.
# Use Case: Use to target a specific VPC by name, or leave blank for the default VPC.
# -----------------------------------------------------------------------------

variable "vpc_id" {
  description = "ID of the VPC where the instance will be deployed. If not provided, the VPC will be determined based on vpc_name or default VPC."
  type        = string
  default     = ""
}

#################################################################
# Security Group Tagging
#################################################################


# -----------------------------------------------------------------------------
# Variable: tags
# Purpose: Custom tags for all resources created by the module.
# Use Case: Use to add environment, owner, cost center, or other metadata for resource management and billing.
# -----------------------------------------------------------------------------
variable "tags" {
  description = "A map of tags to assign to the security group."
  type        = map(string)
  default     = {}
}