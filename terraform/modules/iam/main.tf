

module "service_account" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "4.2.1"

  project_id = var.project_id

  names = [
    "external-secrets"
  ]

  project_roles = [
    format("%s=>roles/secretmanager.secretAccessor", var.project_id)
  ]
}

module "iam" {
  source  = "terraform-google-modules/iam/google//modules/service_accounts_iam"
  version = "7.6.0"

  project = var.project_id

  service_accounts = [
    module.service_account.email
  ]
  mode = "authoritative"

  bindings = {
    "roles/iam.workloadIdentityUser" = [
      format("serviceAccount:%s.svc.id.goog[%s/%s]", var.project_id, var.namespace, var.service_account)
    ]
  }
}


resource "google_project_iam_member" "secret-admin" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member = module.service_account.iam_email
}

output "project_member" {
  description = "test"
  value       = google_project_iam_member.secret-admin
}

# serviceAccount:ninjawombat.svc.id.goog[kube-system/external-secrets

























# resource "google_service_account" "service_account" {
#   account_id   = "demo-external-secrets-sa"
#   display_name = "demo-external-secrets-sa"
#   description  = "Service account to access the secret manager for External Secrets application."
#   project      = var.project_id
# }

# resource "google_service_account_iam_binding" "sa_iam_member_bind" {
#   service_account_id = google_service_account.service_account.id
#   role               = "roles/iam.workloadIdentityUser"
#   members            = ["serviceAccount:${var.project_id}.svc.id.goog[shared/shared-kubernetes-external-secrets]"]
# }

# resource "google_project_iam_member" "project_iam_member" {
#   project = var.project_id
#   role    = "roles/secretmanager.admin"
#   member  = "serviceAccount:google_service_account.service_account.email"
# }
