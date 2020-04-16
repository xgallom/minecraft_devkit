Error = require("Error")

local Out = {
    Ctrl = "top",
    Inst = "right",
    Low = "left",
    High = "back"
}

local MemoryMax = 64

function get(side)
    return rs.getBundledOutput(side)
end

function set(side, value)
    rs.setBundledOutput(side, value)
end

function commit()
    os.sleep(0.6)
end

function flip(b)
    set(Out.Ctrl, bit.bor(get(Out.Ctrl), b))
    commit()
    
    set(Out.Ctrl, bit.band(get(Out.Ctrl), bit.bnot(b)))
    commit()
end

function flipClock()
    flip(1)
end
function flipProg()
    flip(2)
end

function init(arg)
    if table.getn(arg) ~= 1 then
        print("Usage: programmer <input_file>")
        return nil
    end
    
    local input = fs.open(arg[1], "rb")
    
    if input == nil then
        Error.print("Error opening file "..arg[1])
    end
    
    return input
end

function prepare()
    set(Out.Ctrl, 4)
    set(Out.Inst, 0)
    set(Out.Low , 0)
    set(Out.High, 0)
    commit()
    
    flipClock()
    
    set(Out.Ctrl, 0)
    commit()
end

function writeOut(input)
    for i = 1,MemoryMax do
        local inst = input.read()
        local low  = input.read()
        local high = input.read()
                
        if inst == nil then
            inst = 0
            low = 0
            high = 0
        elseif low == nil or high == nil then
            Error.print("Corrupted binary")
        end
        
        print(i, ":", inst, low, high)
        
        set(Out.Inst, inst)
        set(Out.Low , low )
        set(Out.High, high)
                
        flipProg()
        flipClock()
    end
end

function finish()
    set(Out.Ctrl, 0)
    set(Out.Inst, 0)
    set(Out.Low , 0)
    set(Out.High, 0)
end

local input = init{...}

prepare()

writeOut(input)
input.close()

finish()
