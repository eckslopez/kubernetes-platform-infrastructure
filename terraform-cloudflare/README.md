# Cloudflare Terraform Configuration

Manages Cloudflare resources for ZaveStudios on-prem infrastructure:
- Cloudflare Tunnel (locally-managed)
- DNS records (panchito-on-prem, vault)
- Tunnel configuration with Istio integration

## Prerequisites

- Cloudflare account with zavestudios.com zone
- Cloudflare API token with permissions:
  - Account: Cloudflare Tunnel (Read, Edit)
  - Zone: DNS (Read, Edit)
- Terraform >= 1.0

## Setup

1. Copy terraform.tfvars.example to terraform.tfvars
2. Fill in your Cloudflare credentials:
   - `cloudflare_api_token`: API token from Cloudflare dashboard
   - `cloudflare_account_id`: Found in Cloudflare dashboard URL
   - `cloudflare_zone_id`: Zone ID for zavestudios.com

3. Initialize Terraform:
   ```bash
   ../scripts/tf terraform-cloudflare init
   ```

4. Review the plan:
   ```bash
   ../scripts/tf terraform-cloudflare plan -out=tfplan
   ```

5. Apply the configuration:
   ```bash
   ../scripts/tf terraform-cloudflare apply tfplan
   ```

6. Extract tunnel credentials for Vault:
   ```bash
   ../scripts/tf terraform-cloudflare output -raw tunnel_credentials_json
   ```

## Outputs

- `tunnel_id`: Cloudflare Tunnel UUID (use in gitops deployment)
- `tunnel_name`: Tunnel name (zavestudios-on-prem)
- `tunnel_cname`: CNAME target for DNS records
- `tunnel_credentials_json`: Credentials JSON for Vault storage (sensitive)

## Post-Apply Steps

1. Store tunnel credentials in Vault:
   ```bash
   vault kv put platform/cloudflare credentials="$(terraform output -raw tunnel_credentials_json)"
   ```

2. Update gitops deployment with new tunnel ID:
   - Edit `gitops/platform/cloudflare/deployment.yaml`
   - Replace tunnel ID in args section

3. Verify tunnel connection:
   ```bash
   kubectl logs -n platform deployment/cloudflared
   ```

## Architecture

This creates a locally-managed Cloudflare Tunnel that:
- Routes all traffic to Istio public gateway
- Forwards X-Forwarded-Proto: https header (when provider supports it)
- Provides GitOps-managed ingress configuration
- Eliminates remote dashboard configuration drift

## Related

- Part of gitops#138 (Keycloak authentication for panchito)
- Contributes to kpi#39 (Import Cloudflare into Terraform)
