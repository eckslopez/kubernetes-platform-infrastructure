variable "vault_address" {
  description = "Vault server address."
  type        = string
}

variable "vault_token" {
  description = "Vault root or operator token with policy and auth management capabilities."
  type        = string
  sensitive   = true
}

variable "kubernetes_host" {
  description = "Kubernetes API server address for the external-secrets auth role."
  type        = string
}

variable "kubernetes_auth_mount" {
  description = "Mount path for the Kubernetes auth backend."
  type        = string
  default     = "kubernetes"
}

variable "vault_reader_service_account" {
  description = "Service account used by ESO to authenticate with Vault."
  type        = string
  default     = "vault-reader"
}

variable "vault_reader_namespace" {
  description = "Namespace containing the ESO service account."
  type        = string
  default     = "platform"
}
