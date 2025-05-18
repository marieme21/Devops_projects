resource "kubernetes_deployment" "django" {
  metadata {
    name = "django-backend"
    labels = {
      app = "django"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "django"
      }
    }
    template {
      metadata {
        labels = {
          app = "django"
        }
      }
      spec {
        container {
          name  = "django"
          image = "your-dockerhub-username/django-app:latest"
          port {
            container_port = 8000
          }
          env {
            name  = "DJANGO_ENV"
            value = "production"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "django" {
  metadata {
    name = "django-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.django.spec.0.template.0.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 8000
    }
    type = "NodePort"
  }
}
