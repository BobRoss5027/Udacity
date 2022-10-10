# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
This program comes in two parts; a packer template and a terraform template. 
- The packer template creates an image of an Ubuntu 18.04 Ubuntu server inthe resource group 'packerImage-rg'
- The terraform template creates an amount of virtual machines according to the amount specified in the variables file, and uses the image created by the packer template 

### Getting Started
In your chosen OS, run these commands;

Windows Powershell;
```
$ $Env:ARM_CLIENT_ID = "<APPID_VALUE>"
$ $Env:ARM_CLIENT_SECRET = "<PASSWORD_VALUE>"
$ $Env:ARM_SUBSCRIPTION_ID = "<SUBSCRIPTION_ID>"
$ $Env:ARM_TENANT_ID = "<TENANT_VALUE>"
```

macOS/Linux Terminal;
```
$ export ARM_CLIENT_ID="<APPID_VALUE>"
$ export ARM_CLIENT_SECRET="<PASSWORD_VALUE>"
$ export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
```

This version of the `variables.tf` file does not contain any default values, but if for deployment those are required, the adjustments can be made in the `variables.tf` file

- To do this, in `variables.tf`, under the description flag, create a new line formatted as follows; `default="Default value for the variable` 

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
1. Clone this repo onto your chosen machine
2. In the Azure portal, create a resource group named `packerImage-rg`
3. Open a CLI from the portal, then upload the server.json file to azure
4. Run `packer build server.json`
5. On your machine, run `terraform plan -out solution.plan`
6. If the plan succeeds, run `terraform apply "solution.plan"`
7. Once the deployment is complete, if the resources are no longer needed, run `terraform destroy`

### Output
**Your words here**
