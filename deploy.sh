#!/usr/bin/env bash

location="southafricanorth"

create_rg() {
    read -rp "Enter resource group name: " rg
    echo -e "Creating resource group, standby \n"

    if [ -z "${rg}" ]; then
        echo -e "resource group name is empty. \n"
        return 1
    fi

    if
    az group create \
    -n "${rg}" \
    -l "${location}" \
    --tags env=prod owner=tes \
    --output table;
    then
        echo -e "${rg} created successfully \n"
    else
        echo -e "rg creation failed \n"
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
        echo -e "Storage account created successfully. \n"
    else
        echo -e "Storage account creation failed \n"
    fi
}

create_network() {
    # echo "Name of resource group: ${rg}"
    read -rp "Enter name of Virtual Network: " vnet

    if [[ -z "${vnet}" ]]; then
    echo -e "Vnet name is empty. Exiting... \n"
    return 1
    fi

    if
    az network vnet create \
        -n "${vnet}" \
        -g "${rg}" \
        --address-prefix 10.0.0.0/16 \
        --subnet-name default \
        --subnet-prefix 10.0.0.0/24 \
        --output table;
    then
        echo "Virtual network creation successful \n"
    else
        echo "Virtual network creation fail \n"
    fi



}

if create_rg; then
    create_storage
    create_network

    echo -e "\n All resources have been successfully created "
fi
