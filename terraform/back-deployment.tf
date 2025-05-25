resource "kubernetes_deployment" "backend" {
  metadata {
    name = "backend"
    labels = {
      app = "backend"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }

      spec {
        container {
          name  = "django"
          image = "marieme21/projetfilrouge_backend:latest"
          
          port {
            container_port = 8000
          }

          env {
            name  = "DATABASE_URL"
            value = "postgres://postgres:zou123@postgres-service/odc_db"
          }

          command = ["python", "manage.py", "runserver", "0.0.0.0:8000"]
        }

        restart_policy = "Always"
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name = "backend-service"
  }

  spec {
    selector = {
      app = "backend"
    }

    port {
      name        = "http"
      protocol    = "TCP"
      port        = 8000
      target_port = 8000
      node_port   = 30083
    }

    type = "NodePort"
  }
}
