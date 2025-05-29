# PostgreSQL Deployment
resource "kubernetes_deployment" "postgres" {
  metadata {
    name = "postgres"
    labels = {
      app = "postgres"
    }
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
            value = "zou123"  # In production, use kubernetes_secret resource
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
          empty_dir {}  # For development only
        }
      }
    }
  }
  timeouts {
    create = "5m"  # Wait up to 5 minutes for API operations
  }
}

# PostgreSQL Service
resource "kubernetes_service" "postgres" {
  metadata {
    name = "postgres-service"
  }

  spec {
    selector = {
      app = kubernetes_deployment.postgres.spec.0.template.0.metadata.0.labels.app
    }

    port {
      port        = 5432
      target_port = 5432
    }

    type = "ClusterIP"  # Default - only accessible within cluster
  }
  timeouts {
    create = "5m"  # Wait up to 5 minutes for API operations
  }
}
