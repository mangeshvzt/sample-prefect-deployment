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

# if [ -n "$PREFECT_API_BEARER" ] && [ -n "$PREFECT_API_URL" ]; then
#     echo "Using IAP-protected Prefect API at $PREFECT_API_URL"
#     export PREFECT_API_URL
#     export PREFECT_API_BEARER
# fi

# echo "Deploying Prefect flow..."
# prefect deploy --all --prefect-file prefect_hello.yaml --api-url $PREFECT_API_URL

# IAP-protected Prefect API
if [ -n "$PREFECT_API_BEARER" ] && [ -n "$PREFECT_API_URL" ]; then
    echo "Using IAP-protected Prefect API at $PREFECT_API_URL"
    export PREFECT_API_URL
    export PREFECT_API_BEARER
else
    echo "Warning: No IAP token found. Using default Prefect API URL."
fi

# # Build deployment YAML
# prefect deployment build flows/hello.py:hello_flow \
#     -n "hello-world-deployment" \
#     -t "$ENV_TAG" \
#     -q "default" \
#     -o deployments/hello_deployment.yaml

# # Apply deployment
# prefect deployment apply deployments/hello_deployment.yaml

# echo "Prefect deployment completed for environment: $ENV_TAG"

# --- Detect Prefect version ---
PREFECT_VERSION=$(prefect version 2>/dev/null || echo "3")
echo "Detected Prefect version: $PREFECT_VERSION"

# --- Deployment logic ---
if [[ "$PREFECT_VERSION" == 2* ]]; then
    echo "Using Prefect 2.x CLI deployment..."
    prefect deploy --all --prefect-file flows/hello_world.py
elif [[ "$PREFECT_VERSION" == 3* ]]; then
    echo "Using Prefect 3.x CLI deployment..."
    # Prefect 3.x can apply deployment directly from Python file
    prefect deployment apply flows/hello_world.py
else
    echo "Unknown Prefect version: $PREFECT_VERSION"
    exit 1
fi

echo "Prefect deployment applied successfully for environment: $ENV_TAG"