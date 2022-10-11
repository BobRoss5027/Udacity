variable "prefix" {
  default = "azuredevops"
  description = "The prefix which should be used for all resources in this example"
}

variable "location" {
  default = "uksouth"
  description = "The Azure Region in which all resources in this example should be created."
}

variable "username" {
  default = "adminAccount"
  description = "The username for the virtual machine"
}

variable "password" {
  default = "P@ssw0rd123"
  description = "The password for the virtual machine"
}

variable "amount" {
  default = "3"
  description = "The amount of virtual machines to create"
}

variable "image_name"{
  default = "packerImage"
  description = "The name of the image created by packer"
}

variable "image_resource_name"{
  default = "packerImage-rg"
  description = "The resource group containing the packer image"
}