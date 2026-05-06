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

resource "cloudflare_record" "airflow_on_prem" {
  zone_id = var.cloudflare_zone_id
  name    = "airflow-on-prem"
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.zavestudios_on_prem.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  comment = "Airflow UI via Cloudflare Tunnel (on-prem)"
}

# Cloudflare Access Application for Operator UIs
resource "cloudflare_zero_trust_access_application" "operator_uis" {
  account_id                = var.cloudflare_account_id
  name                      = "Platform Operator UIs"
  domain                    = "vault-on-prem.zavestudios.com"
  type                      = "self_hosted"
  session_duration          = "24h"
  auto_redirect_to_identity = false
}

# Additional domains for the Access Application
resource "cloudflare_zero_trust_access_application" "argocd" {
  account_id                = var.cloudflare_account_id
  name                      = "ArgoCD"
  domain                    = "argocd-on-prem.zavestudios.com"
  type                      = "self_hosted"
  session_duration          = "24h"
  auto_redirect_to_identity = false
}

resource "cloudflare_zero_trust_access_application" "grafana" {
  account_id                = var.cloudflare_account_id
  name                      = "Grafana"
  domain                    = "grafana-on-prem.zavestudios.com"
  type                      = "self_hosted"
  session_duration          = "24h"
  auto_redirect_to_identity = false
}

resource "cloudflare_zero_trust_access_application" "prometheus" {
  account_id                = var.cloudflare_account_id
  name                      = "Prometheus"
  domain                    = "prometheus-on-prem.zavestudios.com"
  type                      = "self_hosted"
  session_duration          = "24h"
  auto_redirect_to_identity = false
}

resource "cloudflare_zero_trust_access_application" "alertmanager" {
  account_id                = var.cloudflare_account_id
  name                      = "Alertmanager"
  domain                    = "alertmanager-on-prem.zavestudios.com"
  type                      = "self_hosted"
  session_duration          = "24h"
  auto_redirect_to_identity = false
}

resource "cloudflare_zero_trust_access_application" "loki" {
  account_id                = var.cloudflare_account_id
  name                      = "Loki"
  domain                    = "loki-on-prem.zavestudios.com"
  type                      = "self_hosted"
  session_duration          = "24h"
  auto_redirect_to_identity = false
}

resource "cloudflare_zero_trust_access_application" "kiali" {
  account_id                = var.cloudflare_account_id
  name                      = "Kiali"
  domain                    = "kiali-on-prem.zavestudios.com"
  type                      = "self_hosted"
  session_duration          = "24h"
  auto_redirect_to_identity = false
}

resource "cloudflare_zero_trust_access_application" "policyreporter" {
  account_id                = var.cloudflare_account_id
  name                      = "Policy Reporter"
  domain                    = "policyreporter-on-prem.zavestudios.com"
  type                      = "self_hosted"
  session_duration          = "24h"
  auto_redirect_to_identity = false
}

resource "cloudflare_zero_trust_access_application" "airflow" {
  account_id                = var.cloudflare_account_id
  name                      = "Airflow"
  domain                    = "airflow-on-prem.zavestudios.com"
  type                      = "self_hosted"
  session_duration          = "24h"
  auto_redirect_to_identity = false
}

# Access Policy for Operator UIs - Vault
resource "cloudflare_zero_trust_access_policy" "operator_uis_policy" {
  application_id = cloudflare_zero_trust_access_application.operator_uis.id
  account_id     = var.cloudflare_account_id
  name           = "Allow Operators"
  precedence     = 1
  decision       = "allow"

  include {
    email = var.operator_emails
  }
}

# Access Policy for ArgoCD
resource "cloudflare_zero_trust_access_policy" "argocd_policy" {
  application_id = cloudflare_zero_trust_access_application.argocd.id
  account_id     = var.cloudflare_account_id
  name           = "Allow Operators"
  precedence     = 1
  decision       = "allow"

  include {
    email = var.operator_emails
  }
}

# Access Policy for Grafana
# NOTE: Grafana has a reusable policy created during onboarding that cannot be easily managed via Terraform
# Manage this policy manually in the Cloudflare UI for now
# resource "cloudflare_zero_trust_access_policy" "grafana_policy" {
#   application_id = cloudflare_zero_trust_access_application.grafana.id
#   account_id     = var.cloudflare_account_id
#   name           = "Allow Operators"
#   precedence     = 1
#   decision       = "allow"
#
#   include {
#     email = var.operator_emails
#   }
# }

# Access Policy for Prometheus
resource "cloudflare_zero_trust_access_policy" "prometheus_policy" {
  application_id = cloudflare_zero_trust_access_application.prometheus.id
  account_id     = var.cloudflare_account_id
  name           = "Allow Operators"
  precedence     = 1
  decision       = "allow"

  include {
    email = var.operator_emails
  }
}

# Access Policy for Alertmanager
resource "cloudflare_zero_trust_access_policy" "alertmanager_policy" {
  application_id = cloudflare_zero_trust_access_application.alertmanager.id
  account_id     = var.cloudflare_account_id
  name           = "Allow Operators"
  precedence     = 1
  decision       = "allow"

  include {
    email = var.operator_emails
  }
}

# Access Policy for Loki
resource "cloudflare_zero_trust_access_policy" "loki_policy" {
  application_id = cloudflare_zero_trust_access_application.loki.id
  account_id     = var.cloudflare_account_id
  name           = "Allow Operators"
  precedence     = 1
  decision       = "allow"

  include {
    email = var.operator_emails
  }
}

# Access Policy for Kiali
resource "cloudflare_zero_trust_access_policy" "kiali_policy" {
  application_id = cloudflare_zero_trust_access_application.kiali.id
  account_id     = var.cloudflare_account_id
  name           = "Allow Operators"
  precedence     = 1
  decision       = "allow"

  include {
    email = var.operator_emails
  }
}

# Access Policy for Policy Reporter
resource "cloudflare_zero_trust_access_policy" "policyreporter_policy" {
  application_id = cloudflare_zero_trust_access_application.policyreporter.id
  account_id     = var.cloudflare_account_id
  name           = "Allow Operators"
  precedence     = 1
  decision       = "allow"

  include {
    email = var.operator_emails
  }
}

resource "cloudflare_zero_trust_access_policy" "airflow_policy" {
  application_id = cloudflare_zero_trust_access_application.airflow.id
  account_id     = var.cloudflare_account_id
  name           = "Allow Operators"
  precedence     = 1
  decision       = "allow"

  include {
    email = var.operator_emails
  }
}
