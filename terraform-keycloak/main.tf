resource "keycloak_realm" "zavestudios" {
  realm             = "zavestudios"
  enabled           = true
  display_name      = "ZaveStudios"
  ssl_required      = "external"
  attributes = {
    frontendUrl = "https://sso-on-prem.zavestudios.com/auth"
  }
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
    "http://localhost:8000/auth/callback",
  ]
  valid_post_logout_redirect_uris = [
    "https://panchito-on-prem.zavestudios.com/*",
    "http://localhost:8000/*",
  ]
  web_origins = [
    "https://panchito-on-prem.zavestudios.com",
    "http://localhost:8000",
  ]

}

resource "keycloak_user" "xavier" {
  realm_id   = keycloak_realm.zavestudios.id
  username   = "xavier"
  enabled    = true

  email      = "xavier@zavestudios.com"
  first_name = "Xavier"
  last_name  = "Lopez"

  initial_password {
    value     = var.xavier_initial_password
    temporary = true
  }
}
