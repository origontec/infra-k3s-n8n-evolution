resource "kubernetes_persistent_volume" "pgvector_pv" {
  metadata {
    name = "local-pv"
  }

  spec {
    capacity = {
      storage = "10Gi"
    }

    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = "manual"

    persistent_volume_source {
      local {
        path = "/mnt/data"
      }
    }

    node_affinity {
      required {
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
