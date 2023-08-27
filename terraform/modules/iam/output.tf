output "service_account_email" {
  description = "Service Account for GCP"
  value       = module.service_account.email
}

output "service_account_iaemail" {
  description = "Service Account for GCP IAM"
  value       = module.service_account.iam_email
}


output "sa" {
  description = "SA"
  value       = module.iam
}