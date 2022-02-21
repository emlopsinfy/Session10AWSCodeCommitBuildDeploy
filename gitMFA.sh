#!/bin/bash

# Parameter 1 is the name of the profile that calls the
# session token service.
# It must contain IAM keys and mfa_serial configuration

# The STS response contains an expiration date/ time.
# This is checked to only set the keys if they are expired.

EXPIRATION=$(aws configure get expiration)

RELOAD="true"
if [ -n "$EXPIRATION" ];
then
        # get current time and expiry time in seconds since 1-1-1970
        NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

        # if tokens are set and have not expired yet
        if [[ "$EXPIRATION" > "$NOW" ]];
        then
                echo "Will not fetch new credentials. They expire at (UTC) $EXPIRATION"
                RELOAD="false"
        fi
fi

if [ "$RELOAD" = "true" ];
then
        echo "Need to fetch new STS credentials"
        MFA_SERIAL=$(aws configure get mfa_serial --profile "$1")
        DURATION=$(aws configure get get_session_token_duration_seconds --profile "$1")
        read -p "Token for MFA Device ($MFA_SERIAL): " TOKEN_CODE
        read -r AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN EXPIRATION AWS_ACCESS_KEY_ID < <(aws sts get-session-token \
                --profile "$1" \
                --output text \
                --query '[Credentials.SecretAccessKey, Credentials.SessionToken, Credentials.Expiration, Credentials.AccessKeyId]' \
                --serial-number $MFA_SERIAL \
                --duration-seconds $DURATION \
                --token-code $TOKEN_CODE)

        aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
        aws configure set aws_session_token "$AWS_SESSION_TOKEN"
        aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" 
        aws configure set expiration "$EXPIRATION"
fi
