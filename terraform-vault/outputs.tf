output "policy_names" {
  description = "All Vault policy names managed by this module."
  value = [
    vault_policy.platform.name,
    vault_policy.listings_ingest.name,
    vault_policy.mia.name,
    vault_policy.oracle.name,
    vault_policy.panchito.name,
    vault_policy.rigoberta.name,
  ]
}

output "external_secrets_role" {
  description = "Name of the Kubernetes auth role used by ESO."
  value       = vault_kubernetes_auth_backend_role.external_secrets.role_name
}
