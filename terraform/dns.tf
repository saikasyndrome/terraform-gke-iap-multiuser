resource "google_dns_record_set" "user" {
  for_each = local.users

  name         = "${each.value.domain}."
  type         = "A"
  ttl          = 300
  managed_zone = var.dns_managed_zone
  rrdatas      = [google_compute_global_address.lb_ip.address]
}

resource "google_compute_managed_ssl_certificate" "app" {
  name = "demo-webapp-cert"

  managed {
    domains = [for _, user in local.users : user.domain]
  }
}
