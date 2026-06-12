#!/usr/bin/env bash

location="southafricanorth"

create_rg() {
    read -rp "Enter resource group name: " rg
    echo "Creating resource group, standby"

    if [ -z "${rg}" ]; then
        echo "resource group name is empty"
        exit 1
    fi

    if
    az group create \
    -n "${rg}" \
    -l "${location}" \
    --tags env=prod owner=tes \
    --output table;
    then
        echo "${rg} created successfully"
    else
        echo "rg creation failed"
    fi

}

create_storage() {
    # echo "Name of resource group: ${rg}"
    read -rp "Enter globally unique name for Storage Account: " store
    echo "Creating storage account, standby"

    if
    az storage account create \
    -n "${store}" \
    -g "${rg}" \
    -l "${location}" \
    --sku "Standard_LRS" \
    --output table;
    then
        echo "Storage account created successfully."
    else
        echo "Storage account creation failed"
    fi
}

create_network() {
    # echo "Name of resource group: ${rg}"
    read -rp "Enter name of Virtual Network" vnet

    if [[ -z "${vnet}" ]]; then
    echo "Vnet name is empty. Exiting..."
    exit 1
    fi

    if
    az network vnet create \
        -n "${vnet} \
        -g "${rg} \
        --address-prefix 10.0.0.0/16 \
        --subnet-name default \
        --subnet-prefix 10.0.0.0/24 \
        --output table;
    then
        echo "Virtual network creation successful"
    else
        echo "Virtual network creation fail"
    fi



}

if create_rg; then
    create_storage
    create_network
fi
