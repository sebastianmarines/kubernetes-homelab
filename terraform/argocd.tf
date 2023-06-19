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
}
