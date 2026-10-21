locals {
  service_accounts = {
    "gke-node-sa" = {
      display_name = "GKE node SA"
      roles = [
        "roles/logging.logWriter",
        "roles/monitoring.metricWriter",
        "roles/artifactregistry.reader",
      ]
    }
  }
}

resource "google_service_account" "this" {
  for_each = local.service_accounts

  project      = var.project_id
  account_id   = each.key
  display_name = each.value.display_name
}

resource "google_project_iam_member" "sa_roles" {
  for_each = {
    for binding in flatten([
      for sa_key, sa in local.service_accounts : [
        for role in sa.roles : {
          key  = "${sa_key}-${role}"
          sa   = sa_key
          role = role
        }
      ]
    ]) : binding.key => binding
  }

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.this[each.value.sa].email}"
}
