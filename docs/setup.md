# Setup notes

1. Create a GCP project, enable billing, and create a Cloud DNS managed zone for your domain.
2. Create an OAuth client for IAP (GCP Console → APIs & Services → Credentials).
3. Fill `terraform/terraform.tfvars` from the example (never commit real secrets).
4. Edit `terraform/users.tf` with placeholder emails/domains for each user.
5. `terraform apply` the platform (cluster + Ingress wiring).
6. Get credentials: `gcloud container clusters get-credentials demo-gke --region <region> --project <project>`.
7. For each user, copy `charts/demo-webapp/values-user.example.yaml` → `values-<user>.yaml`, align `podLabels.user` with `users.tf`, then `helm upgrade --install`.
8. Wait for managed SSL to become ACTIVE, then open `https://<user-domain>/`.
