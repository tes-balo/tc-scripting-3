#!/usr/bin/env bash
set -euo pipefail

#ame_start="uni"
location="southafricanorth"
# # network-end="vnet"/
# # storage-end="store"

# random_suffix=$(openssl rand -hex 2)

school_departments=("admissions" "finance" "library" "e-learning")

environments=("dev" "staging" "prod")

# research altenrative to nested loop

##################################   RESOURCE GROUPS    #############################


for dept in "${school_departments[@]}"
do
    for env in "${environments[@]}"
    do
        echo -e "Creating multiple resource groups, standby"
        az group create \
        -n "uni-${dept}-${env}-rg" \
        -l "$location" \
        --tags env="${env}" owner=Balogun \
        --output table


    done
done

echo -e "\nAll resource groups successfully created "
echo -e "\nRun 'az group list' to see all resource groups "

echo
echo


##################################   NETWORKS    #############################

echo "Creating all 24 virtual networks, standby ..."

all_rgs=()

mapfile -t all_rgs < <( az group list --query "[?starts_with(name,'uni-')].name" -o tsv )

for rg in "${all_rgs[@]}"
do
    az network vnet create \
    -n "${rg%-rg}-vnet" \
    -l "$location" \
    -g "${rg}" \
    --address-prefix 10.0.0.0/16 \
    --subnet-name "${rg%-rg}-subnet" \
    --subnet-prefix 10.0.0.0/24 \
    --output table
done

echo
echo

echo -e "\nAll network groups created successfully,\n run \`az network vnet list\` to list all networks"

echo
echo

##################################   STORAGES    #############################

# echo "Creating all 24 virtual networks, standby ..."

for rg in "${all_rgs[@]}"
do
    store_name=$(echo "${rg%-rg}-store" | tr -d '-' | cut -c1-24)
    az storage account create \
    -n "${store_name}" \
    -l "$location" \
    -g "${rg}" \
    --sku Standard_LRS \
    --output table
done

echo
echo

echo "All storage accounts created successfully"
