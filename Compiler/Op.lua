local Op = {
    Disabled = 0,
    Constant = 1,
    Register = 2,
    Address = 3,
}

function Op.parseImpl(parser, token)
    if token == nil then token = "" end
    
    return tonumber(string.match(token, parser))
end

function Op.parse(op, token)
    local parsers = {
        [Op.Disabled] = nil,
        [Op.Constant] = "#(%-?[abcdefx%d]+)",
        [Op.Register] = "([ABCDE])",
        [Op.Address ] = "$(%-?[abcdefx%d]+)"
    }
    
    parser = parsers[op]
    
    if parser == nil then
        if token == nil then return 0
        else return nil end
    end
    
    return Op.parseImpl(parser, token)
end

return Op

