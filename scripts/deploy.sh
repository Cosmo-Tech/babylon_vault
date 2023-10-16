#!/bin/bash

cd vault
terraform init
terraform plan -out tfplan
terraform apply tfplan
