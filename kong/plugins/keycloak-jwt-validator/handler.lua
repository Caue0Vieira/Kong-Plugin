local jwt = require "resty.jwt"

local plugin = {
    PRIORITY = 1000,
    VERSION = "1.0.0",
}

function plugin:access(conf)
    local auth_header = kong.request.get_header("Authorization")
    if not auth_header or not auth_header:find("Bearer ") then
        return kong.response.exit(401, { message = "Token ausente ou inválido" })
    end

    local token = auth_header:match("Bearer%s+(.+)")
    if not token then
        return kong.response.exit(401, { message = "Token mal formatado" })
    end

    local jwt_obj = jwt:load_jwt(token)
    if not jwt_obj.valid then
        return kong.response.exit(401, { message = "Token inválido (mal formado)" })
    end

    local verified = jwt:verify_jwt_obj(conf.pem_public_key, jwt_obj)
    if not verified.verified then
        return kong.response.exit(401, { message = "Assinatura inválida: " .. (verified.reason or "") })
    end


    kong.log.debug("[keycloak-jwt-validator] Token válido.")
end

return plugin