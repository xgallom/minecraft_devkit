Instruction = require("Compiler/Instruction")
Error = require("Error")
dump = require("dump")

function init(arg)
    if table.getn(arg) ~= 2 then
        print("Usage: compiler <input_file> <output_file>")
        return nil
    end

    input = fs.open(arg[1], "r")
    
    if input == nil then
        Error.print("Error opening file "..arg[1].." for reading")
        return nil
    end
    
    output = fs.open(arg[2], "wb")
    
    if output == nil then
        Error.print("Error opening file "..arg[2].." for writing")
        return nil
    end

    return input,output
end

function parse(input)
    result = {}
    
    line = ""    
    n = 1
    
    while line ~= nil do
        parsed = {}
        
        for token in string.gmatch(line, "([$#%-%a%d]+)") do
            table.insert(parsed, token)
        end
        
        parsingResult = Instruction.parse(parsed)        
        
        if parsingResult ~= nil then
            if parsingResult.error then
                Error.print(n, parsingResult, parsed)
                
                return nil
            end
        
            table.insert(result, parsingResult)
        end
    
        line = input.readLine()
        n = n + 1
    end
    
    return result
end

function writeOut(output, result)
    for _,inst in ipairs(result) do
        for _,byteCode in ipairs(inst) do
            write(tostring(byteCode).." ")
            
            output.write(byteCode)
        end
        
        print("")
    end
end

input,output = init{...}

result = parse(input)
input.close()

if result ~= nil then
    writeOut(output, result)
end

output.close()
