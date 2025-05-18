# Backend Service
resource "kubernetes_service" "backend" {
  metadata {
    name = "backend-service"
  }

  spec {
    selector = {
      app = "backend"
    }
    
    port {
      port        = 8000
      target_port = 8000
    }
    
    type = "ClusterIP"  # Internal only
  }
}

# Frontend Service (Exposed to outside)
resource "kubernetes_service" "frontend" {
  metadata {
    name = "frontend-service"
  }

  spec {
    selector = {
      app = "frontend"
    }
    
    port {
      port        = 80
      target_port = 80
      node_port   = 30080  # Accessible at <K8s-VM-IP>:30080
    }
    
    type = "NodePort"
  }
}

# PostgreSQL Service
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
    
    type = "ClusterIP"  # Only accessible within cluster
  }
}
