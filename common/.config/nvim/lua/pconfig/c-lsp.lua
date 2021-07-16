local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lspc = require('lspconfig')

lspc.vimls.setup{}
lspc.clangd.setup{}
lspc.tsserver.setup{}
lspc.serve_d.setup{}
