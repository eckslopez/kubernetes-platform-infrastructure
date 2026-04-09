variable "keycloak_admin_url" {
    description = "Base URL for the Keycloak admin/API endpoint used by Terraform"
    type        = string
}

variable "keycloak_admin_realm" {
    description = "The administration realm"
    type        = string
    default     = "master"
}

variable "keycloak_admin_client_id" {
    description = "Admin client ID used by Terraform to authenticate to Keycloak"
    type        = string 
}

variable "keycloak_admin_client_secret" {
    description = "Admin client secret used by Terraform to authenticate to Keycloak"
    type        = string
}
