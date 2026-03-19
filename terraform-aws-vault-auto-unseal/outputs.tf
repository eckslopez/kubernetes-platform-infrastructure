output "aws_region" {
  description = "AWS region used for Vault auto-unseal."
  value       = var.aws_region
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for Vault auto-unseal."
  value       = aws_kms_key.vault_auto_unseal.arn
}

output "kms_key_alias" {
  description = "Alias of the KMS key used for Vault auto-unseal."
  value       = aws_kms_alias.vault_auto_unseal.name
}

output "iam_user_name" {
  description = "IAM user created for Vault auto-unseal."
  value       = aws_iam_user.vault_auto_unseal.name
}

output "access_key_id" {
  description = "AWS access key ID for Vault auto-unseal."
  value       = aws_iam_access_key.vault_auto_unseal.id
}

output "secret_access_key" {
  description = "AWS secret access key for Vault auto-unseal."
  value       = aws_iam_access_key.vault_auto_unseal.secret
  sensitive   = true
}
