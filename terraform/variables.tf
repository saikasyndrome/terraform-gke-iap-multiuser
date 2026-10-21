variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  type    = string
  default = "asia-northeast1"
}

variable "zone" {
  type    = string
  default = "asia-northeast1-a"
}

variable "dns_managed_zone" {
  description = "Cloud DNS managed zone short name (must already exist)"
  type        = string
}

variable "iap_oauth_client_id" {
  description = "IAP OAuth client ID (create in GCP Console)"
  type        = string
  sensitive   = true
}

variable "iap_oauth_client_secret" {
  description = "IAP OAuth client secret"
  type        = string
  sensitive   = true
}

variable "master_authorized_cidrs" {
  description = "CIDRs allowed to reach the GKE control plane"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = [
    {
      cidr_block   = "0.0.0.0/0"
      display_name = "CHANGE_ME_restrict_this"
    }
  ]
}
