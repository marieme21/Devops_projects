provider "kubernetes" {
  host                   = "http://$(minikube ip):8443"
  client_certificate     = file("/var/lib/jenkins/.minikube/profiles/minikube/client.crt")
  client_key             = file("/var/lib/jenkins/.minikube/profiles/minikube/client.key") 
  cluster_ca_certificate = file("/var/lib/jenkins/.minikube/ca.crt")
}
