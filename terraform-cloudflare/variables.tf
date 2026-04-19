variable "cloudflare_api_token" {
  description = "Cloudflare API token with permissions for Tunnel, DNS, and Zero Trust"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID for zavestudios.com"
  type        = string
}

variable "tunnel_name" {
  description = "Name for the Cloudflare Tunnel"
  type        = string
  default     = "zavestudios-on-prem"
}

variable "operator_emails" {
  description = "List of email addresses allowed to access operator UIs via Cloudflare Access"
  type        = list(string)
}
