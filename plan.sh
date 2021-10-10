#!/bin/sh
env=$1

echo "Running terraform plan in environment: ${env}"
echo "Working on global..."
cd ./environment/$env/global && terraform plan -out=out.json -no-color -backend-config=../../../backends/$env.tfvars
