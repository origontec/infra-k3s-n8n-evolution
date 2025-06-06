
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
        containers {
          name  = "pgvector"
          image = "ankane/pgvector"
          ports {
            container_port = 5432
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = "pgvector123"
          }
          volume_mounts {
            mount_path = "/var/lib/postgresql/data"
            name       = "pgdata"
          }
        }

        volumes {
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
                  values   = ["kube-ghp"]
                }
              }
            }
          }
        }
      }
    }
  }
}
