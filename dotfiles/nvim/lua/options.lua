require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!

--o.foldenable = false -- Enable folding when opening a file
-- o.foldmethod = "expr" -- Fold method based on expressions
--o.foldexpr = "nvim_treesitter#foldexpr()" -- Tree-sitter expression

vim.opt.laststatus = 3
-- vim.g.mcphub_auto_approve = true

vim.diagnostic.config {
  virtual_text = false, -- disable inline display of errors
  signs = true, -- you can keep the signs in the gutter
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}

local cmp = require "cmp"
cmp.setup {
  mapping = {
    ["<Down>"] = cmp.mapping.select_next_item(),
    ["<Up>"] = cmp.mapping.select_prev_item(),
    -- you can keep other mappings like <CR> to confirm the selection
  },
  -- other options...
}
