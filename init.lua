vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.o.number = true
vim.o.mouse = "a"
vim.o.showmode = false
vim.o.cursorline = true
vim.o.confirm = true
vim.o.updatetime = 250
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true

vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- NOTE: if this doesn't work for some reason, get the bootstrap
-- from lazy.nvim; I'm guessing it won't because of vim.uv
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ import = "config/plugins" }, {
  change_detection = { notify = false },
})

-- [[ Keymaps ]]
-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Return to normal mode from terminal mode
vim.keymap.set("t", ",,", "<c-\\><c-n>")

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Source current file
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>", { desc = "Source file" })
-- Lua: run this line
vim.keymap.set("n", "<space>x", ":.lua<CR>", { desc = "E[x]ecute lua line" })
-- Lua: run selection
vim.keymap.set("v", "<space>x", ":lua<CR>", { desc = "E[x]ecute lua selection" })

-- [[ Autocommands ]]
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})
