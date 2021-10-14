#!/bin/sh
env=$1

echo "Creating symlinks in environment: ${env}"
echo "Creating global symlinks..."
cd ./environment/$env/global && rm ./global_infra.tf || true && ln -s ../../../components/global_infra.tf ./global_infra.tf
echo "Creating tenants symlinks..."
for f in ../../../environment/$env/*; do
    if [ "$f" != "../../../environment/$env/global" ]; then
        echo "Creating $f symlinks..."
        cd $f && rm ./tenant_infra.tf || true && ln -s ../../../components/tenant_infra.tf ./tenant_infra.tf
    fi
done

