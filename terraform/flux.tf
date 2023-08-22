
variable "namespace" {
  description = "Namespace to install traefik chart into"
  type        = string
  default     = "traefik"
}

variable "traefik_chart_version" {
  description = "Version of Traefik chart to install"
  type        = string
  default     = "24.0.0" # See https://artifacthub.io/packages/helm/traefik/traefik for latest version(s)
}

# Helm chart deployment can sometimes take longer than the default 5 minutes
variable "timeout_seconds" {
  type        = number
  description = "Helm chart deployment can sometimes take longer than the default 5 minutes. Set a custom timeout here."
  default     = 800 # 10 minutes
}

variable "replica_count" {
  description = "Number of replica pods to create"
  type        = number
  default     = 1
}

variable "values_file" {
  description = "The name of the traefik helmchart values file to use"
  type        = string
  default     = "values.yaml"
}

provider "helm" {    
    kubernetes {
        config_path = "/home/gipsydanger/.kube/config"
    }
}

# resource "helm_release" "traefik" {
#   depends_on = [null_resource.local_k8s_context]
#   namespace        = var.namespace
#   create_namespace = true
#   name             = "traefik"
#   repository       = "https://traefik.github.io/charts"
#   chart            = "traefik"
#   version          = var.traefik_chart_version

#   # Helm chart deployment can sometimes take longer than the default 5 minutes
#   timeout = var.timeout_seconds

#   # If values file specified by the var.values_file input variable exists then apply the values from this file
#   # else apply the default values from the chart
#   values = [fileexists("${path.root}/${var.values_file}") == true ? file("${path.root}/${var.values_file}") : ""]
# }


resource "null_resource" "bootstrap_flux" {
  provisioner "local-exec" {
    command = "kubectl apply --kustomize ../kubernetes/bootstrap"
  }
}

resource "null_resource" "flux_config" {
  depends_on = [null_resource.bootstrap_flux]
  provisioner "local-exec" {
    command = "kubectl apply --kustomize ../kubernetes/flux/config"
  }
}




# resource "helm_release" "argocd" {
#   name  = "argocd"

#   repository       = "https://argoproj.github.io/argo-helm"
#   chart            = "argo-cd"
#   namespace        = "argocd"
#   version          = "5.43.4"
#   create_namespace = true

#   # values = [
#   #   file("values.yaml")
#   # ]
# }


# resource "helm_release" "argocd-apps" {
#   depends_on = [helm_release.argocd]
#   name  = "argocd-apps"

#   repository       = "https://argoproj.github.io/argo-helm"
#   chart            = "argocd-apps"
#   namespace        = "argocd"
#   version          = "1.4.1"

#   values = [
#     file("../argocd/application.yaml")
#   ]
# }