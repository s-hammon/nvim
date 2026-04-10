local state = {
  term = {
    buf = -1,
    win = -1,
  },
  ai = {
    buf = -1,
    win = -1,
  },
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

local toggle_terminal = function(type)
  type = type or "term"
  local current_state = state[type]
  print(current_state)

  if vim.api.nvim_win_is_valid(current_state.win) then
    vim.api.nvim_win_hide(current_state.win)
    return
  end

  for key, term_data in pairs(state) do
    if key ~= type and vim.api.nvim_win_is_valid(term_data.win) then
      vim.api.nvim_win_hide(term_data.win)
    end
  end

  local win_data = create_floating_window({ buf = current_state.buf })

  state[type].buf = win_data.buf
  state[type].win = win_data.win

  if vim.bo[state[type].buf].buftype ~= "terminal" then
    if type == "ai" then
      vim.cmd.terminal("opencode")
    else
      vim.cmd.terminal()
    end

    vim.cmd("startinsert")
  else
    vim.cmd("startinsert")
  end
end

local close_current_terminal = function()
  local current_win = vim.api.nvim_get_current_win()

  for _, term_data in pairs(state) do
    if term_data.win == current_win then
      vim.api.nvim_win_hide(term_data.win)
      return
    end
  end
end

vim.api.nvim_create_user_command("Flerminal", toggle_terminal, {})

vim.keymap.set({ "n" }, "<space>tt", function()
  toggle_terminal("term")
end, { desc = "[T]oggle [T]erminal" })

vim.keymap.set({ "n" }, "<space>ta", function()
  toggle_terminal("ai")
end, { desc = "[T]oggle [A]I Terminal" })

vim.keymap.set({ "n", "t" }, "<C-Esc><C-Esc>", close_current_terminal, { desc = "Close active floating terminal" })

vim.keymap.set("n", "<space>ti", function()
  if not vim.api.nvim_win_is_valid(state.term.win) then
    state.term = create_floating_window({ buf = state.term.buf })
    if vim.bo[state.term.buf].buftype ~= "terminal" then
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
  toggle_terminal("term")
  local ctrl_t = vim.api.nvim_replace_termcodes("<c-t>", true, true, true)
  local cmd = ctrl_t .. command_buf .. "\r"
  vim.api.nvim_feedkeys("i" .. cmd, "n", false)
end, { desc = "[T]erminal [R]un command" })
