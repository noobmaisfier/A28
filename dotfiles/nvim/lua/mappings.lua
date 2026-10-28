require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
-- nvim-tree
--map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle NvimTree" })

-- Disable netrw (default Vim plugin) to avoid conflicts

-- Load nvim-tree with basic options

local api = require "nvim-tree.api"

-- Function to toggle between nvim-tree and the active buffer
local function toggle_nvim_tree_focus()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

  if ft == "NvimTree" then
    -- If we are in NvimTree, go back to the previous window
    vim.cmd "wincmd p"
  else
    -- Otherwise, focus the NvimTree window (opens it if closed)
    if not pcall(api.tree.focus) then
      api.tree.toggle()
    end
  end
end

-- Mappings
vim.keymap.set("n", "<leader>n", api.tree.toggle, { desc = "Toggle NvimTree" })
-- vim.keymap.set("n", "<leader>j", api.tree.find_file, { desc = "Find current file " })
vim.keymap.set("n", "<leader>e", toggle_nvim_tree_focus, { desc = "Toggle focus NvimTree" })

-- telescope

map("n", "<leader>ts", require("telescope.builtin").grep_string, { desc = "telescope Grep String" })
map("n", "<leader>tc", require("telescope.builtin").command_history, { desc = "telescope Command History" })
map("n", "<leader>td", require("telescope.builtin").diagnostics, { desc = "telescope Diagnostics" })
map("n", "<leader>tm", require("telescope.builtin").marks, { desc = "telescope Marks" })
map("n", "<leader>tgf", require("telescope.builtin").git_files, { desc = "telescope Git Files" })
map("n", "<leader>tgb", require("telescope.builtin").git_branches, { desc = "telescope Git Branches" })
map("n", "<leader>tgc", require("telescope.builtin").git_commits, { desc = "telescope Git Commits" })

local wk = require "which-key"
-- Lspsaga
wk.add({
  { "<leader>l", group = "Lspsaga" },
  { "<leader>la", "<cmd>Lspsaga code_action<cr>", desc = "LSP: Code Action" },
  { "<leader>lc", "<cmd>Lspsaga show_cursor_diagnostics<cr>", desc = "LSP: Cursor Diagnostics" },
  { "<leader>ld", "<cmd>Lspsaga goto_definition<cr>", desc = "LSP: Go to Definition" },
  { "<leader>lf", "<cmd>Lspsaga finder<cr>", desc = "LSP: Search" },
  { "<leader>lh", "<cmd>Lspsaga hover_doc<cr>", desc = "LSP: Hover Doc" },
  { "<leader>ll", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "LSP: Show Line Diagnostics" },
  { "<leader>lo", "<cmd>Lspsaga outline<cr>", desc = "LSP: Outline" },
  { "<leader>lp", "<cmd>Lspsaga preview_definition<cr>", desc = "LSP: Preview Definition" },
  { "<leader>lr", "<cmd>Lspsaga rename<cr>", desc = "LSP: Rename" },
  -- { "<leader>ls", "<cmd>Lspsaga signature_help<cr>", desc = "LSP: Signature Help" },
  {
    "<leader>lw",
    "<cmd>Lspsaga show_workspace_diagnostics<cr>",
    desc = "LSP: Show Workspace Diagnostics",
  },
}, { mode = "n" }) -- optional: you can specify the mode here (normal by default)

-- ui

wk.add({
  { "<leader>u", group = "UI / Visual" },

  -- Toggle virtual text (inline errors)
  {
    "<leader>ui",
    function()
      local diagnostics = vim.diagnostic
      local current = vim.diagnostic.config().virtual_text
      diagnostics.config { virtual_text = not current }
      print("Toggle virtual text: " .. tostring(not current))
    end,
    desc = "Toggle Virtual Text (inline errors)",
  },

  -- Toggle display of line numbers (number and relativenumber)
  {
    "<leader>un",
    function()
      local number = vim.wo.number
      local relativenumber = vim.wo.relativenumber
      vim.wo.number = not number
      vim.wo.relativenumber = not relativenumber
      print("Toggle line numbers: " .. tostring(not number))
    end,
    desc = "Toggle Line Numbers",
  },

  -- Toggle Zen Mode with folke/zen-mode.nvim
  {
    "<leader>uz",
    function()
      require("zen-mode").toggle()
    end,
    desc = "Toggle Zen Mode",
  },

  -- Toggle underline diagnostics
  {
    "<leader>ul",
    function()
      local diagnostics = vim.diagnostic
      local current = vim.diagnostic.config().underline
      diagnostics.config { underline = not current }
      print("Toggle underline diagnostics: " .. tostring(not current))
    end,
    desc = "Toggle Underline Diagnostics",
  },
}, { mode = "n" })
