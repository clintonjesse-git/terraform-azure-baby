variable "admin_username" {
  type        = string
  description = "Admin username for the Linux VM"
  default     = "azureuser"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for the VM"
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
  default     = "eastus2"
}
