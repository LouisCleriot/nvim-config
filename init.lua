vim.opt.clipboard = "unnamedplus"
vim.g.python3_host_prog ="/home/louralie/miniforge3/bin/python"

-- ========================================================================== --
-- GENERAL SETTINGS
-- ========================================================================== --
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true

-- ========================================================================== --
-- THEME
-- ========================================================================== --
-- Wrap in pcall so neovim doesn't crash if the directory is missing
pcall(vim.cmd.colorscheme, "catppuccin")

-- ========================================================================== --
-- LANGUAGE SUPPORT
-- ========================================================================== --
-- NOTE: Run :TSUpdate inside Neovim
local ts_status, ts_configs = pcall(require, "nvim-treesitter.configs")
if ts_status then
  ts_configs.setup({
    --ensure_installed = { "lua", "vim", "vimdoc", "python", "javascript", "markdown", "markdown_inline", "cpp", "rust" },
    sync_install = false, 
    auto_install = false, 

    highlight = { enable = true },
    indent = { enable = true },
  })
end

-- ========================================================================== --
-- LSP
-- ========================================================================== --
-- Setup File Operations 
local fileops_status, fileops = pcall(require, "lsp-file-operations")
if fileops_status then
  fileops.setup()
end

vim.lsp.enable({ 
  "lua_ls", 
  "rust_analyzer", 
  "clangd", 
  "ts_ls",
  "pyrefly"
})


-- ========================================================================== --
-- AUTOCOMMANDS (Completion & Formatting)
-- ========================================================================== --
local group = vim.api.nvim_create_augroup("NativeUserConfig", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local buf = args.buf

    if client.supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
    end

    local opts = { buffer = buf, desc = "" }
    opts.desc = "LSP Hover"; vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    opts.desc = "Go to Definition"; vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    opts.desc = "References"; vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    opts.desc = "Rename"; vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    opts.desc = "Code Action"; vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  end,
})

local blink_status, blink = pcall(require, "blink.cmp")

if blink_status then
  blink.setup({
    keymap = { preset = 'default' },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    
    signature = { enabled = true }
  })

  if vim.lsp.config then 
    vim.lsp.config('*', { 
      capabilities = blink.get_lsp_capabilities() 
    })
  end
end



-- ========================================================================== --
-- AUTO-FORMAT & AUTO-SAVE
-- ========================================================================== --

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = { "*.py", "*.rs", "*.cpp", "*.html", "*.css", "*.lua" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})


-- Diagnostic UI
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- ========================================================================== --
-- KEYMAPS
-- ========================================================================== --
vim.keymap.set('n', 'K',  vim.lsp.buf.hover, { desc = "LSP Hover" })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "Show References" })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open File Explorer" })

local wk_status, wk = pcall(require, "which-key")
if wk_status then
  wk.add({
    { "<leader>f", group = "Find (Telescope)" },
    { "<leader>c", group = "Code Actions" },
    { "<leader>v", group = "Venv/View" },
  })
end

-- ========================================================================== --
-- UI PLUGINS CONFIGURATION
-- ========================================================================== --

-- GITSIGNS (Git integration in the gutter)
local gs_status, gs = pcall(require, "gitsigns")
if gs_status then
  gs.setup()
end

-- TODO COMMENTS (Highlight TODO, FIXME, etc.)
local todo_status, todo = pcall(require, "todo-comments")
if todo_status then
  todo.setup({
    signs = true, -- show icons in the sign column
  })
  vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "Find TODOs" })
end

-- TELESCOPE (Fuzzy Finder)
local tele_status, telescope = pcall(require, "telescope")
if tele_status then
  local builtin = require("telescope.builtin")
  
  telescope.setup({
    defaults = {
      file_ignore_patterns = { "node_modules", ".git" },
    }
  })

  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live Grep (Text)" })
  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find Buffers" })
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Find Help" })
end

-- NEO-TREE (File Explorer)
local neo_status, neotree = pcall(require, "neo-tree")
if neo_status then
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  neotree.setup({
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    window = {
      width = 30,
    }
  })

  vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = "Toggle Explorer" })
end

-- TREESITTER CONTEXT (Sticky Headers)
local ts_context_status, ts_context = pcall(require, "treesitter-context")
if ts_context_status then
  ts_context.setup({
    enable = true,
    max_lines = 3,
    min_window_height = 20,
  })
end

-- RENDER MARKDOWN (Beautiful Markdown)
local rm_status, render_markdown = pcall(require, "render-markdown")
if rm_status then
  render_markdown.setup({
    pipe_table = { preset = 'heavy' },
    completion = { lsp = { enabled = true } },
  })
end

local harpoon_status, harpoon = pcall(require, "harpoon")
if harpoon_status then
  harpoon:setup()

  -- Add current file to Harpoon list
  vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon Add" })
  
  -- Open the Harpoon menu
  vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Menu" })

  -- Navigate to files 1, 2, 3, 4
  vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
  vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
  vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
  vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)

  -- Toggle previous & next buffers stored in Harpoon
  vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
  vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
end

-- status line
local lualine_status, lualine = pcall(require, "lualine")
if lualine_status then
  lualine.setup({
    options = {
      theme = "catppuccin",
      component_separators = '|',
      section_separators = '',
    },
  })
end

local surround_status, surround = pcall(require, "nvim-surround")
if surround_status then
  surround.setup()
end

local pairs_status, autopairs = pcall(require, "nvim-autopairs")
if pairs_status then
  autopairs.setup({
    disable_filetype = { "TelescopePrompt" },
  })
end

-- ========================================================================== --
-- 8. DATA SCIENCE & PYTHON TOOLS
-- ========================================================================== --

-- VIM-SLIME (Send code to terminal)
-- Usage: 
-- 1. Open a terminal split: :vsp | term
-- 2. Start ipython inside it.
-- 3. Go back to your python file.
-- 4. Press <Ctrl-c><Ctrl-c> to send the current paragraph/cell.
vim.g.slime_target = "neovim"
vim.g.slime_no_mappings = 1
vim.g.slime_python_ipython = 1

-- Keymap: Ctrl+c, Ctrl+c to send code
vim.keymap.set("x", "<C-c><C-c>", "<Plug>SlimeRegionSend", { desc = "Send Selection" })
vim.keymap.set("n", "<C-c><C-c>", "<Plug>SlimeParagraphSend", { desc = "Send Paragraph" })


-- VENV-SELECTOR (Select Conda/Venv)
local venv_status, venv_selector = pcall(require, "venv-selector")
if venv_status then
  venv_selector.setup({})

  vim.keymap.set("n", "<leader>vs", ":VenvSelect<CR>", { desc = "Select Virtual Env" })
end


-- RAINBOW DELIMITERS (Better Parentheses)
local rainbow_status, rainbow = pcall(require, "rainbow-delimiters.setup")
if rainbow_status then
  rainbow.setup()
end

