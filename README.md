# AWS ECS Fargate Terraform CI/CD

このプロジェクトは、Terraform を使用して AWS 上に ECS Fargate 環境を構築し、Python (FastAPI) アプリケーションをデプロイするための CI/CD パイプラインを提供します。

## アーキテクチャ

プロジェクトのアーキテクチャ図は `images/architecture.drawio` にあります。

- **VPC**: プライベートサブネットとパブリックサブネットを含む仮想ネットワーク
- **ALB**: Application Load Balancer でトラフィックを分散
- **ECS Fargate**: サーバーレスコンテナ実行環境
- **ECR**: Elastic Container Registry でコンテナイメージを管理
- **RDS**: PostgreSQL データベース

## 前提条件

- AWS CLI がインストールされ、適切な権限を持つ IAM ユーザーで設定されていること
- Terraform v1.0 以上がインストールされていること
- Docker がインストールされていること
- Python 3.9 以上がインストールされていること (ローカルテスト用)

## セットアップ

1. リポジトリをクローンします：

   ```bash
   git clone <repository-url>
   cd aws-ecs-fargate-terraform-cicd
   ```

2. Terraform の変数を設定します：

   `terraform.tfvars` ファイルを編集して、以下の変数を設定してください：

   - `db_username`: RDS データベースのユーザー名
   - `db_password`: RDS データベースのパスワード

3. Terraform を初期化します：

   ```bash
   terraform init
   ```

4. インフラを構築します：

   ```bash
   terraform plan
   terraform apply
   ```

## アプリケーションのデプロイ

1. ECR リポジトリにイメージをプッシュします：

   ```bash
   # ECR にログイン
   aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.ap-northeast-1.amazonaws.com

   # イメージをビルド
   docker build -t ecs-app ./app

   # イメージにタグ付け
   docker tag ecs-app:latest <account-id>.dkr.ecr.ap-northeast-1.amazonaws.com/ecs-app:latest

   # ECR にプッシュ
   docker push <account-id>.dkr.ecr.ap-northeast-1.amazonaws.com/ecs-app:latest
   ```

2. ECS サービスを更新して新しいイメージを使用します。

## 使用方法

インフラが構築された後、ALB の DNS 名を使用してアプリケーションにアクセスできます。

- エンドポイント: `http://<alb-dns-name>/`
- レスポンス: `{"message": "Hello from ECS app container"}`

## ローカル開発

ローカルでアプリケーションをテストするには：

```bash
cd app
pip install fastapi uvicorn
uvicorn app:app --reload
```

ブラウザで `http://localhost:8000` にアクセスしてください。

## クリーンアップ

インフラを削除するには：

```bash
terraform destroy
```

## 注意事項

- このプロジェクトはデモ目的です。本番環境での使用にはセキュリティ設定の強化が必要です。
