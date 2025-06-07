resource "kubernetes_deployment" "pgvector" {
  metadata {
    name      = "pgvector"
    namespace = kubernetes_namespace.infra_n8n.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "pgvector"
      }
    }

    template {
      metadata {
        labels = {
          app = "pgvector"
        }
      }

      spec {
        container {
          name  = "pgvector"
          image = var.image_name

          port {
            container_port = 5432
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value = "pgvector123"
          }

          volume_mount {
            mount_path = "/var/lib/postgresql/data"
            name       = "pgdata"
          }
        }

        volume {
          name = "pgdata"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.pgvector_pvc.metadata[0].name
          }
        }

        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "kubernetes.io/hostname"
                  operator = "In"
                  values   = ["modelo-ubuntu-2404"]
                }
              }
            }
          }
        }
      }
    }
  }
}
