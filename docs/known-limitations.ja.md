# 残課題 / 制約

このサンプルを実務に近づけるときのギャップです。

| 項目 | デモ | 実務の方向 |
|---|---|---|
| Master authorized networks | ブートストラップ向けに広い場合あり | 管理者/CI の CIDR に制限 |
| IAP IAM 範囲 | プロジェクト単位の `iap.httpsResourceAccessor` | より狭いバインド + アプリで認証ヘッダ検証 |
| Helm ライフサイクル | 手動 `helm upgrade` | 必要なら Terraform `helm_release` |
| Probe | チャートは対応、アプリごとに調整 | 起動が遅いアプリは Startup + Liveness + Readiness |
| PDB / 複数 replica | 単一 replica 前提 | Spot/ノードアップグレード前に HPA + PDB |
| ノードプール | 単一プール | システム/ワークロード分離、Spot 検討 |
| 運用者 IAM | デモ向けの広いロール | apply 用の最小権限セット |
| デフォルトイメージ | `nginx` placeholder | 実アプリイメージ + health path |
