@echo off
setlocal enabledelayedexpansion

:: User Pool IDの入力
set /p "user_pool_id=User Pool ID: "

:: メールアドレスの入力
set /p "user_email=email: "

:: 一時ファイルのパスを指定
set "temp_file=%TEMP%\cognito_user_info.json"

:: AWS CLIでCognitoユーザー情報を一度に取得し、その結果を一時ファイルに保存
aws cognito-idp list-users --user-pool-id "%user_pool_id%" --filter "email = \"%user_email%\"" --query "Users[0]" --output json > "%temp_file%"

:: 取得したJSONから各情報を抽出
for /f "delims=" %%A in ('jq -r ".Username" "%temp_file%"') do set "cognito_username=%%A"
for /f "delims=" %%A in ('jq -r ".Attributes[] | select(.Name == \"email\") | .Value" "%temp_file%"') do set "cognito_email=%%A"
for /f "delims=" %%A in ('jq -r ".Attributes[] | select(.Name == \"email_verified\") | .Value" "%temp_file%"') do set "cognito_email_verified=%%A"
for /f "delims=" %%A in ('jq -r ".UserStatus" "%temp_file%"') do set "cognito_status=%%A"
for /f "delims=" %%A in ('jq -r ".Enabled" "%temp_file%"') do set "cognito_enabled=%%A"

:: ユーザー情報を表示
echo.
echo User Information for %user_email% in User Pool %user_pool_id%:
echo -----------------------------------------------
if defined cognito_username (
    echo ユーザー名　　:     %cognito_username%
) else (
    echo ユーザー名の取得に失敗しました
)

if defined cognito_email (
    echo メールアドレス:     %cognito_email%
) else (
    echo メールアドレスの取得に失敗しました
)

if defined cognito_email_verified (
    echo メール確認済み:     %cognito_email_verified%
) else (
    echo メール確認済みの取得に失敗しました
)

if defined cognito_status (
    echo 確認ステータス:     %cognito_status%
) else (
    echo 確認ステータスの取得に失敗しました
)

if defined cognito_enabled (
    echo ステータス　　:     %cognito_enabled%
) else (
    echo ステータスの取得に失敗しました
)

:: 一時ファイルを削除
del "%temp_file%"

endlocal
pause
