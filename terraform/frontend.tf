resource "kubernetes_deployment" "react" {
  metadata {
    name = "react-frontend"
    labels = {
      app = "react"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "react"
      }
    }
    template {
      metadata {
        labels = {
          app = "react"
        }
      }
      spec {
        container {
          name  = "react"
          image = "your-dockerhub-username/react-app:latest"
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "react" {
  metadata {
    name = "react-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.react.spec.0.template.0.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 3000
    }
    type = "LoadBalancer"
  }
}
