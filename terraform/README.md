# Terraform Infrastructure

This directory contains the Terraform configuration for deploying the Todo application infrastructure on Azure.

## Overview

The Terraform configuration creates the following Azure resources:

- Resource Group
- Virtual Network and Subnets (Frontend and Backend)
- Network Security Groups with rules for SSH (22), HTTP (80), and backend port (8000)
- Public IPs for both VMs
- Network Interfaces
- Linux Virtual Machines (Ubuntu) for Frontend and Backend

## Architecture

- **Frontend VM**: Runs Nginx to serve the React application
- **Backend VM**: Runs the FastAPI application with Python

## Prerequisites

- Azure CLI installed and authenticated
- Terraform v1.0+
- Azure subscription with appropriate permissions

## Configuration

### Variables

The configuration uses the following key variables (defined in `terraform.tfvars`):

- `subscription_id`: Azure subscription ID
- `subnet`: Subnet configurations for frontend and backend
- `security_groups`: NSG rules (SSH, HTTP, backend port)
- `public_ip`: Public IP configurations
- `network_interface`: NIC configurations
- `virtual_machine`: VM configurations

### Locals

Key local values:

- `environment`: Deployment environment (dev)
- `application`: Application name (todo)
- `region`: Azure region (Central India)
- VM specs: Standard_B2s, Ubuntu 22.04/20.04

## Deployment

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Validate configuration**:
   ```bash
   terraform validate
   ```

3. **Plan deployment**:
   ```bash
   terraform plan
   ```

4. **Apply configuration**:
   ```bash
   terraform apply
   ```

## Custom Scripts

The VMs are configured using custom data scripts:

- `nginx.sh`: Sets up Nginx on the frontend VM
- `python.sh`: Sets up Python environment on the backend VM

## Security

- NSGs allow only necessary ports
- VMs use password authentication (consider using SSH keys for production)
- Resources are tagged for organization

## Cleanup

To destroy the infrastructure:

```bash
terraform destroy
```

## Notes

- Update the `subscription_id` in `terraform.tfvars` with your Azure subscription
- The VMs use static public IPs for easy access
- Custom data scripts are base64 encoded and run on VM startup
- Consider using Azure Key Vault for secrets management in production