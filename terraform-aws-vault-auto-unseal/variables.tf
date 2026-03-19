variable "aws_region" {
  description = "AWS region for Vault auto-unseal resources."
  type        = string
}

variable "name_prefix" {
  description = "Prefix used for Vault auto-unseal resource names."
  type        = string
  default     = "zavestudios-onprem-vault"
}

variable "kms_key_deletion_window_in_days" {
  description = "KMS key deletion window."
  type        = number
  default     = 30
}

variable "kms_key_enable_key_rotation" {
  description = "Whether to enable KMS key rotation."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags applied to created AWS resources."
  type        = map(string)
  default     = {}
}
