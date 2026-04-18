# Locally-managed Cloudflare Tunnel
resource "cloudflare_zero_trust_tunnel_cloudflared" "zavestudios_on_prem" {
  account_id = var.cloudflare_account_id
  name       = var.tunnel_name
  secret     = random_id.tunnel_secret.b64_std
}

# Generate tunnel secret
resource "random_id" "tunnel_secret" {
  byte_length = 32
}

# Tunnel configuration routes all traffic to Istio gateway
# X-Forwarded-Proto header is added by Istio VirtualService, not by cloudflared
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "zavestudios_on_prem" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.zavestudios_on_prem.id

  config {
    ingress_rule {
      service = "http://public-ingressgateway.istio-gateway.svc.cluster.local:80"

      origin_request {
        no_tls_verify    = true
        http_host_header = ""
        http2_origin     = false
      }
    }
  }
}

# DNS record for panchito
resource "cloudflare_record" "panchito_on_prem" {
  zone_id = var.cloudflare_zone_id
  name    = "panchito-on-prem"
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.zavestudios_on_prem.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  comment = "Panchito on-prem application via Cloudflare Tunnel"
  allow_overwrite = true
}

# New -on-prem DNS records (Phase 1: Migration)
resource "cloudflare_record" "vault_on_prem" {
  zone_id = var.cloudflare_zone_id
  name    = "vault-on-prem"
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.zavestudios_on_prem.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  comment = "HashiCorp Vault via Cloudflare Tunnel (on-prem)"
}

resource "cloudflare_record" "sso_on_prem" {
  zone_id = var.cloudflare_zone_id
  name    = "sso-on-prem"
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.zavestudios_on_prem.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  comment = "Keycloak SSO via Cloudflare Tunnel (on-prem)"
}

resource "cloudflare_record" "argocd_on_prem" {
  zone_id = var.cloudflare_zone_id
  name    = "argocd-on-prem"
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.zavestudios_on_prem.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  comment = "ArgoCD via Cloudflare Tunnel (on-prem)"
}

resource "cloudflare_record" "grafana_on_prem" {
  zone_id = var.cloudflare_zone_id
  name    = "grafana-on-prem"
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.zavestudios_on_prem.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  comment = "Grafana via Cloudflare Tunnel (on-prem)"
  allow_overwrite = true
}

resource "cloudflare_record" "prometheus_on_prem" {
  zone_id = var.cloudflare_zone_id
  name    = "prometheus-on-prem"
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.zavestudios_on_prem.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  comment = "Prometheus via Cloudflare Tunnel (on-prem)"
}

resource "cloudflare_record" "alertmanager_on_prem" {
  zone_id = var.cloudflare_zone_id
  name    = "alertmanager-on-prem"
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.zavestudios_on_prem.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  comment = "Alertmanager via Cloudflare Tunnel (on-prem)"
}

resource "cloudflare_record" "loki_on_prem" {
  zone_id = var.cloudflare_zone_id
  name    = "loki-on-prem"
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.zavestudios_on_prem.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  comment = "Loki via Cloudflare Tunnel (on-prem)"
}

resource "cloudflare_record" "kiali_on_prem" {
  zone_id = var.cloudflare_zone_id
  name    = "kiali-on-prem"
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.zavestudios_on_prem.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  comment = "Kiali via Cloudflare Tunnel (on-prem)"
}

resource "cloudflare_record" "policyreporter_on_prem" {
  zone_id = var.cloudflare_zone_id
  name    = "policyreporter-on-prem"
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.zavestudios_on_prem.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  comment = "Policy Reporter via Cloudflare Tunnel (on-prem)"
}
