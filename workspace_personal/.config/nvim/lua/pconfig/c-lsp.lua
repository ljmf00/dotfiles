local capabilities = require('cmp_nvim_lsp').default_capabilities({
  snippetSupport = true
})

local lspc = require('lspconfig')

lspc.vimls.setup({ capabilities = capabilities })
lspc.clangd.setup({ capabilities = capabilities })
lspc.tsserver.setup({ capabilities = capabilities })
lspc.serve_d.setup({ capabilities = capabilities })
lspc.jedi_language_server.setup({ capabilities = capabilities })
