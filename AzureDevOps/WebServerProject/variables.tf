variable "prefix" {
  default = "test"
  description = "The prefix which should be used for all resources in this example"
}

variable "location" {
  default = "uksouth"
  description = "The Azure Region in which all resources in this example should be created."
}

variable "username" {
  default = "testAccount"
  description = "The username for the virtual machine"
}

variable "password" {
  default = "P@ssw0rd"
  description = "The password for the virtual machine"
}

variable "amount" {
  default = "2"
  description = "The amount of virtual machines to create"
}
