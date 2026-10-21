resource "google_project_service" "iap" {
  project            = var.project_id
  service            = "iap.googleapis.com"
  disable_on_destroy = false
}

# Project-scoped IAP accessor (simple demo pattern).
# Stricter setups should bind per backend service and verify identity headers in-app.
resource "google_iap_web_iam_member" "user" {
  for_each = {
    for m in local.user_iap_members :
    "${m.user_key}--${m.email}" => m
  }

  project = var.project_id
  role    = "roles/iap.httpsResourceAccessor"
  member  = "user:${each.value.email}"

  depends_on = [google_project_service.iap]
}
