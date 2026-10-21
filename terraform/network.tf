locals {
  vpc_networks = {
    "main-vpc" = {
      network_name = "main-vpc"
      routing_mode = "REGIONAL"
      subnets = [
        {
          subnet_name           = "main-subnet"
          subnet_ip             = "10.0.0.0/24"
          subnet_region         = var.region
          subnet_private_access = true
        }
      ]
      secondary_ranges = {
        main-subnet = [
          {
            range_name    = "gke-pods"
            ip_cidr_range = "10.1.0.0/16"
          },
          {
            range_name    = "gke-services"
            ip_cidr_range = "10.2.0.0/20"
          }
        ]
      }
    }
  }
}

module "vpc" {
  for_each = local.vpc_networks

  source       = "terraform-google-modules/network/google"
  version      = "~> 11.0"
  project_id   = var.project_id
  network_name = each.value.network_name
  routing_mode = each.value.routing_mode
  subnets      = each.value.subnets
  secondary_ranges = each.value.secondary_ranges
}

resource "google_compute_router" "router" {
  name    = "main-router"
  project = var.project_id
  network = module.vpc["main-vpc"].network_name
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  name                               = "main-nat"
  project                            = var.project_id
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_global_address" "lb_ip" {
  name    = "demo-webapp-lb-ip"
  project = var.project_id
}
