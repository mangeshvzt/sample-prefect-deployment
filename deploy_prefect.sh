#!/bin/bash

if [ -z "$1" ]; then
    echo "Provide environment tag"
    exit 1
fi

ENV_TAG="$1"

if [ "$DEPLOY_PREFECT" = "false" ]; then
    echo "Prefect deployment skipped"
    exit 0
fi

export PREFECT_CLI_PROMPT=false

if [ -n "$PREFECT_API_BEARER" ] && [ -n "$PREFECT_API_URL" ]; then
    echo "Using IAP-protected Prefect API at $PREFECT_API_URL"
    export PREFECT_API_URL
    export PREFECT_API_BEARER
fi

echo "Deploying Prefect flow..."
prefect deploy --all --prefect-file prefect_hello.yaml --api-url $PREFECT_API_URL
