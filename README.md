# terraform-gke-iap-multiuser

*Read this in other languages: [한국어](docs/README.ko.md), [日本語](docs/README.ja.md)*

A **freshly written, generalized portfolio sample** for multi-user app hosting on GKE.

**Terraform** provisions private GKE, VPC/NAT, Cloud DNS, managed SSL, and per-user IAP wiring.  
**Helm** deploys one isolated workload instance per user (labels, PVC, app credentials).

All project IDs, domains, emails, and OAuth values are **placeholders**.

## What this demonstrates

| Layer | How | Purpose |
|---|---|---|
| **Network access** | Subdomain + IAP BackendConfig per user | Only allowed Google accounts reach that user’s host |
| **App login** | Per-release env vars (`AUTH_LOGIN` / `AUTH_PASSWORD`) | Separate app credentials per Pod |
| **Data** | Per-user PVC | Workspaces do not share persistent data |

```text
Internet
   ↓
HTTPS LB (static IP) + Google-managed SSL
   ↓
IAP (Google account auth)
   ↓
Ingress (host-based routing)
   ├── app.user1.example.com  → Service/Pod (user=user1) + PVC
   └── app.user2.example.com  → Service/Pod (user=user2) + PVC
```

Private GKE nodes (no public IP) reach the internet only via Cloud NAT.

## Features and purpose

| Feature | Purpose |
|---|---|
| **Terraform for platform** | Reproduce VPC, GKE, DNS, SSL, IAP-related IAM as code |
| **Helm for per-user apps** | Add/remove users with a values file + release, without rewriting the platform |
| **Host-based Ingress** | One LB, many user hostnames |
| **Per-user BackendConfig + IAP** | Attach IAP at the backend that serves that user’s Service |
| **Private GKE + Cloud NAT** | Shrink the attack surface; still allow image pulls |
| **Managed SSL + Cloud DNS** | Automate HTTPS and A records for user hostnames |
| **Rolling update (`maxUnavailable: 0`)** | Avoid zero-Pod windows during chart upgrades |

The chart ships with a generic container image placeholder (`nginx`) so the sample stays product-agnostic. Swap `image.repository` for your AI agent / internal app.

**Verified with:** [Agent Zero](https://github.com/agent0ai/agent-zero) as the reference workload. Other images can be used the same way after adjusting port, health path, env vars, and volume mounts.

## Layout

```text
.
├── terraform/                 # Platform (GKE, network, DNS, IAP, Ingress wiring)
│   ├── users.tf               # User catalog (email, domain, port)
│   ├── network.tf
│   ├── gke.tf
│   ├── k8s-resources.tf       # BackendConfig / Service / Ingress
│   ├── dns.tf
│   ├── iap.tf
│   └── iam.tf
├── charts/demo-webapp/        # Per-user Helm chart
│   ├── values.yaml
│   ├── values-user.example.yaml
│   └── templates/
└── docs/
```

## Quick start

### 1. Platform (Terraform)

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# edit project_id, region, zone, dns_zone, users in users.tf
terraform init
terraform plan
terraform apply
```

OAuth client ID/secret for IAP must be created in GCP Console and passed via tfvars (sensitive).

### 2. Per-user app (Helm)

```bash
# after cluster credentials are configured
cp charts/demo-webapp/values-user.example.yaml charts/demo-webapp/values-user1.yaml
# set podLabels.user, pvc.name, env passwords, etc.

helm upgrade --install demo-user1 ./charts/demo-webapp \
  -f ./charts/demo-webapp/values-user1.yaml \
  -n default
```

`podLabels.user` must match the user key in `terraform/users.tf` so the Service selector hits the right Pods.

## Known limitations

See [docs/known-limitations.md](docs/known-limitations.md).

## Topics

`terraform` · `gke` · `kubernetes` · `helm` · `iap` · `multi-tenant` · `gcp`
