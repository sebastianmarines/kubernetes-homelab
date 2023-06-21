resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "sealed-secrets"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "argo-cd"

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }

  set {
    name  = "controller.metrics.serviceMonitor.namespace"
    value = kubernetes_namespace.argocd.metadata[0].name
  }

  set {
    name  = "controller.metrics.serviceMonitor.enabled"
    value = "true"
  }
}

data "kubernetes_secret" "argocd" {
  metadata {
    name      = "argocd-secret"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }
}

output "argocd_password" {
  value     = data.kubernetes_secret.argocd.data["clearPassword"]
  sensitive = true
}
