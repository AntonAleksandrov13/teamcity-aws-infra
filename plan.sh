#!/bin/sh
env=$1

echo "Running terraform plan in environment: ${env}"
echo "Working on global..."
cd ./environment/$env/global && terraform plan -out=out.json -no-color
for f in ../../../environment/$env/*; do
    if [ "$f" != "../../../environment/$env/global" ]; then
        echo "Working on $f"
        cd $f && terraform plan -out=out.json -no-color
    fi
done