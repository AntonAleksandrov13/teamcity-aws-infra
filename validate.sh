#!/bin/sh
env=$1

echo "Running terraform validate in environment: ${env}"
echo "Working on global..."
cd ./environment/$env/global && terraform validate -no-color
echo "Working on tenants..."
for f in ../../../environment/$env/*; do
    if [ "$f" != "../../../environment/$env/global" ]; then
        echo "Working on $f"
        cd $f && terraform validate -no-color
    fi
done