Author

Created by Clinton K.
Project created for learning Terraform and Azure Infrastructure


# Terraform Azure Baby — Azure Infrastructure with Terraform

This project is a hands-on Infrastructure as Code (IaC) lab built to practice deploying Azure infrastructure using **Terraform** and the **azurerm provider**.

The goal of this project is to understand how Terraform manages real Azure resources including networking, security, and compute design.

---

## What This Project Deploys

Using Terraform, the following Azure resources are created:

### Network & Security
- Resource Group  
- Virtual Network (VNet)  
- Subnet  
- Network Security Group (NSG)  
- Inbound security rules:
  - SSH (port 22)
  - HTTP (port 80)
- Public IP Address (Standard SKU)  
- Network Interface (NIC)  
- NIC ↔ NSG Association  

### Compute (Defined, Optional)
- Linux Virtual Machine with:
  - SSH public key authentication  
  - cloud-init configuration to install and start NGINX automatically  

> Note: The virtual machine resource is currently **commented out** due to VM SKU and region restrictions on the subscription used for this project. The VM configuration is complete and can be enabled on less restricted Azure subscriptions.

---

## Project Structure
terraform-azure-baby/
│
├── providers.tf        # AzureRM provider configuration
├── main.tf             # Resource definitions (network + VM design)
├── variables.tf        # Input variables for customization
├── outputs.tf          # Output values (public IP, etc)
├── terraform.tfvars    # (excluded) Holds secrets like SSH public key
├── .gitignore          # Prevents secrets and state from being committed
└── README.md           # Project documentation


---

## Requirements

- Terraform installed (v1.x recommended)
- Azure CLI installed
- Azure account (Free or Pay-As-You-Go)
- SSH key pair

---


## Deployment Instructions(BASH)

1. Log into Azure
az login
az account set --subscription "<your-subscription-id>"

2. Clone the Repository
git clone https://github.com/your-username/terraform-azure-baby.git
cd terraform-azure-baby

3. Generate SSH Key (If you do not already have one)
ssh-keygen -t rsa -b 4096 -C "terraform-azure-vm"
cat ~/.ssh/id_rsa.pub

4. Create terraform.tfvars (Required)
ssh_public_key = "ssh-rsa AAAA....your-key-here"

5. Initialize Terraform
terraform init

6. Validate and Plan
terraform fmt
terraform validate
terraform plan

7. Apply Infrastructure
terraform apply
Confirm with: yes(text)

8. Destroy All Resources (Cleanup)
terraform destroy


______________________________________________________________________________________________________________

What I Learned

Through this personal project, I gained more experience with:
	•	Terraform provider configuration
	•	Managing Azure resources as code
	•	Working with variables and tfvars
	•	Dependency linking between network components
	•	Debugging provider issues and Azure region restrictions
	•	Public IP and NIC dependency handling
	•	State management and safe resets
	•	Understanding Azure quotas and SKU availability constraints



______________________________________________________________________________________________________________

Real-World Lessons

This project involved working through real Azure challenges including:
	•	Region capacity limits
	•	Public IP SKU restrictions
	•	Provider initialization issues
	•	State conflicts and resets
	•	VM SKU availability problems

These issues closely resemble real-world cloud engineering scenarios and provided practical troubleshooting experience.








   
