#################################################################
# Creation Configurations
#################################################################

variable "create" {
  description = "Flag to create the security group or security group rules. If false, assumes the security group is managed outside of this module."
  type        = bool
  default     = true
}

variable "create_security_group" {
  description = "Flag to create the security group. If false, assumes the security group is managed outside of this module."
  type        = bool
  default     = true
}

variable "create_before_destroy" {
  description = "Flag to enable create_before_destroy lifecycle policy on the security group. Useful when you want to replace the security group without downtime."
  type        = bool
  default     = true
}

#################################################################
# Security Group Configurations
#################################################################

variable "use_name_prefix" {
  description = "Flag to use name_prefix instead of name for the security group. If true, the security group name will be auto-generated with the provided prefix."
  type        = bool
  default     = false
}

variable "name" {
  description = "The name of the security group. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the security group. Defaults to 'Security Group managed by Terraform'."
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "revoke_rules_on_delete" {
  description = "Flag to revoke all rules when the security group is deleted. Defaults to true."
  type        = bool
  default     = true
}

variable "security_group_id" {
  description = "The ID of an existing security group to use. If provided, the module will not create a new security group."
  type        = string
  default     = null
}

#################################################################
# Security Group Rules Configurations
#################################################################

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
    from_port                    = optional(number, 0)
    to_port                      = optional(number, 0)
    cidr_ipv4                    = optional(string, "0.0.0.0/0")
    cidr_ipv6                    = optional(string, "::/0")
    prefix_list_id               = optional(string, "")
    referenced_security_group_id = optional(string, "")
    description                  = optional(string, "Default ingress rule to allow all traffic within the security group")
  }))
  default = []
}

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
    from_port                    = optional(number, 0)
    to_port                      = optional(number, 0)
    cidr_ipv4                    = optional(string, "0.0.0.0/0")
    cidr_ipv6                    = optional(string, "::/0")
    prefix_list_id               = optional(string, "")
    referenced_security_group_id = optional(string, "")
    description                  = optional(string, "Default ingress rule to allow all traffic within the security group")
  }))
  default = []
}

#################################################################
# Network Configurations
#################################################################

variable "region" {
  description = "AWS region to deploy the instance. Default is the region configured in AWS provider."
  type        = string
  default     = ""
}

variable "vpc_name" {
  description = "Name of the VPC where the instance will be deployed. If not provided, the default VPC will be used."
  type        = string
  default     = ""
}

variable "subnet_type" {
  description = "Type of subnet for the instance. Options are 'public', 'private-with-nat', 'private-isolated'. Default is 'public'. Options are case-sensitive and need to be mentioned in Subnet name."
  type        = string
  default     = ""
}

variable "availability_zone" {
  description = "Availability zone for the EC2 instance. Default is the first availability zone of the selected VPC."
  type        = string
  default     = ""
}

#################################################################
# Security Group Tagging
#################################################################

variable "tags" {
  description = "A map of tags to assign to the security group."
  type        = map(string)
  default     = {}
}