#!/bin/sh
env=$1

echo "Running terraform init in environment: ${env}"
echo "Working on global..."
cd ./environment/$env/global && yes | rm -r ./.terraform* || true && terraform init -backend-config=../../../backends/$env.tfvars
