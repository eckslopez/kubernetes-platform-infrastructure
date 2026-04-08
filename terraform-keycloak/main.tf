resource "keycloak_realm" "zavestudios" {
  realm             = "zavestudios"
  enabled           = true
  display_name      = "ZaveStudios"
  ssl_required      = "external"
}

resource "keycloak_openid_client" "panchito" {
  realm_id  = keycloak_realm.zavestudios.id
  client_id = "panchito"

  enabled                  = true
  access_type              = "CONFIDENTIAL"
  standard_flow_enabled    = true
  service_accounts_enabled = false
  
  valid_redirect_uris = [
    "https://panchito-on-prem.zavestudios.com/auth/callback",
  ]
  valid_post_logout_redirect_uris = [
    "https://panchito-on-prem.zavestudios.com/*",
  ]
  web_origins = [
    "https://panchito-on-prem.zavestudios.com",
  ]

}