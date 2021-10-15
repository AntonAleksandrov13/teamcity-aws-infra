#!/bin/bash
env=${1:-test}
work_on=${2:-all}

echo "Creating symlinks in environment: ${env}"
if [ "$work_on" == "global" ] || [ "$work_on" == "all" ] ; then
    echo "Creating global symlinks..."
    cd ./environment/$env/global && rm ./global_infra.tf || true && ln -s ../../../components/global_infra.tf ./global_infra.tf
    cd ../../../
fi


for f in ./environment/$env/*; do
    if [ "$f" != "./environment/$env/global" ]  && ( [ "$work_on" == "all" ]  ||  [ "$f" == "./environment/$env/$work_on" ] ); then
        echo "Creating $f symlinks..."
        cd $f && rm ./tenant_infra.tf || true && ln -s ../../../components/tenant_infra.tf ./tenant_infra.tf
        cd ../../../
    fi
done

