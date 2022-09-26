variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
}

variable "username" {
  description = "The username for the virtual machine"
}

variable "password" {
  description = "The password for the virtual machine"
}

variable "amount" {
  description = "The amount of virtual machines to create"
}
