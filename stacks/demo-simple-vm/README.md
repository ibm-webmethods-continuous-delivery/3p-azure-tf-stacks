# Azure Windows 11 Demo VM - Terraform Stack

This Terraform stack creates a Windows 11 Desktop virtual machine in Azure with support for nested virtualization, suitable for running WSL2 and Rancher Desktop.

Before running the stack, ensure you have the necessary Windows 11 license from Microsoft.

## Stack ID

`demo-simple-vm`

## Features

- **Windows 11 Pro** (25H2) Desktop Edition
- **Nested Virtualization Support** for WSL2 and Rancher Desktop
- **4 vCPUs and 16 GB RAM** (Standard_D4s_v3 by default)
- **Premium SSD** storage for optimal performance
- **Public IP Address** for remote access
- **RDP Access** restricted to specified IP addresses
- **Network Security Group** with explicit allow rules

## Prerequisites

1. **Terraform** installed (version >= 1.0)
   ```sh
   terraform version
   ```

2. **Existing Azure Resource Group** - The resource group must already exist in Azure

4. **Service Principal with Contributor Role** - The service principal running Terraform must have Contributor role assigned within the target resource group

5. **Your Public IP Address** - Find it using:
   ```sh
   curl ifconfig.me
   ```

## Quick Start

### 1. Create Resource Group (if not exists)

Ensure the resource group exists in Azure:

```sh
az group create --name rg-demo-simple-vm --location "East US"
```

**Note**: The service principal running Terraform must have Contributor role in this resource group.

### 2. Configure Variables

Copy the example variables file and customize it:

```sh
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and specify the existing resource group name and add your IP addresses to the `allowed_rdp_ips` list:

```hcl
resource_group_name = "rg-demo-simple-vm"  # Must match existing resource group

allowed_rdp_ips = [
  "203.0.113.45/32",  # Your IP
  "198.51.100.23/32", # Peer IP 1
]
```

### 2. Consider Working with Workspaces

If you need two or more VMs, consider working with workspaces.

```sh
terraform workspace -help
```

### 2. Lint and Validate

Format and validate the Terraform configuration:

```sh
# In the directory having .tf files
tflint
```

### 3. Plan Changes

Review what will be created:

```sh
terraform validate
terraform plan -var-file=./terraform.tfvars
```

### 4. Apply Configuration

Create the infrastructure:

```sh
terraform apply -var-file=./terraform.tfvars -auto-approve
```

### 5. Get Connection Details

Retrieve the admin password:

```sh
terraform output -raw admin_password
```

Get the RDP connection string:

```sh
terraform output -raw rdp_connection_string
```

Or view all outputs:

```sh
terraform output
```

### 6. Connect via RDP

**On Windows:**
```powershell
mstsc /v:<public_ip_address>
```

**On Linux/Mac:**
```sh
rdesktop <public_ip_address>
# or
xfreerdp /v:<public_ip_address> /u:azureadmin
```

## VM Specifications

| Property | Value |
|----------|-------|
| OS | Windows 11 Pro (25H2) |
| VM Size | Standard_D4s_v3 |
| vCPUs | 4 |
| RAM | 16 GB |
| OS Disk | 128 GB Premium SSD |
| Nested Virtualization | Enabled |

### Alternative VM Sizes

If you need different specifications, you can change the `vm_size` variable to:

- `Standard_D4s_v4` - 4 vCPUs, 16 GB RAM (newer generation)
- `Standard_D4s_v5` - 4 vCPUs, 16 GB RAM (latest generation)
- `Standard_E4s_v3` - 4 vCPUs, 32 GB RAM (memory optimized)
- `Standard_D8s_v3` - 8 vCPUs, 32 GB RAM (more cores)

All these sizes support nested virtualization.

## Terraform State

The Terraform state is stored locally in the same folder as the terraform artifacts.

In case you are using workspaces, the Terraform state is stored locally in:

./terraform.tfstate.d/${workspace_name}/terraform.tfstate

## Security Considerations

1. **RDP Access**: Only IP addresses listed in `allowed_rdp_ips` can connect via RDP
2. **Admin Password**: Randomly generated and stored in Terraform state (sensitive)
3. **Network Security Group**: Denies all inbound traffic except RDP from allowed IPs
4. **Public IP**: Static allocation for consistent access

### Adding More IP Addresses

To add more IP addresses after deployment:

1. Edit `terraform.tfvars` and add the new IP to `allowed_rdp_ips`
2. Run `bash check.sh` to preview changes
3. Run `bash apply.sh` to update the NSG rules

## Post-Deployment Setup

After connecting to the VM:

### 1. Enable WSL2

```powershell
# Run as Administrator
wsl --install
```

### 2. Install Rancher Desktop

Download from: https://rancherdesktop.io/

### 3. Configure Nested Virtualization

Nested virtualization is already enabled on the VM. No additional configuration needed.

## Costs

Estimated monthly costs (East US region):

- VM (Standard_D4s_v3): ~$140/month
- Premium SSD (128 GB): ~$20/month
- Public IP: ~$3/month
- **Total**: ~$163/month

**Note**: Costs vary by region and usage. Stop the VM when not in use to reduce costs.

## Troubleshooting

### Cannot Connect via RDP

1. Verify your IP is in the `allowed_rdp_ips` list
2. Check the NSG rules: `az network nsg rule list --resource-group <rg-name> --nsg-name <nsg-name>`
3. Verify the VM is running: `az vm get-instance-view --resource-group <rg-name> --name <vm-name>`

### Forgot Admin Password

Retrieve it from Terraform outputs:

```sh
terraform output -raw admin_password
```

### VM Performance Issues

Consider upgrading to a larger VM size in `terraform.tfvars`:

```hcl
vm_size = "Standard_D8s_v3"  # 8 vCPUs, 32 GB RAM
```

Then run `bash check.sh` and `bash apply.sh`.

## Cleanup

To destroy all resources:

```sh
bash destroy.sh
```

**Warning**: This permanently deletes the VM and all associated resources.

## Support

For issues or questions:

1. Check the Terraform documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
2. Review Azure VM documentation: https://docs.microsoft.com/azure/virtual-machines/
3. Check nested virtualization requirements: https://docs.microsoft.com/azure/virtual-machines/nested-virtualization

## License

This Terraform stack is provided as-is for demonstration purposes.
