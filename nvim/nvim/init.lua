-- ─────────────────────────────────────────────────────────────
-- Core Settings
-- ─────────────────────────────────────────────────────────────
vim.cmd.syntax("on")
vim.cmd.filetype("plugin indent on")

vim.g.mapleader = " "
vim.cmd.colorscheme("moonfly")

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

-- ─────────────────────────────────────────────────────────────
-- Keymaps
-- ─────────────────────────────────────────────────────────────
local map = vim.keymap.set
local silent = { noremap = true, silent = true }

map("n", "<Space>", "<Nop>", silent)

-- Find
map("n", "<C-p>", "<cmd>FzfLua git_files<CR>", silent)
map("n", "<Leader>p", "<cmd>FzfLua files<CR>", silent)
map("n", "<C-f>", "<cmd>FzfLua live_grep<CR>", silent)

-- Tree
require("nvim-tree").setup({
    actions = { open_file = { quit_on_open = true } },
})
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", silent)

-- Buffers
map("n", "<C-g>", "<cmd>FzfLua buffers<CR>", silent)
map("n", "<C-h>", "<cmd>bprevious<CR>", silent)
map("n", "<C-l>", "<cmd>bnext<CR>", silent)

-- EasyMotion
vim.g.EasyMotion_smartcase = 1
map({ "n", "v" }, "<Leader>j", "<Plug>(easymotion-j)", silent)
map({ "n", "v" }, "<Leader>k", "<Plug>(easymotion-k)", silent)
map("n", "s", "<Plug>(easymotion-bd-f)", silent)

-- Blame
map("n", "<C-b>", "<cmd>Gitsigns toggle_current_line_blame<CR>")

-- LSP navigation
map("n", "K", vim.lsp.buf.hover, silent)
map("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", silent)
map("n", "gD", vim.lsp.buf.declaration, silent)
map("n", "gr", "<cmd>FzfLua lsp_references<CR>", silent)
map("n", "gI", "<cmd>FzfLua lsp_implementations<CR>", silent)
map("n", "gy", "<cmd>FzfLua lsp_typedefs<CR>", silent)

-- LSP symbols
map("n", "<leader>ds", "<cmd>FzfLua lsp_document_symbols<CR>", silent)
map("n", "<leader>ws", "<cmd>FzfLua lsp_workspace_symbols<CR>", silent)

-- LSP actions
map("n", "<leader>rn", vim.lsp.buf.rename, silent)
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, silent)

-- Diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, silent)
map("n", "[d", vim.diagnostic.goto_prev, silent)
map("n", "]d", vim.diagnostic.goto_next, silent)
map("n", "<leader>dq", vim.diagnostic.setqflist, silent)

-- ─────────────────────────────────────────────────────────────
-- Completion (nvim-cmp + luasnip)
-- ─────────────────────────────────────────────────────────────

local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

vim.keymap.set({ "i", "s" }, "<C-l>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end, { silent = true, desc = "Snippet expand/jump" })

vim.keymap.set({ "i", "s" }, "<C-h>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end, { silent = true, desc = "Snippet jump back" })

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),

        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),

        ["<CR>"] = cmp.mapping.confirm({
            select = false,
        }),
    }),

    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
    }, {
        { name = "buffer" },
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
    update_in_insert = false,
})


-- LSP Setup
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.enable({
  "pyright",
  "ts_ls",
  "zls",
  "clangd",
})


-- ─────────────────────────────────────────────────────────────
-- Langauge specific nonsense
-- ─────────────────────────────────────────────────────────────

-- JS/TS/React: prefer 2 spaces so indentexpr behaves
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "json",
        "jsonc",
    },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
    end,
})

