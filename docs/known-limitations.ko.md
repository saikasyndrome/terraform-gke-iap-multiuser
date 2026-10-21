# 남은 문제점 / 한계

이 샘플을 실무에 가깝게 가져갈 때 남는 갭입니다.

| 항목 | 데모 | 실무 방향 |
|---|---|---|
| Master authorized networks | 부트스트랩용으로 넓을 수 있음 | 관리자/CI CIDR로 제한 |
| IAP IAM 범위 | 프로젝트 단위 `iap.httpsResourceAccessor` | 더 좁은 바인딩 + 앱에서 인증 헤더 검증 |
| Helm 수명주기 | 수동 `helm upgrade` | 필요 시 Terraform `helm_release` |
| Probe | 차트는 지원, 앱별 튜닝 필요 | 느린 앱은 Startup + Liveness + Readiness |
| PDB / 다중 replica | 단일 replica 전제 | Spot/노드 업그레이드 전 HPA + PDB |
| 노드 풀 | 단일 풀 | 시스템/워크로드 분리, Spot 검토 |
| 운영자 IAM | 데모용 넓은 역할 | apply용 최소 권한 세트 |
| 기본 이미지 | `nginx` placeholder | 실제 앱 이미지 + health path |
