local mason = require("mason")

-- import mason-lspconfig
local mason_lspconfig = require("mason-lspconfig")

-- enable mason and configure icons
mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

mason_lspconfig.setup({
  -- list of servers for mason to install
  ensure_installed = {
    "bashls",
    "docker",
    "docker_compose_language_service",
    "gopls",
    "jsonls",
    "markdown_oxide",
    "taplo",
    "tailwindcss",
    "yamlls",
    "nil_ls",
    "rust_analyzer",
    "sqlls",
    "tsserver",
    "html",
    "cssls",
    "tailwindcss",
    "svelte",
    "lua_ls",
    "graphql",
    "emmet_ls",
    "prismals",
    "pyright",
  },
})
