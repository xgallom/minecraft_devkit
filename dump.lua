function dumpString(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dumpString(v) .. ','
        end
        
        return s..'} '
    else
        return tostring(o)
    end
end

return function(o)
    print(dumpString(o))
end
