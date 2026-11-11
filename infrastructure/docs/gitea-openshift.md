# OpenShift Gitea

Stand up the same self-hosted Git forge as **Infrastructure ǀ AWS - Provision Gitea**, on the lab OpenShift cluster instead of an EC2 host. Use this when the lab has OpenShift and no AWS account.

Both jobs create `apdadmin` / `Ansible123!`, seed `apdadmin/inventory-service`, and upsert the Controller credential named **Gitea**. AO Install and the CI/CD API jobs follow whichever job succeeded last.

[Gitea operator](https://github.com/rhpds/gitea-operator) (`pfe.rhpds.com/v1`, kind `Gitea`) installs from the RHDP catalog `quay.io/rhpds/gitea-catalog:latest`.

## Prerequisites

- OpenShift cluster whose API token can install a cluster-wide operator (CatalogSource, Subscription, CRD) and create projects, routes, and a privileged ServiceAccount for the Actions runner
- A default StorageClass (Gitea and PostgreSQL each request 4Gi)
- Cluster pull access to `quay.io/rhpds/gitea-catalog`, `quay.io/rhpds/gitea`, `registry.redhat.io/rhel10/postgresql-16` (the operator's PostgreSQL image), and, when the runner and demo apps are left on, `quay.io/podman/stable`, `docker.io/gitea/act_runner`, `docker.io/library/node`, and `registry.access.redhat.com/ubi9/python-311`
- OpenShift Credential and AAP Credential configured in AAP
- The execution node must be able to reach the Gitea route on HTTPS

**Infrastructure ǀ AWS - Deploy Shared Services** still provisions the EC2 forge. This job is the standalone OpenShift path. It does not replace that workflow node.

## Configure credentials

| Credential | Type | Notes |
|------------|------|-------|
| OpenShift Credential | OpenShift or Kubernetes API Bearer Token | Cluster-admin level token so OLM can install the operator |
| AAP Credential | Red Hat Ansible Automation Platform | Controller API for the **Gitea** credential write-back |

## Survey prompts

| Prompt | Variable | Default |
|--------|----------|---------|
| Gitea namespace | `gitea_namespace` | `gitea` |
| Route hostname | `gitea_route_host` | *(blank — `<name>-<namespace>.<apps domain>`)* |
| Gitea image tag | `gitea_image_tag` | `latest` (`quay.io/rhpds/gitea`) |

## Job templates

| Template | Playbook | Description |
|----------|----------|-------------|
| Infrastructure ǀ OpenShift - Provision Gitea | [`infrastructure/gitea/provision_openshift.yml`](../gitea/provision_openshift.yml) | RHDP operator + Gitea route, admin, inventory-service seed, Actions runner, dev/prod Routes, **Gitea** credential |

## Why it matters

- Labs without AWS still get a Gitea AO can call
- Same admin, same `apdadmin/inventory-service` baseline (`aiohttp==3.9.0`, empty `PATCHED_CVE` / `CHANGE_REQUEST`, Actions workflow), same Controller credential fields as the AWS job
- The credential port is **443**. AO uses `https://` for that port and `http://` for the AWS host's port 3000
- Job output prints URL / username / password as the **last** task (`Show Gitea access information`)

## Presenter walkthrough

1. Launch **Infrastructure ǀ OpenShift - Provision Gitea**. Leave the route hostname blank unless the cluster needs a specific apps hostname
2. At the end of the job, copy the printed **URL / Username / Password** block. The URL is `https://` with no `:3000`
3. Open the URL and sign in — `apdadmin` / `Ansible123!`
4. Run **AO Install** with the **Gitea** credential attached. Install writes the Actions secrets **`AO_WEBHOOK_URL`**, **`AO_TOKEN_URL`**, **`AO_CLIENT_ID`**, and **`AO_CLIENT_SECRET`**
5. Dev and prod app URLs in that same block are OpenShift Routes. They are the baseline inventory-service pages. The CI/CD **deploy / drain / rollback / reset-demo** templates still SSH to host `aws_gitea`

Default admin login is `apdadmin` / `Ansible123!` (same as the AWS forge; username `admin` is reserved by Gitea).

## Talking points

- The operator installs once into namespace `gitea-operator` and is cluster-scoped. The instance project defaults to `gitea`
- Actions are turned on in an `app.ini` ConfigMap (`apd-gitea-config`) because the operator's generated config does not expose `[actions]`
- The Actions runner is a privileged Podman sidecar so job containers match the AWS runner (`ubuntu-latest` → `node:20-bookworm`). The project is labeled to allow that pod. Set extra var `gitea_deploy_runner=false` to publish the forge without it
- Dev (`inventory-service-dev`) and prod (`inventory-service-prod`) are edge Routes, not ports 8080 and 80 on an EC2 host. Set `gitea_deploy_demo_apps=false` to skip them
- There is one **Gitea** credential. Running this job after the AWS provision job points AO at OpenShift, and the reverse points AO back at EC2
- APD does **not** run upstream `cicd_setup_gitea` against this instance

## Extra variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `gitea_image` | `quay.io/rhpds/gitea` | Gitea image. Tag comes from the survey |
| `gitea_deploy_runner` | `true` | Privileged `act_runner` + Podman in the instance project |
| `gitea_deploy_demo_apps` | `true` | inventory-service dev and prod Routes |

## Related demos

| Demo | Description |
|------|-------------|
| [AWS Gitea](./gitea.md) | Same forge on EC2 + Podman |
| [AWS Deploy Shared Services](./shared-services.md) | One-click path that still provisions the EC2 forge |
| [OpenFlake](./openflake.md) | ITSM backend the CI/CD Pipeline demo also needs |
| [Automation Orchestrator](./automation-orchestrator.md) | AO Install attaches the **Gitea** credential |
