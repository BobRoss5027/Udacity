provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main_rg" {
  name     = "${var.prefix}-resources"
  location = var.location
}

resource "azurerm_virtual_network" "main_vn" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/22"]
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
}

resource "azurerm_subnet" "main_sub" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.main_vn.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "main_nsg" {
  name                = "BasicCommunicationControl"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  security_rule {
    name                       = "Intranet"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "VirtualNetwork"
    source_port_range = "*"
    destination_port_range = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Internet"
    priority                   = 401
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_address_prefix      = "Internet"
    source_port_range = "*"
    destination_port_range = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "main_pubip" {
  name = "external"
  resource_group_name = azurerm_resource_group.main_rg.name
  location = azurerm_resource_group.main_rg.location
  allocation_method = "Static"
}
resource "azurerm_lb" "main_lb" {
  name                = "LoadBalancer"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.main_pubip.id
  }
}

resource "azurerm_lb_backend_address_pool" "main_pool" {
  loadbalancer_id = azurerm_lb.main_lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_network_interface" "main_nic" {
  count="${var.amount}"
  name                = "${var.prefix}${count.index}-nic"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main_sub.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "main_disk" {
  count="${var.amount}"
  name                 = "${var.prefix}${count.index}-disk"
  location             = azurerm_resource_group.main_rg.location
  resource_group_name  = azurerm_resource_group.main_rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "32"
}

resource "azurerm_availability_set" "main_aset" {
  name                = "main-aset"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  platform_fault_domain_count = 2
}

data "azurerm_image" "customimage"{
  name = var.image_name
  resource_group_name = var.image_resource_name
}

resource "azurerm_linux_virtual_machine" "main_vm" {
  count                           = "${var.amount}"
  name                            = "${var.prefix}${count.index}-vm"
  resource_group_name             = azurerm_resource_group.main_rg.name
  location                        = azurerm_resource_group.main_rg.location
  size                            = "Standard_D2s_v3"
  admin_username                  = "${var.username}"
  admin_password                  = "${var.password}"
  availability_set_id             = azurerm_availability_set.main_aset.id
  disable_password_authentication = false
  network_interface_ids = [element(
    azurerm_network_interface.main_nic.*.id,count.index
  )]

  source_image_reference {
    id = data.azurerm_image.customimage.id
    #publisher = "Canonical"
    #offer     = "UbuntuServer"
    #sku       = "18.04-LTS"
    #version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "main_dda" {
  count              = "${var.amount}"
  managed_disk_id    = [element(azurerm_managed_disk.main_disk.*.id,count.index)]
  virtual_machine_id = [element(azurerm_linux_virtual_machine.main_vm.*.id,count.index)]
  lun                = "10"
  caching            = "ReadWrite"
}
