# Architecture

```text
Internet
   ↓
HTTPS Load Balancer (global static IP)
   ↓  Google-managed SSL certificate
IAP (Identity-Aware Proxy)
   ↓  allowed Google accounts only
Ingress (GCE, host-based)
   ├── app.user1.example.com → Service demo-webapp-user1 → Pod (user=user1)
   └── app.user2.example.com → Service demo-webapp-user2 → Pod (user=user2)
```

- GKE nodes are private (no external IP)
- Egress via Cloud NAT only
- Pods are not reachable directly from the internet

## Responsibility split

| Concern | Tool |
|---|---|
| VPC, NAT, GKE, DNS, SSL, IAP IAM, Ingress/Service/BackendConfig | Terraform |
| Per-user Deployment, PVC, app env | Helm |

## User isolation

1. **Host + IAP**: each user hostname maps to a Service with its own BackendConfig (IAP enabled).
2. **Selectors**: Service selects Pods with `app=demo-webapp` and `user=<key>`.
3. **PVC**: each Helm release gets its own claim.
