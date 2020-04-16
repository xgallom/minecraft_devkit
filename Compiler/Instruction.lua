Op = require("Compiler/Op")
Instructions = require("Compiler/Instructions")

local Instruction = {}

function Instruction.parseOps(inst, line, opId, result)
    if type(inst) == "number" then
        result[1] = inst
        
        return result
    end
    
    for op,newInst in pairs(inst) do
        opResult = Op.parse(op, line[opId])
        
        if opResult ~= nil then
            result[opId] = opResult
            
            return Instruction.parseOps(
                newInst, line, opId + 1, result
            )
        end
    end
    
    return {error = "Invalid operand "..opId - 1, n = opId}
end

function Instruction.parse(line)
    if table.getn(line) < 1 then return nil end
    
    if table.getn(line) > 3 then 
        return {error = "Instruction too long", n = 4}
    end
    
    inst = Instructions[line[1]]
    
    if inst == nil then
        return {error = "Unknown instruction", n = 1}
    end
    
    return Instruction.parseOps(inst, line, 2, {})
end

return Instruction

