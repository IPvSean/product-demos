# Terraform — Provision RHEL VM (Enterprise)


Customer-facing Terraform demo: push the same RHEL EC2 HCL to **Terraform Enterprise** or **HCP Terraform**, apply remotely, and sync AWS inventory. Uses `hashicorp.terraform` collection modules against a configured workspace.

## Prerequisites

- **Terraform Enterprise Credential** with hostname, organization, workspace, and API token
- TFE/HCP workspace with **remote** backend matching the credential org/workspace names
- Workspace environment variables: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` (sensitive)
- **APD Machine Credential** SSH key (or survey `tf_public_key`) for the EC2 key pair
- Run **APD ǀ Single demo setup** with `cloud`

Deploy a TFE server first with [Infrastructure | Terraform Enterprise | Deploy on AWS](../../infrastructure/docs/terraform-enterprise-deploy-aws.md), or use HCP Terraform at [app.terraform.io](https://app.terraform.io).

## Configure credentials

1. **Terraform Enterprise Credential** — set `hostname` (e.g. `https://<tfe-ip>`), `org`, `workspace`, and `token`
2. In the TFE/HCP workspace, add AWS credentials as **environment variables** (not Terraform variables)
3. **APD Machine Credential** — SSH private key for EC2 access after provision

## Survey prompts

| Prompt | Variable | Type | Default | Description |
|--------|----------|------|---------|-------------|
| AWS Region | `tf_aws_region` | multiplechoice | `us-east-2` | Passed to Terraform as `aws_region` |
| EC2 Name tag prefix | `tf_name_tag` | text | `tf_rhel9` | Base `Name` tag |
| Instance count | `tf_instance_count` | multiplechoice | `1` | Max 2 |
| Instance type | `tf_instance_type` | text | `t3.micro` | EC2 instance type |
| Owner tag | `tf_owner` | text | `apd-demo` | EC2 `owner` tag |
| Blueprint tag | `tf_blueprint` | text | `rhel9` | Inventory `blueprint_*` group |
| SSH public key | `tf_public_key` | textarea | (empty) | Optional |

## Workflow

```mermaid
graph LR
  S["🏠 Start"]
  S --> A
  A["☁️ TFE Apply"] --> B["🔄 Sync Inventory"]
  style S fill:#212427,stroke:#8a8d90,color:#fff
  style A fill:#5c4d9e,stroke:#a78bfa,color:#fff
  style B fill:#162c46,stroke:#58a6ff,color:#fff
```

1. Uploads configuration to the workspace via `hashicorp.terraform.configuration_version`
2. Creates and auto-applies a run via `hashicorp.terraform.run`
3. Syncs **AWS Inventory** for APD discovery

## Job templates

| Template | Playbook | Description |
|----------|----------|-------------|
| Terraform — Provision RHEL VM (Enterprise) | [`cloud/setup.yml`](../setup.yml) | Workflow: TFE apply + inventory sync |
| Cloud ǀ Terraform ǀ AWS ǀ Provision VM (Enterprise) | [`cloud/terraform/provision_enterprise.yml`](../terraform/provision_enterprise.yml) | Standalone TFE push and apply |

## Why it matters

Shows the recommended enterprise pattern: Ansible Automation Platform orchestrates Terraform Enterprise for governed, remote infrastructure provisioning with inventory handoff to day-two Ansible jobs.
