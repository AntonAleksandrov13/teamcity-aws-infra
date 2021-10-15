#!/bin/bash
env=${1:-test}
work_on=${2:-all}

echo "Running terraform apply in environment: ${env}"
if [ "$work_on" == "global" ] || [ "$work_on" == "all" ] ; then
    echo "Working on global..."
    cd ./environment/$env/global
    terraform apply out.json
    cd ../../../
fi


for f in ./environment/$env/*; do
    if [ "$f" != "./environment/$env/global" ]  && ( [ "$work_on" == "all" ]  ||  [ "$f" == "./environment/$env/$work_on" ] ); then
        echo "Working on $f"
        cd $f
        terraform apply out.json
        cd ../../../
    fi
done