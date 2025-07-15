resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = var.namespace

  values = [
    templatefile("${path.module}/values.yaml", {
      admin_password     = var.admin_password
    })
  ]
}
