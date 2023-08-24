output "service_account" {
  description = "Service Account for External Secrets Operator"
  value       = module.service_account.email
}