require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  -- "vtsls",
  "tsgo",
  "clangd",
  "pyright",
  "jdtls",
  "bashls",
  "gopls",
  -- "sqls",
  -- "phpactor",
  -- "tailwindcss",
  "dockerls",
  "yamlls",
  "jsonls",
  -- "rust_analyzer",
  -- "biome",
  -- "vue-language-server",
  -- "svelte",
  "templ",
}

-- -- read :h vim.lsp.config for changing options of lsp servers
vim.lsp.enable(servers)
