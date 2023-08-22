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