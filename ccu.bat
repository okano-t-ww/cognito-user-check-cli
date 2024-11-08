@echo off
setlocal enabledelayedexpansion

:: User Pool ID�̓���
set /p "user_pool_id=User Pool ID: "

:: ���[���A�h���X�̓���
set /p "user_email=email: "

:: �ꎞ�t�@�C���̃p�X���w��
set "temp_file=%TEMP%\cognito_user_info.json"

:: AWS CLI��Cognito���[�U�[������x�Ɏ擾���A���̌��ʂ��ꎞ�t�@�C���ɕۑ�
aws cognito-idp list-users --user-pool-id "%user_pool_id%" --filter "email = \"%user_email%\"" --query "Users[0]" --output json > "%temp_file%"

:: �擾����JSON����e���𒊏o
for /f "delims=" %%A in ('jq -r ".Username" "%temp_file%"') do set "cognito_username=%%A"
for /f "delims=" %%A in ('jq -r ".Attributes[] | select(.Name == \"email\") | .Value" "%temp_file%"') do set "cognito_email=%%A"
for /f "delims=" %%A in ('jq -r ".Attributes[] | select(.Name == \"email_verified\") | .Value" "%temp_file%"') do set "cognito_email_verified=%%A"
for /f "delims=" %%A in ('jq -r ".UserStatus" "%temp_file%"') do set "cognito_status=%%A"
for /f "delims=" %%A in ('jq -r ".Enabled" "%temp_file%"') do set "cognito_enabled=%%A"

:: ���[�U�[����\��
echo.
echo User Information for %user_email% in User Pool %user_pool_id%:
echo -----------------------------------------------
if defined cognito_username (
    echo ���[�U�[���@�@:     %cognito_username%
) else (
    echo ���[�U�[���̎擾�Ɏ��s���܂���
)

if defined cognito_email (
    echo ���[���A�h���X:     %cognito_email%
) else (
    echo ���[���A�h���X�̎擾�Ɏ��s���܂���
)

if defined cognito_email_verified (
    echo ���[���m�F�ς�:     %cognito_email_verified%
) else (
    echo ���[���m�F�ς݂̎擾�Ɏ��s���܂���
)

if defined cognito_status (
    echo �m�F�X�e�[�^�X:     %cognito_status%
) else (
    echo �m�F�X�e�[�^�X�̎擾�Ɏ��s���܂���
)

if defined cognito_enabled (
    echo �X�e�[�^�X�@�@:     %cognito_enabled%
) else (
    echo �X�e�[�^�X�̎擾�Ɏ��s���܂���
)

:: �ꎞ�t�@�C�����폜
del "%temp_file%"

endlocal
pause
