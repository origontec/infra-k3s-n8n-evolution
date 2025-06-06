
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "infra_n8n" {
  metadata {
    name = "infra-n8n"
  }
}
