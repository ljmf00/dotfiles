local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lspc = require('lspconfig')
local coq = require "coq"

lspc.vimls.setup(coq.lsp_ensure_capabilities({}))
lspc.clangd.setup(coq.lsp_ensure_capabilities({}))
lspc.tsserver.setup(coq.lsp_ensure_capabilities({}))
lspc.serve_d.setup(coq.lsp_ensure_capabilities({}))
lspc.jedi_language_server.setup(coq.lsp_ensure_capabilities({}))

vim.cmd('COQnow -s')
