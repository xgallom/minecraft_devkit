local Error = {}

function Error.print(error)
    term.setTextColor(colors.red)
    print(error)
    term.setTextColor(colors.white)
end

function Error.print(n, error, tokens)
    ns = tostring(n)
    
    term.setTextColor(colors.red)
    prep="Line "..ns..": "
    write(prep)
    
    for i = 1,3 do
        token = tokens[i]
        
        if i == error.n then
            term.setTextColor(colors.lightBlue)
        else
            term.setTextColor(colors.white)
        end
        
        if token == nil then
            if i == error.n then
                write("_ ")
            elseif i < error.n then
                write("_ ")
            end
        else
            write(token.." ")
        end
    end
    
    print("")
    
    for i = 1,string.len(prep) do
        write(" ")
    end
    
    term.setTextColor(colors.red)
    print(error.error)
    term.setTextColor(colors.white)
end

return Error
