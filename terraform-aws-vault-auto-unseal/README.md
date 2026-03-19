# Vault Auto-Unseal AWS Bootstrap

This Terraform configuration creates the AWS trust-anchor resources for Vault auto-unseal in the current on-prem environment.

It is intentionally separate from `terraform-libvirt`:

- `terraform-libvirt` provisions the on-prem cluster substrate
- `terraform-aws-vault-auto-unseal` provisions the external AWS KMS and IAM resources that Vault will consume

Resources created:

- one AWS KMS key dedicated to Vault auto-unseal
- one KMS alias
- one tightly scoped IAM user
- one IAM access key for bootstrap credential delivery

Important:

- the generated IAM secret access key is stored in Terraform state
- do not commit `terraform.tfstate` or `terraform.tfvars`
- treat the resulting AWS credentials as bootstrap secrets that will later be delivered to Vault through GitOps-managed Kubernetes secret material

**Run manually by human**

```bash
cd terraform-aws-vault-auto-unseal
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan -out=tfplan
terraform apply tfplan
terraform output
```

Outputs to carry into the next GitOps step:

- `aws_region`
- `kms_key_arn`
- `access_key_id`
- `secret_access_key`
