-- helper variables
local o = vim.o
local g = vim.g

-------------------------------------------------------------------------------

-- Enable encoding
o.encoding = "utf-8"

-- Custom timeouts
o.timeout = true
o.timeoutlen = 500

-- Editor settings
--  Whitespace rendering
o.listchars = 'tab:→ ,extends:❯,precedes:❮,trail:·,nbsp:·,space:·'
-- o.listchars = 'tab:▷▷⋮,extends:❯,precedes:❮,trail:·,nbsp:·,space:·'
o.showbreak = '↪'
--  Hidden buffers
o.hidden = true
-- Hidden mode
o.showmode = false
