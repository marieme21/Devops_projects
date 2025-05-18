terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

# Connect to REMOTE Kubernetes cluster
provider "kubernetes" {
  config_path = "~/.kube/config"  # File copied from your K8s VM
}
