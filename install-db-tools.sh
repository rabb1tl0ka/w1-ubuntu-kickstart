#!/bin/bash

echo ">> Install gcloud pre-req"
sudo apt-get install apt-transport-https ca-certificates gnupg curl

echo ">> Get Google Cloud public key"
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

echo ">> Add the gcloud CLI distribution URI as a package source"
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

echo "!! if you get errors here or after, check if there is no multiple entries on /etc/apt/sources.list.d/google-cloud-sdk.list"

echo ">> update and install gcloud CLI"
sudo apt-get update && sudo apt-get install google-cloud-cli
