#!/bin/bash
##### RG and VNet #################
#az account set --subscription <your subscription GUID>
az group create -l eastus -n new
az network vnet create -g new -n new-FirstVnet1 --address-prefix 10.6.0.0/16 
az network vnet subnet create --name new-Sub1 --vnet-name new-FirstVnet1 --resource-group new  --address-prefixes 10.6.1.0/24

##### NSG & Rule availability set#############
az network nsg create -g new -n new_NSG1
az network nsg rule create -g new --nsg-name new_NSG1 -n new_NSG1_Rule1 --priority 100 \
--source-address-prefixes '*' --source-port-ranges '*'     --destination-address-prefixes '*' \
--destination-port-ranges '*' --access Allow   --protocol Tcp --description "Allow from specific IP range" 
az vm availability-set	create --name EAST-AVSET1 -g new --location eastus

######### Create a VM ################

az vm create --resource-group new --name ShellPOCVM --image UbuntuLTS --vnet-name new-FirstVnet1 \
--subnet new-Sub1 --admin-username kiran --admin-password "Kiran1234!@#" --size Standard_B1s \
--availability-set EAST-AVSET1 --nsg new_NSG1


############ Deleting A RG #################

#az group delete -n <Name of RG> --yes