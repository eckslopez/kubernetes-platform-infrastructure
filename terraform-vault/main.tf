# ---------------------------------------------------------------------------
# Platform policy
# Covers shared platform secrets consumed by ESO across all namespaces.
# ---------------------------------------------------------------------------
resource "vault_policy" "platform" {
  name = "platform"

  policy = <<-EOT
    path "secret/data/platform/*" {
      capabilities = ["read"]
    }
    path "secret/metadata/platform/*" {
      capabilities = ["read"]
    }
  EOT
}

# ---------------------------------------------------------------------------
# Tenant policies
# One policy per tenant; grants read access to that tenant's KV subtree only.
# Add a new block when onboarding a new tenant.
# ---------------------------------------------------------------------------
resource "vault_policy" "listings_ingest" {
  name = "listings-ingest"

  policy = <<-EOT
    path "secret/data/tenants/listings-ingest/*" {
      capabilities = ["read"]
    }
    path "secret/metadata/tenants/listings-ingest/*" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_policy" "mia" {
  name = "mia"

  policy = <<-EOT
    path "secret/data/tenants/mia/*" {
      capabilities = ["read"]
    }
    path "secret/metadata/tenants/mia/*" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_policy" "oracle" {
  name = "oracle"

  policy = <<-EOT
    path "secret/data/tenants/oracle/*" {
      capabilities = ["read"]
    }
    path "secret/metadata/tenants/oracle/*" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_policy" "panchito" {
  name = "panchito"

  policy = <<-EOT
    path "secret/data/tenants/panchito/*" {
      capabilities = ["read"]
    }
    path "secret/metadata/tenants/panchito/*" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_policy" "rigoberta" {
  name = "rigoberta"

  policy = <<-EOT
    path "secret/data/tenants/rigoberta/*" {
      capabilities = ["read"]
    }
    path "secret/metadata/tenants/rigoberta/*" {
      capabilities = ["read"]
    }
  EOT
}

# ---------------------------------------------------------------------------
# Kubernetes auth role: external-secrets
# Bound to the vault-reader service account used by the ClusterSecretStore.
# All tenant and platform policies are attached here so ESO can read any
# managed secret path from a single auth identity.
# ---------------------------------------------------------------------------
resource "vault_kubernetes_auth_backend_role" "external_secrets" {
  backend                          = var.kubernetes_auth_mount
  role_name                        = "external-secrets"
  bound_service_account_names      = [var.vault_reader_service_account]
  bound_service_account_namespaces = [var.vault_reader_namespace]
  token_ttl                        = 3600
  token_policies = [
    vault_policy.platform.name,
    vault_policy.listings_ingest.name,
    vault_policy.mia.name,
    vault_policy.oracle.name,
    vault_policy.panchito.name,
    vault_policy.rigoberta.name,
  ]
}
