# Infrastructure | Terraform Enterprise — Deploy on AWS


Deploy a **single-node Terraform Enterprise** server on AWS EC2 for demo and lab use. Uses RHEL 9, Podman, and disk operational mode — **bring your own license** (`terraform.hclic`).

This is not a production HA deployment. For production, see HashiCorp [Validated Designs](https://developer.hashicorp.com/validated-designs/terraform/installation-guide/deployment-vm-container) and the [terraform-enterprise-hvd/aws](https://registry.terraform.io/modules/hashicorp/terraform-enterprise-hvd/aws/latest) module.

## Prerequisites

- **AWS** credential with permissions to create EC2, security groups, and key pairs
- **APD Machine Credential** with SSH private key for `ec2-user`
- Valid **Terraform Enterprise license** file contents
- Recommended instance: `m5.xlarge` or larger, 120 GB root volume
- Run **APD ǀ Single demo setup** with `infrastructure`

## Configure credentials

Add AWS Access Key and Secret Key to the **AWS** credential. Ensure **APD Machine Credential** has an SSH private key matching the EC2 key pair.

## Survey prompts

| Prompt | Variable | Type | Default | Description |
|--------|----------|------|---------|-------------|
| AWS Region | `tfe_aws_region` | multiplechoice | `us-east-2` | Region for the TFE host |
| EC2 instance name | `tfe_instance_name` | text | `apd-tfe` | `Name` tag and key pair prefix |
| TFE hostname | `tfe_hostname` | text | `tfe.local` | License hostname (use public IP if unsure) |
| Owner tag | `tfe_owner` | text | `apd-demo` | EC2 owner tag |
| Terraform Enterprise license | `tfe_license` | textarea | (required) | Full `terraform.hclic` file contents |
| Encryption password | `tfe_encryption_password` | text | `tfeseed` | TFE disk encryption password |
| SSH public key | `tfe_ssh_public_key` | textarea | (empty) | Optional |

## Job templates

| Template | Playbook | Description |
|----------|----------|-------------|
| Infrastructure \| Terraform Enterprise \| Deploy on AWS | [`infrastructure/terraform-enterprise/deploy.yml`](../terraform-enterprise/deploy.yml) | EC2 + Podman TFE install |

## Post-deploy steps

1. Open `https://<public-ip>` (accept self-signed TLS if applicable)
2. Create an organization and workspace in the TFE UI
3. Add `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as workspace environment variables
4. Update **Terraform Enterprise Credential** in AAP with the TFE URL, org, workspace, and API token
5. Run [Terraform — Provision RHEL VM (Enterprise)](../../cloud/docs/cloud-terraform-provision-enterprise.md)

## Why it matters

Provides a self-hosted Terraform Enterprise endpoint on AWS for APD demos without requiring OpenShift Virtualization or the RHDP workshop environment.
