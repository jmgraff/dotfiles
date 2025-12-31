-- ─────────────────────────────────────────────────────────────
-- Core Settings
-- ─────────────────────────────────────────────────────────────
vim.cmd.syntax("on")
vim.cmd.filetype("plugin indent on")

vim.g.mapleader = " "
vim.g.solarized_termcolors = 256
vim.cmd.colorscheme("solarized")
vim.opt.background = "dark"

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.wrap = false
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false
vim.opt.list = true
vim.opt.swapfile = false
vim.opt.listchars = {
    tab = "» ",
    extends = "›",
    precedes = "‹",
    trail = "•",
}
vim.opt.signcolumn = "yes"
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })

-- Window behavior
vim.opt.equalalways = false
vim.opt.winminheight = 0
vim.opt.winheight = 9999
vim.opt.helpheight = 9999

-- Auto reload external changes
--set autoread

-- ─────────────────────────────────────────────────────────────
-- Keymaps
-- ─────────────────────────────────────────────────────────────
local map = vim.keymap.set
local silent = { noremap = true, silent = true }

map("n", "<Space>", "<Nop>", silent)
map("", "<Leader>", "<Plug>(easymotion-prefix)")

-- Find
map("n", "<C-p>", ":GFiles<CR>", silent)
map("n", "<Leader>p", ":Files<CR>", silent)
map("n", "<C-f>", ":Rg<CR>", silent)

-- Tree
require("nvim-tree").setup({
    actions = { open_file = { quit_on_open = true } },
})
map("n", "<C-n>", ":NvimTreeToggle<CR>", silent)

-- Tabs/Windows
map("n", "<C-l>", ":tabn<CR>", silent)
map("n", "<C-h>", ":tabp<CR>", silent)
map("n", "<C-j>", "<C-w><C-j>", silent)
map("n", "<C-k>", "<C-w><C-k>", silent)

-- LSP general keymaps
map("n", "K", vim.lsp.buf.hover, {})
map("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

-- ─────────────────────────────────────────────────────────────
-- Completion (nvim-cmp + luasnip)
-- ─────────────────────────────────────────────────────────────
local cmp = require("cmp")

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
    }),
})

-- ─────────────────────────────────────────────────────────────
-- Errors
-- ─────────────────────────────────────────────────────────────

vim.diagnostic.config({
    virtual_text = {
        prefix = "",
    },
    signs = true,
    underline = true,
    severity_sort = true,
    severity_sort = true,
    update_in_insert = false,
})


-- LSP Setup (new vim.lsp.* API)
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local util = require("lspconfig.util")

-- Python (pyright)
require("lspconfig.configs").pyright = {
    default_config = {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_dir = util.root_pattern("pyrightconfig.json", "requirements.txt", "pyproject.toml", ".git"),
        single_file_support = true,
        settings = {
            python = {
                analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true },
            },
        },
    }
}
require("lspconfig").pyright.setup({ capabilities = capabilities })

-- TypeScript / JavaScript (ts_ls)
require("lspconfig.configs").ts_ls = {
    default_config = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "typescript.tsx" },
        root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
        single_file_support = false,
    },
}
require("lspconfig").ts_ls.setup({ capabilities = capabilities })


-- Zig
require("lspconfig.configs").zls = {
    default_config = {
        cmd = { "zls" },
        filetypes = { "zig" },
        root_dir = util.root_pattern("build.zig", "main.zig", ".git"),
    }
}
require("lspconfig").zls.setup({ capabilities = capabilities })

-- Clangd (TODO: replace all above with the new, easy version. But verify it works first.
vim.lsp.enable({ "clangd" })


-- ─────────────────────────────────────────────────────────────
-- Langauge specific nonsense
-- ─────────────────────────────────────────────────────────────
-- JS/TS/React: prefer 2 spaces so indentexpr behaves
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end,
})

