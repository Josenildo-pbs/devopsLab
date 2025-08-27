
# Tekton Pipelines via Helm
resource "helm_release" "tekton_pipeline" {
  name             = "tekton-pipeline"
  repository       = "https://tekton-releases.storage.googleapis.com/helm-charts"
  chart            = "tekton-pipeline"
  namespace        = kubernetes_namespace.tekton.metadata[0].name
  create_namespace = false

  # TIP: Pin a version once you pick one (reproducible builds)
  # version = "X.Y.Z"
}

# Tekton Dashboard (GUI) via Helm
resource "helm_release" "tekton_dashboard" {
  name       = "tekton-dashboard"
  repository = "https://tekton-releases.storage.googleapis.com/helm-charts"
  chart      = "tekton-dashboard"
  namespace  = kubernetes_namespace.tekton.metadata[0].name

  # Expose on GKE with a public IP for the lab
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  # version = "X.Y.Z"  # (optional but recommended to pin)
  
  depends_on = [helm_release.tekton_pipeline]
}
