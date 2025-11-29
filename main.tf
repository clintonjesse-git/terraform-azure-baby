


locals {
  cloud_init = <<-EOF
    #cloud-config
    package_update: true
    packages:
      - nginx
    runcmd:
      - systemctl enable nginx
      - systemctl start nginx
  EOF
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-baby"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-terraform-baby"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-web"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-terraform-baby"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "allow-ssh"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "allow_http" {
  name                        = "allow-http"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_public_ip" "public_ip" {
  name                = "pip-terraform-baby"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

}

resource "azurerm_network_interface" "nic" {
  name                = "nic-terraform-baby"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# resource "azurerm_linux_virtual_machine" "vm" {
#  name                = "vm-terraform-baby"
#  resource_group_name = azurerm_resource_group.rg.name
#  location            = azurerm_resource_group.rg.location
#  size                = "Standard_D2s_v3"
#  admin_username      = var.admin_username
#
#  network_interface_ids = [
#    azurerm_network_interface.nic.id
#  ]
#
#  admin_ssh_key {
#    username   = var.admin_username
#    public_key = var.ssh_public_key
#  }
#
#  os_disk {
#    name                 = "disk-terraform-baby"
#    caching              = "ReadWrite"
#    storage_account_type = "Standard_LRS"
#  }
#
#  source_image_reference {
#    publisher = "Canonical"
#    offer     = "0001-com-ubuntu-server-focal"
#    sku       = "20_04-lts-gen2"
#    version   = "latest"
#  }
#
#  computer_name = "terraformbabyvm"
#
#  custom_data = base64encode(local.cloud_init)
# }
