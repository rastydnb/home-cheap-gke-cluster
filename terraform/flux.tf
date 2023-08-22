variable "github_token" {
  sensitive = true
  type      = string
  default = "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"
}

variable "github_org" {
  type = string
  default = "rastydnb"
}

variable "github_repository" {
  type = string
  default = "home-cheap-gke-cluster"
}


terraform {
  required_providers {
    flux = {
      source = "fluxcd/flux"
      version = "1.0.1"
    }
    kind = {
      source  = "tehcyx/kind"
      version = ">=0.0.16"
    }
    github = {
      source  = "integrations/github"
      version = ">=5.18.0"
    }
  }
}


provider "kind" {}

resource "kind_cluster" "this" {
  name = "flux-e2e"
}


provider "github" {
  owner = var.github_org
  token = var.github_token
}

resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "this" {
  title      = "Flux"
  repository = var.github_repository
  key        = tls_private_key.flux.public_key_openssh
  read_only  = "false"
}


provider "flux" {
  kubernetes = {
    host                   = kind_cluster.this.endpoint
    client_certificate     = kind_cluster.this.client_certificate
    client_key             = kind_cluster.this.client_key
    cluster_ca_certificate = kind_cluster.this.cluster_ca_certificate
  }
  git = {
    url = "ssh://git@github.com/${var.github_org}/${var.github_repository}.git"
    ssh = {
      username    = "git"
      private_key = tls_private_key.flux.private_key_pem
    }
  }
}

resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository_deploy_key.this]

  path = "kubernetes/flux"
}




provider "helm" {    
    kubernetes {
        config_path = "/home/gipsydanger/.kube/config"
    }
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

# resource "null_resource" "flux_config" {
#   depends_on = [null_resource.bootstrap_flux]
#   provisioner "local-exec" {
#     command = "kubectl apply --kustomize ../kubernetes/flux/config"
#   }
# }




