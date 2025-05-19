provider "kubernetes" {
  host = "https://$(minikube ip):8443"
  insecure_skip_tls_verify = true  // Only for development!
  
  # Load certs from Minikube's standard location
  client_certificate     = file("~/.minikube/profiles/minikube/client.crt")
  client_key             = file("~/.minikube/profiles/minikube/client.key") 
  cluster_ca_certificate = file("~/.minikube/ca.crt")
}
