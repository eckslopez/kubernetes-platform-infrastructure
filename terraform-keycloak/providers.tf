provider "keycloak" {                                                                                    
  url           = var.keycloak_admin_url
  realm         = var.keycloak_admin_realm
  client_id     = var.keycloak_admin_client_id
  client_secret = var.keycloak_admin_client_secret                                                          
}