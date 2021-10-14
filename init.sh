#!/bin/sh
env=$1

echo "Running terraform init in environment: ${env}"
echo "Working on global..."
cd ./environment/$env/global && yes | rm -r ./.terraform* || true && terraform init -backend-config=../../../backends/$env.tfvars
echo "Working on tenants..."
for f in ../../../environment/$env/*; do
    if [ "$f" != "../../../environment/$env/global" ]; then
        echo "Working on $f"
        cd $f && terraform init -backend-config=../../../backends/$env.tfvars
    fi
done