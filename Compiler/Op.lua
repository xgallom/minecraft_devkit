local Op = {
    Disabled = 0,
    Constant = 1,
    Register = 2,
    Address = 3,
}

local Parsers = {
    [Op.Disabled] = nil,
    [Op.Constant] = "#(%-?[abcdefx%d]+)",
    [Op.Register] = function(token)
        local register = string.match(token, "[ABCDEF]")

        if register == nil then return nil end

        return string.byte(register) - string.byte("A")
    end,
    [Op.Address ] = "$(%-?[abcdefx%d]+)"
}

function Op.parseImpl(parser, token)
    if token == nil then token = "" end

    if type(parser) == "string" then
        return tonumber(string.match(token, parser))
    elseif type(parser) == "function" then
        return parser(token)
    end

    return nil
end

function Op.parse(op, token)
    local parser = Parsers[op]

    if parser == nil then
        if token == nil then return 0
        else return nil end
    end

    return Op.parseImpl(parser, token)
end

return Op

