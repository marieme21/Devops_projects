resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "frontend"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }

      spec {
        container {
          name  = "frontend"
          image = "marieme21/projetfilrouge_frontend"  # Explicit tag recommended

          port {
            container_port = 80
          }

          env {
            name  = "API_URL"
            value = "http://api.local/"  # Updated to use K8s service DNS
          }
        }
      }
    }
  }
  timeouts {
    create = "5m"  # Wait up to 5 minutes for API operations
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = "frontend-service"
  }

  spec {
    type = "NodePort"

    selector = {
      app = kubernetes_deployment.frontend.spec.0.template.0.metadata.0.labels.app
    }

    port {
      port        = 80
      target_port = 80
      node_port   = 30080  # Matches your original manifest
    }
  }
  timeouts {
    create = "5m"  # Wait up to 5 minutes for API operations
  }
}
