# Keycloak Realm and Client Bootstrap

This Terraform stack bootstraps Keycloak-managed identity objects for the
ZaveStudios platform.

Current scope:

- realm `zavestudios`
- confidential OIDC client `panchito`

The stack is intended to run through the local containerized Terraform wrapper
in this directory so operator machines do not need Terraform installed.

## Inputs

Create a local `terraform.tfvars` from the tracked example:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Then populate:

- `keycloak_url`
- `keycloak_realm`
- `keycloak_client_id`
- `keycloak_client_secret`

`terraform.tfvars` is gitignored and must remain local-only because it contains
the Terraform admin client secret.

## Run

**Run manually by human:**

```bash
docker compose run --rm terraform init
docker compose run --rm terraform plan -out=tfplan
docker compose run --rm terraform apply tfplan
docker compose run --rm terraform output
```
