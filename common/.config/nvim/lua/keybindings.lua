
-- Remap leader key
vim.cmd 'let mapleader=" "'

-- Set paste toggle
vim.o.pastetoggle = '<F2>'

-- Smart Home key
vim.cmd [[
noremap  <expr> <Home> col('.') == match(getline('.'), '\S') + 1 ? "\<Home>" : "^"
inoremap <expr> <Home> col('.') == match(getline('.'), '\S') + 1 ? "\<Home>" : "\<C-O>^"
]]

vim.cmd [[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
endfunction
]]

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col "." - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", { 1 }) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn["compe#complete"]()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", { -1 }) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })

-- Move lines around in visual mode
vim.cmd [[
vmap <unique> <A-k>    <Plug>SchleppUp
vmap <unique> <A-j>    <Plug>SchleppDown
vmap <unique> <A-h>    <Plug>SchleppLeft
vmap <unique> <A-l>    <Plug>SchleppRight
vmap <unique> <C-k>    <Plug>SchleppDupUp
vmap <unique> <C-j>    <Plug>SchleppDupDown
vmap <unique> <C-h>    <Plug>SchleppDupLeft
vmap <unique> <C-l>    <Plug>SchleppDupRight
]]

local mappings = {
  i = { -- Insert mode
    -- Autocomplete
    { "<C-Space>", "compe#complete()", { silent = true, expr = true } },
    { "<CR>", "compe#confirm(luaeval(\"require 'nvim-autopairs'.autopairs_cr()\"))", { silent = true, expr = true } },
    { "<C-e>", "compe#close('<C-e>')", { silent = true, expr = true } },
    { "<C-f>", "compe#scroll({ 'delta': +4 })", { silent = true, expr = true } },
    { "<C-d>", "compe#scroll({ 'delta': -4 })", { silent = true, expr = true } },
    { "<A-j>", "<ESC><cmd>m .+1<CR>==gi" },
    { "<A-k>", "<ESC><cmd>m .-2<CR>==gi" },

    -- Save while writing
    { "<C-s>", "<ESC><C-s>", { noremap = false }},
  },
  n = { -- Normal mode

    -- Remove trailing whitespaces and save
    { "<C-s>", "<cmd>%s/\\s\\+$//e<cr><cmd>w<cr>" },

    -- Toggle spell
    { "<F1>", "<cmd>set spell!<CR>" },

    -- Toggle Highlighted search
    { "<F3>", "<cmd>set hlsearch!<CR>" },
    -- Build
    { "<F5>", "<cmd>make<cr>" },

    -- Make d(elete) and similar actually delete
    { "\\d", "\"_d" },
    { "\\D", "\"_D" },
    { "\\x", "\"_x" },
    { "\\c", "\"_c" },

    -- Navigation

    --  Tree
    { "<leader>vt", "<cmd>NvimTreeToggle<cr>" },

    -- View
    --  Reset view
    { "<leader>vr",
      table.concat({
        "<cmd>NvimTreeOpen<cr>",
        "<cmd>windo set nonumber<cr>",
        "<cmd>windo set norelativenumber<cr>",
        "<cmd>windo set nolist<cr>",
        "<cmd>NvimTreeClose<cr>",
        "<cmd>tabdo set number<cr>",
        "<cmd>tabdo set list<cr>",
        }, ''
      );
    },

    --  Buffers
    { "<C-n>b", "<cmd>bn<cr>" },
    { "<C-p>b", "<cmd>bp<cr>" },

    --  Diagnostics
    { "<C-p>d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>" },
    { "<C-n>d", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>" },

    --  LSP Hover description
    { "<C-Space>", "<cmd>lua vim.lsp.buf.hover()<cr>" },

    --  Goto symbol
    { "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<cr>" },
    { "<leader>gd", "<cmd>Telescope lsp_definitions<cr>" },
    { "<leader>gi", "<cmd>Telescope lsp_implementations<cr>" },
    { "<leader>gr", "<cmd>Telescope lsp_references<cr>" },
    { "<leader>ggl", "<cmd>Telescope git_commits<cr>" },
    { "<leader>ggc", "<cmd>Telescope git_bcommits<cr>" },
    { "<leader>ggb", "<cmd>Telescope git_branches<cr>" },
    { "<leader>ggs", "<cmd>Telescope git_status<cr>" },

    --  Find
    --  Symbols
    { "<leader>fds", "<cmd>Telescope lsp_document_symbols<cr>" },
    { "<leader>fws", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>" },
    { "<leader>fdd", "<cmd>Telescope lsp_document_diagnostics<cr>" },
    { "<leader>fdl", "<cmd>Telescope loclist<cr>" },
    { "<leader>fwd", "<cmd>Telescope lsp_workspace_diagnostics<cr>" },
    --  Files
    { "<leader>ff", "<cmd>Telescope find_files<cr>" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>" },

    --  Move lines up and down
    { "<A-j>", "<cmd>m .+1<CR>=="},
    { "<A-k>", "<cmd>m .-2<CR>=="},
  },

  v = {
    -- Delete to void register
    { "\\d", "\"_d" },
    { "\\c", "\"_c" },
    { "\\/", "\"fy/<C-R>f", { silent = false }},

    -- Keep visual mode on Tab and S-Tab
    { "<Tab>", ">gv" },
    { "<S-Tab>", "<gv" },
  },
  [""] = {
    -- Toggle the QuickFix window
    { "<C-q>", "<cmd>call QuickFixToggle()<CR>" },
  },
}

local function register_mappings(mappings, default_options)
  for mode, mode_mappings in pairs(mappings) do
    for _, mapping in pairs(mode_mappings) do
      local options = #mapping == 3 and table.remove(mapping) or default_options
      local prefix, cmd = unpack(mapping)
      pcall(vim.api.nvim_set_keymap, mode, prefix, cmd, options)
    end
  end
end

register_mappings(mappings, { silent = true, noremap = true })

