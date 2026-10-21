resource "kubernetes_secret_v1" "iap_oauth_secret" {
  metadata {
    name      = "iap-oauth-secret"
    namespace = "default"
  }

  data = {
    client_id     = var.iap_oauth_client_id
    client_secret = var.iap_oauth_client_secret
  }

  depends_on = [module.gke]
}

resource "kubernetes_manifest" "backend_config" {
  for_each = local.users

  manifest = {
    apiVersion = "cloud.google.com/v1"
    kind       = "BackendConfig"
    metadata = {
      name      = "iap-backend-config-${each.key}"
      namespace = "default"
    }
    spec = {
      iap = {
        enabled = true
        oauthclientCredentials = {
          secretName = kubernetes_secret_v1.iap_oauth_secret.metadata[0].name
        }
      }
      healthCheck = {
        checkIntervalSec   = 15
        timeoutSec         = 5
        healthyThreshold   = 1
        unhealthyThreshold = 2
        type               = "HTTP"
        requestPath        = "/"
        port               = each.value.port
      }
    }
  }

  depends_on = [module.gke, kubernetes_secret_v1.iap_oauth_secret]
}

resource "kubernetes_service_v1" "user" {
  for_each = local.users

  metadata {
    name      = "${local.app_name}-${each.key}"
    namespace = "default"
    annotations = {
      "cloud.google.com/backend-config" = jsonencode({ default = "iap-backend-config-${each.key}" })
      "cloud.google.com/neg"            = jsonencode({ ingress = true })
    }
  }

  spec {
    selector = {
      app  = local.app_name
      user = each.key
    }

    port {
      port        = 80
      target_port = each.value.port
    }

    type = "ClusterIP"
  }

  depends_on = [module.gke, kubernetes_manifest.backend_config]
}

resource "kubernetes_ingress_v1" "app" {
  metadata {
    name      = "${local.app_name}-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.lb_ip.name
      "kubernetes.io/ingress.allow-http"            = "false"
      "ingress.gcp.kubernetes.io/pre-shared-cert"   = google_compute_managed_ssl_certificate.app.name
    }
  }

  spec {
    dynamic "rule" {
      for_each = local.users
      content {
        host = rule.value.domain
        http {
          path {
            path      = "/"
            path_type = "Prefix"
            backend {
              service {
                name = "${local.app_name}-${rule.key}"
                port {
                  number = 80
                }
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    module.gke,
    kubernetes_service_v1.user,
    kubernetes_manifest.backend_config,
    google_compute_managed_ssl_certificate.app,
  ]
}

output "load_balancer_ip" {
  description = "Global HTTPS load balancer IP"
  value       = google_compute_global_address.lb_ip.address
}

output "user_access_urls" {
  description = "Per-user HTTPS URLs"
  value = {
    for key, user in local.users :
    key => "https://${user.domain}/"
  }
}
