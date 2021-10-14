#!/bin/sh
env=$1

echo "Running terraform apply in environment: ${env}"
echo "Working on global..."
cd ./environment/$env/global && terraform apply out.json
for f in ../../../environment/$env/*; do
    if [ "$f" != "../../../environment/$env/global" ]; then
        echo "Working on $f"
        cd $f && terraform apply out.json
    fi
done