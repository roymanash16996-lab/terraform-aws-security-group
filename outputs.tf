output "security_group_id" {
  description = "The ID of the security group."
  value       = local.this_sg_id  
}

output "security_group_arn" {
  description = "The ARN of the security group."
  value       = try(local.created_security_group.arn, null)
}

output "security_group_name" {
  description = "The name of the security group."
  value       = try(local.created_security_group.name, null)
}