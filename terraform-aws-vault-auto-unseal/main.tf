locals {
  common_tags = merge(
    {
      managed-by = "terraform"
      purpose    = "vault-auto-unseal"
      repository = "kubernetes-platform-infrastructure"
    },
    var.tags
  )
}

data "aws_iam_policy_document" "vault_auto_unseal" {
  statement {
    sid    = "AllowVaultSealOperations"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
    ]

    resources = [aws_kms_key.vault_auto_unseal.arn]
  }
}

resource "aws_kms_key" "vault_auto_unseal" {
  description             = "Vault auto-unseal key for the on-prem cluster"
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  enable_key_rotation     = var.kms_key_enable_key_rotation
  tags                    = local.common_tags
}

resource "aws_kms_alias" "vault_auto_unseal" {
  name          = "alias/${var.name_prefix}-auto-unseal"
  target_key_id = aws_kms_key.vault_auto_unseal.key_id
}

resource "aws_iam_user" "vault_auto_unseal" {
  name = "${var.name_prefix}-auto-unseal"
  tags = local.common_tags
}

resource "aws_iam_user_policy" "vault_auto_unseal" {
  name   = "${var.name_prefix}-auto-unseal"
  user   = aws_iam_user.vault_auto_unseal.name
  policy = data.aws_iam_policy_document.vault_auto_unseal.json
}

resource "aws_iam_access_key" "vault_auto_unseal" {
  user = aws_iam_user.vault_auto_unseal.name
}
