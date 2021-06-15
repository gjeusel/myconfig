local pyls_config = require"lspinstall/util".extract_config("pyls")
pyls_config.default_config.cmd[1] = "./venv/bin/pylsp"

require'lspinstall/servers'.pyls = vim.tbl_extend('error', pyls_config, {
  install_script = [[
  python3 -m venv ./venv
  ./venv/bin/pip3 install --upgrade pip
  ./venv/bin/pip3 install --upgrade 'python-lsp-server[rope]'
  ./venv/bin/pip3 install --upgrade pyls-flake8 mypy-ls pyls-isort python-lsp-black
  ]]
})

return {}


-- TODO: Improve mypy speed with dmypy https://github.com/Richardk2n/mypy-ls#configuration

-- -- npm i -g pyright
-- require('lspconfig').pyright.setup {
--   cmd = { "pyright-langserver", "--stdio" },
--   filetypes = filetypes,
--   root_dir = root_dir,
--   on_attach = require'lsp'.common_on_attach,
--   handlers = {
--     ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--       virtual_text = {spacing = 0, prefix = ""},
--       signs = true,
--       underline = true,
--       update_in_insert = true
--     })
--   },
--   settings = {
--     python = {
--       analysis = {
--         typeCheckingMode = "basic",
--         diagnosticMode = "workspace",
--         autoSearchPaths = true,
--         useLibraryCodeForTypes = true,
--       }
--     }
--   }
-- }