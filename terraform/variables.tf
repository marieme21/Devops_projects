variable "k8s_config_path" {
  description = "Path to kubeconfig file"
  default     = "~/.kube/config"
}

variable "minikube_ip" {
  description = "IP address of Minikube cluster"
  type        = string
}
