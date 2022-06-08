#!/bin/bash

APPNAME=flask-app-thoanvtt
RG=vothoan2014_rg_0674
SP=vothoan2014_asp_8572

#you can see a list of runtimes using 
#az webapp list-runtimes --linux
RUNTIME=PYTHON:3.7

# Create a resource group if you need it.
az group create --location eastus --name $RG

# Create an App Service plan in FREE tier if you need it.
echo "Going to Create Azure Webapp using free tier: " $azWebappName
az webapp up --name $APPNAME --resource-group $APPNAME --sku FREE

echo "Azure Web App Created Successfully"


echo "Setting DEPLOY URL"
# Configure local Git and get deployment URL
DEPLOY_URL=https://$APPNAME.scm.azurewebsites.net/$APPNAME.git


#to clean this up you can drop the resource group with
#az group delete $RG

#or just delete the webapp
#az webapp delete $APPNAME

# Use curl to see the web app.
site=https://$APPNAME.azurewebsites.net
echo $site
curl "$site" # Optionally, copy and paste the output of the previous command into a browser to see the web app