# AWS — RHEL 9 Simple

The smallest possible cloud provision demo: one task that launches a tagged RHEL 9 EC2 instance. Networking, keypair, and security group are assumed to already exist — run [Deploy Cloud Stack in AWS](./deploy-cloud-stack.md) first, or provision those resources separately.

## Prerequisites

- AWS credential configured
- VPC, subnet (`aws-test-subnet`), security group (`aws-test-sg`), and keypair (`aws-test-key`) already created in the target region
- [Deploy Cloud Stack in AWS](./deploy-cloud-stack.md) satisfies all of the above

## Survey prompts

| Prompt | Variable | Type | Required |
|--------|----------|------|----------|
| AWS Region | `create_vm_aws_region` | multiplechoice | Yes |
| Owner | `create_vm_aws_owner_tag` | text | Yes |
| Environment | `vm_environment` | multiplechoice | Yes |

## Job templates

| Template | Playbook | Description |
|----------|----------|-------------|
| Cloud ǀ AWS ǀ RHEL 9 Simple | [`cloud/rhel9_simple.yml`](../rhel9_simple.yml) | One-task RHEL 9 provision with full APD tagging |

## Why it matters

Most real-world automation builds on shared infrastructure. Once VPC, subnets, and security groups are in place, provisioning a VM is a single role invocation — not a hundred-line playbook. This demo shows that simplicity: play-level vars name the subnet, keypair, tags, and blueprint; one `include_role` does the rest (AMI lookup, idempotent create, inventory tags).

Compare with [AWS — Create VM](./cloud-create-vm.md), which supports every blueprint and survey option, or [Deploy Cloud Stack in AWS](./deploy-cloud-stack.md), which provisions the full five-VM stack.
