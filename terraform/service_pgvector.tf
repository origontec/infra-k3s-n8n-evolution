
resource "kubernetes_service" "pgvector" {
  metadata {
    name      = "pgvector"
    namespace = kubernetes_namespace.infra_n8n.metadata[0].name
  }

  spec {
    selector = {
      app = "pgvector"
    }

    port {
      name        = "postgres"
      port        = 5432
      target_port = 5432
    }

    type = "ClusterIP"
  }
}
