return {
    name = "keycloak-jwt-validator",
    fields = {
        { config = {
            type = "record",
            fields = {
                { client_id = { type = "string", required = true } },
                { pem_public_key = { type = "string", required = true } },
            }
        }
        }
    }
}