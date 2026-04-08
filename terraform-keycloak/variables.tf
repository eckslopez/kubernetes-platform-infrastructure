variable "keycloak_admin_url" {
    description = "Base URL for the Keycloak admin/API endpoint used by Terraform"
    type        = string
    default     = "https://sso.zavestudios.com/auth"
}

variable "keycloak_realm" {
    description = "The administration realm"
    type        = string
    default     = "master"
}

variable "keycloak_client_id" {
    description = "Admin client ID used by Terraform to authenticate to Keycloak"
    type        = string 
}

variable "keycloak_client_secret" {
    description = "Admin client secret used by Terraform to authenticate to Keycloak"
    type        = string
}
