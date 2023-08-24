variable "namespace" {
  type        = string
  description = "The Kubernetes namespace"
  default = "kube-system"
}

variable "service_account" {
  type        = string
  description = "The Kubernetes service account"
  default = "shared-kubernetes-external-secrets"
}

variable "project_id" {
  default = "GCP_PROJECT_ID"
}
