#!/usr/bin/env sh
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <roleName>" >&2
    exit 1
fi

aws_account_id=$(aws sts get-caller-identity | jq -r '.Account')
role_name=$1
aws_credentials=$(aws sts assume-role --role-arn arn:aws:iam::$aws_account_id:role/$1 --role-session-name "$1_assumed_session")
sts_status=$?

echo $sts_status

if test $sts_status -eq 0
then
    export AWS_ACCESS_KEY_ID=$(echo $aws_credentials|jq '.Credentials.AccessKeyId'|tr -d '"')
    export AWS_SECRET_ACCESS_KEY=$(echo $aws_credentials|jq '.Credentials.SecretAccessKey'|tr -d '"')
    export AWS_SESSION_TOKEN=$(echo $aws_credentials|jq '.Credentials.SessionToken'|tr -d '"')
fi