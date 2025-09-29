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

# --- Set work pool ---


# --- Deploy Prefect flow ---
# FLOW_FILE="flows/hello.py"
# FLOW_FUNCTION="hello_flow"
# DEPLOYMENT_NAME="hello-world"
# POOL_NAME="gcp-kubernetes-worker-pool-30"

FLOW_FILE="flows/test_flow.py"
FLOW_FUNCTION="test_flow"
DEPLOYMENT_NAME="test-flow-latest"
POOL_NAME="gcp-kubernetes-worker-pool-30"

echo "🚀 Deploying flow '$FLOW_FUNCTION' from $FLOW_FILE into pool '$POOL_NAME'"

prefect deploy "$FLOW_FILE:$FLOW_FUNCTION" \
    --name "$DEPLOYMENT_NAME" \
    --pool "$POOL_NAME" \
    --tag "$ENV_TAG"

echo "✅ Deployment created (prefect.yaml saved)"

echo "🎉 Deployment ready!"
echo "Run your deployment with:"
echo "  prefect deployment run '$DEPLOYMENT_NAME/$DEPLOYMENT_NAME'"