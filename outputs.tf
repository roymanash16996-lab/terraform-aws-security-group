

# -----------------------------------------------------------------------------
# Output: security_group_id
# Purpose: Exposes the ID of the created or referenced security group.
# Use Case: Use for referencing the security group in other modules or resources (e.g., EC2, ELB, Lambda).
# Logic: Always returns the selected security group ID, whether created by this module or provided externally.
# -----------------------------------------------------------------------------
output "security_group_id" {
  description = "The ID of the security group."
  value       = local.this_sg_id
}



# -----------------------------------------------------------------------------
# Output: security_group_arn
# Purpose: Exposes the ARN of the created security group.
# Use Case: Use for IAM policies, cross-account access, or compliance reporting.
# Logic: Returns the ARN if a security group was created by this module; returns null if using an external SG.
# Fallback: Uses try to avoid errors if created_security_group is null.
# -----------------------------------------------------------------------------
output "security_group_arn" {
  description = "The ARN of the security group."
  value       = try(local.created_security_group.arn, null)
}



# -----------------------------------------------------------------------------
# Output: security_group_name
# Purpose: Exposes the name of the created security group.
# Use Case: Use for logging, monitoring, or integration with systems that require the security group name.
# Logic: Returns the name if a security group was created by this module; returns null if using an external SG.
# Fallback: Uses try to avoid errors if created_security_group is null.
# -----------------------------------------------------------------------------
output "security_group_name" {
  description = "The name of the security group."
  value       = try(local.created_security_group.name, null)
}