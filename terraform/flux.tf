


provider "helm" {    
    kubernetes {
        config_path = "/home/gipsydanger/.kube/config"
    }
}
variable "values_file" {
  description = "The name of the traefik helmchart values file to use"
  type        = string
  default     = "values.yaml"
}

resource "helm_release" "flux" {
  depends_on = [null_resource.local_k8s_context]
  repository       = "https://fluxcd-community.github.io/helm-charts"
  chart            = "flux2"
  name             = "flux2"
  namespace        = "flux-system"
  create_namespace = true
  values = [fileexists("${path.root}/${var.values_file}") == true ? file("${path.root}/${var.values_file}") : ""]
}

# provider "flux" {
#   kubernetes = {
#     config_path = "/home/gipsydanger/.kube/config"
#   }
#   git = {
#     url = "https://github.com/rastydnb/home-cheap-gke-cluster.git"
#   }
# }

# resource "flux_bootstrap_git" "this" {

#   path = "kubernetes/flux"
# }

# resource "null_resource" "bootstrap_flux" {
#   provisioner "local-exec" {
#     command = "kubectl apply --kustomize ../kubernetes/bootstrap"
#   }
# }

resource "null_resource" "flux_config" {
  depends_on = [helm_release.flux]
  provisioner "local-exec" {
    command = "kubectl apply --kustomize ../kubernetes/flux-system"
  }
}




