
resource "kubernetes_persistent_volume_claim" "pgvector_pvc" {
  metadata {
    name      = "local-pvc"
    namespace = kubernetes_namespace.infra_n8n.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "10Gi"
      }
    }

    storage_class_name = "manual"
  }
}
