provider "kubernetes" {
  host = "https://${var.minikube_ip}:8443"
  
  # Required for Docker driver
  insecure_skip_tls_verify = true
  
  # Certificate paths (Docker driver specific)
  client_certificate     = file("~/.minikube/profiles/minikube/client.crt")
  client_key             = file("~/.minikube/profiles/minikube/client.key")
  cluster_ca_certificate = file("~/.minikube/ca.crt")
}
