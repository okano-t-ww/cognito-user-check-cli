#!/bin/bash

# 引数の数を確認
if [ "$#" -ne 3 ]; then
  echo "Usage: ccu <userpool-id> --email <user-email>"
  exit 1
fi

# 引数を取得
user_pool_id="$1"
user_email="$2 $3"

# 引数としてUser Pool IDとメールアドレスが指定されているか確認
if [ -z "$user_pool_id" ] || [[ "$user_email" != --email* ]]; then
  echo "Both User Pool ID and User Email are required."
  exit 1
fi

# メールアドレスを抽出
user_email="${user_email#--email }"

# AWS CLIでCognitoユーザーを検索してユーザー情報を取得
user_info=$(aws cognito-idp list-users \
  --user-pool-id "$user_pool_id" \
  --filter "email = \"$user_email\"" \
  --query "Users[0]" \
  --output json)

# ユーザーが見つからなかった場合のエラーメッセージ
if [ -z "$user_info" ]; then
  echo "User with email $user_email not found in User Pool $user_pool_id."
else
  # 必要な情報を取得
  username=$(echo "$user_info" | jq -r '.Username')
  email=$(echo "$user_info" | jq -r '.Attributes[] | select(.Name == "email") | .Value')
  email_verified=$(echo "$user_info" | jq -r '.Attributes[] | select(.Name == "email_verified") | .Value')
  status=$(echo "$user_info" | jq -r '.UserStatus')
  enabled=$(echo "$user_info" | jq -r '.Enabled')

  # 結果を表示
  echo "User Information for $user_email in User Pool $user_pool_id:"
  echo "-----------------------------------------------"
  echo "ユーザー名　　:     $username"
  echo "メールアドレス:     $email"
  echo "メール確認済み:     $email_verified"
  echo "確認ステータス:     $status"
  echo "ステータス　　:     $enabled"
fi
