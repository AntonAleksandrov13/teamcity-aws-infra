#!/bin/sh
env=$1

echo "Running terraform apply in environment: ${env}"
echo "Working on global..."
cd ./environment/$env/global && terraform destroy -auto-approve
