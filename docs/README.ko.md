# terraform-gke-iap-multiuser

*다른 언어: [English](../README.md), [日本語](README.ja.md)*

GKE에서 멀티유저 앱을 올리기 위한 **처음부터 새로 쓴 일반화 포트폴리오 샘플**입니다.

- **Terraform**: 프라이빗 GKE, VPC/NAT, Cloud DNS, 관리형 SSL, 사용자별 IAP 연동
- **Helm**: 사용자마다 격리된 워크로드 1세트 (라벨, PVC, 앱 인증)

프로젝트 ID·도메인·이메일·OAuth 값은 모두 **placeholder**입니다.

## 무엇을 보여주나

| 계층 | 수단 | 목적 |
|---|---|---|
| **네트워크 접근** | 서브도메인 + 사용자별 IAP BackendConfig | 허용된 Google 계정만 해당 호스트 접근 |
| **앱 로그인** | release별 env (`AUTH_LOGIN` / `AUTH_PASSWORD`) | Pod마다 다른 앱 자격 증명 |
| **데이터** | 사용자별 PVC | 영속 데이터 혼재 방지 |

```text
Internet → HTTPS LB + Managed SSL → IAP → Ingress(host)
  ├── app.user1.example.com → Pod(user=user1) + PVC
  └── app.user2.example.com → Pod(user=user2) + PVC
```

노드는 프라이빗(공인 IP 없음), 외부 통신은 Cloud NAT만.

## 기능과 목적

| 기능 | 목적 |
|---|---|
| **Terraform 플랫폼** | VPC·GKE·DNS·SSL·IAP 관련 IAM을 코드로 재현 |
| **Helm 사용자 배포** | 플랫폼 수정 없이 values + release로 사용자 추가/삭제 |
| **호스트 기반 Ingress** | LB 하나, 사용자 호스트 다수 |
| **사용자별 BackendConfig + IAP** | 해당 Service 백엔드에 IAP 부착 |
| **Private GKE + Cloud NAT** | 공격면 축소 + 이미지 pull 가능 |
| **Managed SSL + Cloud DNS** | HTTPS·A 레코드 자동화 |
| **롤링 업데이트 보호** | 업그레이드 중 Pod 0개 방지 |

차트 기본 이미지는 제품 비종속용 placeholder(`nginx`)입니다. AI 에이전트/내부 앱 이미지로 바꾸면 됩니다.

**검증한 워크로드:** [Agent Zero](https://github.com/agent0ai/agent-zero). 포트·health path·env·볼륨 마운트만 맞추면 다른 이미지에도 동일 패턴을 적용할 수 있습니다.

## 레이아웃 / 빠른 시작

메인 [README](../README.md) 와 동일합니다. 한계점은 [known-limitations.ko.md](known-limitations.ko.md).

## Topics

`terraform` · `gke` · `kubernetes` · `helm` · `iap` · `multi-tenant` · `gcp`
