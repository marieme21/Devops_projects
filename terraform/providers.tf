provider "kubernetes" {
  host     = "https://$(minikube ip):8443"
  insecure = true  # Only for local development!
  
  client_certificate     = file("~/.minikube/profiles/minikube/client.crt")
  client_key             = file("~/.minikube/profiles/minikube/client.key")
  cluster_ca_certificate = file("~/.minikube/ca.crt")
}
