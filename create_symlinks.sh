#!/bin/sh
env=$1

echo "Creating symlinks in environment: ${env}"
echo "Creating global symlinks..."
cd ./environment/$env/global && rm ./global_infra.tf || true && ln -s ../../../components/global_infra.tf ./global_infra.tf
echo "Creating tenant symlinks..."
