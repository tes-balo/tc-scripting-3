#!/usr/bin/env bash

name_start="uni"
name_end="rg"

school_departments=("admissions" "finance" "library" "e-learning")

environments=("dev" "staging" "prod")

# research altenrative to nested loop l

for dept in "${school_departments[@]}"
do
    for env in "${environments[@]}"
    do
        echo -e "Creating multiple resource groups, standby"
        az group create \
        -n "${name_start}-${dept}-${env}-${name_end}" \
        -l "southafricanorth" \
        --tags env="${env}" owner=Balogun \
        --output table


    done
done

echo "All resource groups successfully created"
echo "Run 'z group list' to see all resource groups"
