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

# # Deploy flow
# prefect deployment create flows/hello_world.py:hello_world \
#     --name hello-world-deployment \
#     --apply

# echo "Prefect deployment completed for environment: $ENV_TAG"

prefect deployment build hello_world.py:hello_flow \
    -n hello-world \
    -i $IMAGE_TAG \
    -q default \
    -o hello_world_deployment.yaml

prefect deployment apply hello_world_deployment.yaml