terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config" # Local cluster config
}

# PostgreSQL Deployment
resource "kubernetes_deployment" "postgres" {
  metadata {
    name = "postgres"
  }

  spec {
    replicas = 1

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
            value = "zou123"
          }

          env {
            name  = "POSTGRES_DB"
            value = "odc_db"
          }

          port {
            container_port = 5432
          }

          volume_mount {
            name       = "postgres-data"
            mount_path = "/var/lib/postgresql/data"
          }
        }

        volume {
          name = "postgres-data"
          empty_dir {}
        }
      }
    }
  }
}

# Backend Deployment (Django)
resource "kubernetes_deployment" "backend" {
  metadata {
    name = "backend"
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
          args  = ["python", "manage.py", "runserver", "0.0.0.0:8000"]

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

# Frontend Deployment (React)
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

# Services
resource "kubernetes_service" "postgres" {
  metadata {
    name = "postgres-service"
  }

  spec {
    selector = {
      app = "postgres"
    }

    port {
      port        = 5432
      target_port = 5432
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name = "backend-service"
  }

  spec {
    type = "NodePort"
    
    selector = {
      app = "backend"
    }

    port {
      name        = "http"
      port        = 8000
      target_port = 8000
      node_port   = 30083
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = "frontend-service"
  }

  spec {
    type = "NodePort"
    
    selector = {
      app = "frontend"
    }

    port {
      port        = 80
      target_port = 80
      node_port   = 30080
    }
  }
}
