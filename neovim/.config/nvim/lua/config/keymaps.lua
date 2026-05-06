-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- close the current buffer
vim.keymap.set("n", "<leader><BS>", function()
  Snacks.bufdelete()
end, { desc = "Close Buffer" })

-- closes all buffers using an ex command and range syntax: <CR>: return key
vim.keymap.set("n", "<leader><CR>", "<cmd>%bd<cr>", { desc = "Close All Buffers" })
