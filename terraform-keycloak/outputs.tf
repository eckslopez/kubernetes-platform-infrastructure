output "realm_id" {
    description = "ID of the zavestudios realm"
    value = keycloak_realm.zavestudios.id
}

output "realm_name" {
    description = "Name of the ZaveStudios Realm"
    value = keycloak_realm.zavestudios.realm
}

output "realm_client_id" {
    description = "ID of the Panchito keycloak_openid_client"
    value = keycloak_openid_client.panchito.client_id
}