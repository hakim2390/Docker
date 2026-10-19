resource "azurerm_resource_group" "vm_rg" {
  name     = "NodeJs-Terraform-VM-RG-India"
  location = "South India" 
}

# 1. Create the Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "demo-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name
}

# 2. Create the Subnet inside the VNet
resource "azurerm_subnet" "subnet" {
  name                 = "demo-subnet"
  resource_group_name  = azurerm_resource_group.vm_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# 3. Create a Network Interface Card (NIC)
resource "azurerm_network_interface" "nic" {
  name                = "demo-nic"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# 4. Generate a Secure Random Password
resource "random_password" "admin_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*-_=+"
}

# 5. Create the Ubuntu Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "demo-linux-vm"
  resource_group_name             = azurerm_resource_group.vm_rg.name
  location                        = azurerm_resource_group.vm_rg.location
  size                            = "Standard_B1ms" 
  admin_username                  = "adminuser"
  admin_password                  = random_password.admin_password.result
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
