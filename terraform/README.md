# Terraform Infrastructure

This directory contains the Terraform configuration for deploying the Todo application infrastructure on Azure.

## Overview

The Terraform configuration creates the following Azure resources:

- **Resource Group**: Central container for all resources
- **Virtual Network**: VNet with address space 192.168.100.0/24
- **Subnets**: 
  - Frontend subnet: 192.168.100.0/26
  - Backend subnet: 192.168.100.128/26
- **Network Security Groups**:
  - Frontend NSG: Allows SSH (22) and HTTP (80)
  - Backend NSG: Allows SSH (22) and application port (8000)
- **Public IPs**: One for frontend VM, one for backend VM
- **Network Interfaces**: NICs for both VMs
- **Linux Virtual Machines**: Ubuntu VMs for Frontend and Backend

## Architecture

- **Frontend VM**: Ubuntu-based VM running Nginx to serve the React application
- **Backend VM**: Ubuntu-based VM running Python environment for the application
- **VM Size**: Standard_B2s
- **Authentication**: Password-based authentication (SSH key recommended for production)

## Prerequisites

- Azure CLI installed and authenticated
- Terraform >= 1.5.0
- Terraform Azure Provider >= 4.0
- Azure subscription with appropriate permissions
- Remote state backend configured in Azure Storage Account (see backend.tf)

## File Structure

```
terraform/
├── main.tf              # Primary resource definitions (RG, VNet, Subnets, NSGs, IPs, NICs, VMs)
├── variable.tf          # Variable definitions for modular configuration
├── local.tf             # Local values for naming, IPs, VM specs, and common tags
├── provider.tf          # Azure provider configuration
├── backend.tf           # Azure Storage remote state backend configuration
├── terraform.tfvars     # Variable values for infrastructure setup
├── nginx.sh             # Custom data script for frontend VM
├── python.sh            # Custom data script for backend VM
└── README.md            # This file
```

## Configuration

### Local Variables (local.tf)

Key local values:

- **environment**: dev
- **application**: todo
- **owner**: devops-team
- **project**: devops-practice
- **region**: Central India
- **address_space**: 192.168.100.0/24
- **VM size**: Standard_B2s
- **Admin username**: adminuser
- **Allocation method**: Static (for public IPs)
- **Storage account type**: Standard_LRS
- **Image publisher**: Canonical

### Input Variables (variable.tf)

- **subscription_id**: Azure subscription ID (required)
- **subnet**: Subnet configurations with name and address prefixes
- **security_groups**: NSG definitions with rules for each subnet
- **subnet_nsg_association**: Maps subnets to their security groups
- **public_ip**: Public IP configurations
- **network_interface**: Network interface configurations with subnet and public IP mappings
- **virtual_machine**: VM configurations with NIC mappings

### terraform.tfvars Configuration

The `terraform.tfvars` file defines:
- Two subnets: `fe-subnet` (frontend) and `be-subnet` (backend)
- Two NSGs: `fe-nsg` (frontend) and `be-nsg` (backend)
- Two public IPs: `fe-pip` (frontend) and `be-pip` (backend)
- Two network interfaces: `fe-nic` (frontend) and `be-nic` (backend)
- Two VMs: `fe-vm` (frontend) and `be-vm` (backend)

## Deployment Steps

1. **Initialize Terraform** (downloads providers and initializes backend):
   ```bash
   terraform init
   ```

2. **Validate configuration** (checks syntax and configuration):
   ```bash
   terraform validate
   ```

3. **Review planned changes**:
   ```bash
   terraform plan
   ```

4. **Apply configuration** (creates resources in Azure):
   ```bash
   terraform apply
   ```

5. **Verify deployment**: Check Azure Portal for created resources

## Custom Scripts

The VMs are configured at startup using custom data scripts (base64 encoded in local.tf):

- **nginx.sh**: Installs and configures Nginx web server on the frontend VM
- **python.sh**: Sets up Python environment and dependencies on the backend VM

## Remote State Management

This configuration uses Azure Storage for remote state:
- **Resource Group**: bootstrapresource-rg
- **Storage Account**: bootstrapresourcestrg
- **Container**: bootstrapresource-tfstate
- **State File**: todo.app.terraform.tfstate

Remote state enables team collaboration and prevents state conflicts.

## Security Considerations

- **Network Security**: NSGs restrict inbound traffic to only necessary ports
- **Authentication**: Currently uses password authentication. For production, use SSH keys:
  - Set `disable_password_authentication = true` in local.tf
  - Use `admin_ssh_key` instead of `admin_password`
- **Secrets Management**: Consider using Azure Key Vault for sensitive data (passwords, keys)
- **Resource Tags**: All resources are tagged with common tags for organization and cost tracking

## Cleanup

To destroy all created infrastructure:

```bash
terraform destroy
```

This will remove all Azure resources but keep the remote state in the storage account.

## Important Notes

- **Update subscription_id**: Modify the default value in `variable.tf` or pass via `terraform.tfvars`
- **Static Public IPs**: VMs have static public IPs for consistent access
- **Custom Data Encoding**: Scripts are base64 encoded and execute on first VM boot
- **Admin credentials**: Update admin username and password in `local.tf` for production
- **Resource naming**: Uses `${local.name_prefix}` pattern (dev-todo-*) for consistent naming
- **Network isolation**: Frontend and backend subnets are logically separated for security
