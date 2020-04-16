Op = require("Compiler/Op")

local Instructions = {
    NOP = {
        [Op.Disabled] = {
            [Op.Disabled] = 0
        }
    },
    RST = {
        [Op.Disabled] = {
            [Op.Disabled] = 2
        }
    },
    JMP = {
        [Op.Constant] = {
            [Op.Disabled] = 2
        },
        [Op.Register] = {
            [Op.Disabled] = 3
        }
    }
}

return Instructions

