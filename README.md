# AWS Cognito ユーザー情報取得スクリプトの手順書

## 前提条件

このスクリプトでは、AWS CLI を使用して Amazon Cognito のユーザー情報を取得・表示します。

ccu は check cognito user の略です。

## AWS CLI 設定

### インストール

以下を参考にして AWS CLI をインストールしてください。

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

### インストールの確認

インストールが完了したら、次のコマンドで AWS CLI が正しくインストールされたことを確認します。

```bash
aws --version
```

### AWS CLI の認証設定

```bash
aws configure
```

次の情報を入力してください：

1. **AWS Access Key ID**: AWS アクセスキー ID (Cognito の READ 権限を持つ IAM User)
2. **AWS Secret Access Key**: AWS シークレットアクセスキー (Cognito の READ 権限を持つ IAM User)
3. **Default region name**: ap-northeast-1
4. **Default output format**: json

## スクリプトの実行

スクリプトを実行するための手順は以下の通りです。

### スクリプトの保存

`ccu.sh`を任意の場所にコピー

### スクリプトに実行権限を付与

ターミナルを開き、スクリプトを保存したディレクトリに移動

例：ホームディレクトリに保存した場合

```bash
cd ~
```

スクリプトに実行権限を付与

```bash
chmod +x ccu.sh
```

### スクリプトの実行

以下のコマンドを実行して、ユーザー情報を取得します。
`<userpool-id>`には Cognito のユーザープール ID を、`<user-email>`にはユーザーのメールアドレスを指定します。

```bash
./ccu.sh <userpool-id> --email <user-email>
```

### 結果の確認

スクリプトを実行すると、指定したメールアドレスに関連付けられたユーザーの情報が表示されます。

```
ユーザー名　　:     user
メールアドレス:     user@example.com
メール確認済み:     false
確認ステータス:     CONFIRMED
ステータス　　:     true
```
