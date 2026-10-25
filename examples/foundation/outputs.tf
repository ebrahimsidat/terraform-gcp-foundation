output "network_id" {
  description = "ID of the VPC network."
  value       = module.network.network_id
}

output "subnets" {
  description = "Subnets created in the VPC."
  value       = module.network.subnets
}

output "audit_log_bucket" {
  description = "Central audit log bucket."
  value       = module.logging.bucket_id
}

output "enabled_services" {
  description = "APIs enabled in the project."
  value       = module.services.enabled_services
}
