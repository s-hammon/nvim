local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end
  local win_cfg = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "double",
  }

  local win = vim.api.nvim_open_win(buf, true, win_cfg)
  return { buf = buf, win = win }
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.api.nvim_create_user_command("Flerminal", toggle_terminal, {})

vim.keymap.set({ "n", "t" }, "<space>tt", toggle_terminal, { desc = "[T]oggle [T]erminal" })

vim.keymap.set("n", "<space>ti", function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  end
  local ctrl_t = vim.api.nvim_replace_termcodes("<c-t>", true, true, true)
  vim.api.nvim_feedkeys("i" .. ctrl_t, "n", false)
end, { desc = "[T]erminal [I]nput" })

-- TODO: make this a better (actual) buffer
local command_buf = ""
local input_command_buf = function()
  command_buf = vim.fn.input(command_buf)
end
-- TODO: maybe this shouldn't be executed from within Flerminal?
vim.keymap.set({ "n" }, "<space>te", input_command_buf, { desc = "[T]erminal [E]dit command" })

vim.keymap.set({ "n" }, "<space>tr", function()
  input_command_buf()
  toggle_terminal()
  local ctrl_t = vim.api.nvim_replace_termcodes("<c-t>", true, true, true)
  local cmd = ctrl_t .. command_buf .. "\r"
  vim.api.nvim_feedkeys("i" .. cmd, "n", false)
end, { desc = "[T]erminal [R]un command" })
