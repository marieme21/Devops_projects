# Backend (Django) Deployment
resource "kubernetes_deployment" "backend" {
  metadata {
    name = "backend"
  }

  spec {
    replicas = 1  # Start with 1 for testing
    
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
        }
      }
    }
  }
}

# Frontend (React) Deployment
resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "frontend"
  }

  spec {
    replicas = 1  # Start with 1 for testing
    
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
          name  = "react"
          image = "marieme21/projetfilrouge_frontend:latest"
          port {
            container_port = 80
          }
          
          env {
            name  = "API_URL"
            value = "http://backend-service:8000/"
          }
        }
      }
    }
  }
}

# PostgreSQL Database
resource "kubernetes_deployment" "postgres" {
  metadata {
    name = "postgres"
  }

  spec {
    replicas = 1  # Single instance for simplicity
    
    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:14-alpine"
          
          env {
            name  = "POSTGRES_USER"
            value = "postgres"
          }
          
          env {
            name  = "POSTGRES_PASSWORD"
            value = "zou123"  # In production, use Kubernetes Secrets
          }
          
          env {
            name  = "POSTGRES_DB"
            value = "odc_db"
          }
          
          port {
            container_port = 5432
          }
        }
      }
    }
  }
}
