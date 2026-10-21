# terraform-gke-iap-multiuser

*他の言語: [English](../README.md), [한국어](README.ko.md)*

GKE 上でマルチユーザーアプリをホストするための **一から書き直した一般化ポートフォリオサンプル**です。

- **Terraform**: プライベート GKE、VPC/NAT、Cloud DNS、マネージド SSL、ユーザー別 IAP
- **Helm**: ユーザーごとに隔離したワークロード（ラベル、PVC、アプリ認証）

プロジェクト ID・ドメイン・メール・OAuth 値はすべて **placeholder** です。

## 何を示すか

| 層 | 手段 | 目的 |
|---|---|---|
| **ネットワークアクセス** | サブドメイン + ユーザー別 IAP BackendConfig | 許可された Google アカウントだけがそのホストへ |
| **アプログイン** | release ごとの env（`AUTH_LOGIN` / `AUTH_PASSWORD`） | Pod ごとに別の資格情報 |
| **データ** | ユーザー別 PVC | 永続データの混在を防止 |

```text
Internet → HTTPS LB + Managed SSL → IAP → Ingress(host)
  ├── app.user1.example.com → Pod(user=user1) + PVC
  └── app.user2.example.com → Pod(user=user2) + PVC
```

ノードはプライベート（外部 IP なし）、外向き通信は Cloud NAT のみ。

## 機能と目的

| 機能 | 目的 |
|---|---|
| **Terraform プラットフォーム** | VPC・GKE・DNS・SSL・IAP 関連 IAM をコードで再現 |
| **Helm ユーザー展開** | プラットフォームを変えず values + release でユーザー追加/削除 |
| **ホストベース Ingress** | LB 1つ、ユーザーホスト複数 |
| **ユーザー別 BackendConfig + IAP** | その Service バックエンドに IAP を付与 |
| **Private GKE + Cloud NAT** | 攻撃面を縮小しつつイメージ pull |
| **Managed SSL + Cloud DNS** | HTTPS・A レコードを自動化 |
| **ローリングアップデート保護** | アップグレード中の Pod ゼロを防止 |

チャートのデフォルトイメージは製品非依存の placeholder（`nginx`）です。AI エージェント/内部アプリに差し替え可能です。

**動作確認済みワークロード:** [Agent Zero](https://github.com/agent0ai/agent-zero)。ポート・health path・env・ボリュームマウントを合わせれば、他イメージにも同じパターンを適用できます。

## 構成 / クイックスタート

メインの [README](../README.md) と同じです。制約は [known-limitations.ja.md](known-limitations.ja.md)。

## Topics

`terraform` · `gke` · `kubernetes` · `helm` · `iap` · `multi-tenant` · `gcp`
