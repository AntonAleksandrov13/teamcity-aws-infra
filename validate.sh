#!/bin/sh
env=$1

echo "Running terraform validate in environment: ${env}"
echo "Working on global..."
cd ./environment/$env/global && terraform validate -no-color
