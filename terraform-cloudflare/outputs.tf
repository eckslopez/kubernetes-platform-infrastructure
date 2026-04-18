output "tunnel_id" {
  description = "Cloudflare Tunnel ID"
  value       = cloudflare_zero_trust_tunnel_cloudflared.zavestudios_on_prem.id
}

output "tunnel_name" {
  description = "Cloudflare Tunnel name"
  value       = cloudflare_zero_trust_tunnel_cloudflared.zavestudios_on_prem.name
}

output "tunnel_cname" {
  description = "CNAME target for tunnel"
  value       = "${cloudflare_zero_trust_tunnel_cloudflared.zavestudios_on_prem.id}.cfargotunnel.com"
}

output "tunnel_credentials_json" {
  description = "Tunnel credentials in JSON format for Vault storage"
  sensitive   = true
  value = jsonencode({
    AccountTag   = var.cloudflare_account_id
    TunnelSecret = random_id.tunnel_secret.b64_std
    TunnelID     = cloudflare_zero_trust_tunnel_cloudflared.zavestudios_on_prem.id
  })
}
