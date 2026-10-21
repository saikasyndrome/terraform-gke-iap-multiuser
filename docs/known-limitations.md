# Known limitations

Documented gaps for production hardening (not fully implemented in this sample).

| Topic | Demo | Production direction |
|---|---|---|
| Master authorized networks | Often wide for bootstrap | Restrict to admin / CI CIDRs |
| IAP IAM scope | Project-level `iap.httpsResourceAccessor` | Prefer tighter binding + app checks on `X-Goog-Authenticated-User-Email` |
| Helm lifecycle | Manual `helm upgrade` | Optional `helm_release` in Terraform |
| Probes | Chart supports probes; tune per app | Startup + liveness + readiness for slow agents |
| PDB / multi-replica | Single replica friendly | HPA + PDB before Spot / node upgrades |
| Node pools | One pool | Split system vs workload; consider Spot |
| IAM for operators | Broad roles common in demos | Least-privilege role set for apply |
| Default image | `nginx` placeholder | Your real application image + health path |

See also Korean / Japanese: [known-limitations.ko.md](known-limitations.ko.md), [known-limitations.ja.md](known-limitations.ja.md).
