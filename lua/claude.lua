local M = {}

function M.ai_popup_echo(cmd_args, title)
  title = title or "AI CLI"
  local start_time = vim.uv.hrtime()
  local cols, lines = vim.o.columns, vim.o.lines
  local width  = math.max(40, math.floor(cols * 0.45))
  local height = math.max(10, lines - 4)
  local row, col = 1, cols - width - 1

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"Running command...", ""})

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor", row = row, col = col,
    width = width, height = height,
    style = "minimal", border = "rounded",
    title = title, title_pos = "center",
  })

  vim.keymap.set("n", "q", function() pcall(vim.api.nvim_win_close, win, true) end, { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", function() pcall(vim.api.nvim_win_close, win, true) end, { buffer = buf, silent = true })

  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"

  vim.system(cmd_args, {}, function(obj)
    vim.schedule(function()
      if vim.api.nvim_win_is_valid(win) then
        local end_time = vim.uv.hrtime()
        local duration = (end_time - start_time) / 1000000 -- Convert to milliseconds
        local duration_str = string.format("%.1fms", duration)
        
        local output = vim.split(obj.stdout or "", "\n")
        if obj.stderr and obj.stderr ~= "" then
          table.insert(output, "")
          table.insert(output, "Error:")
          vim.list_extend(output, vim.split(obj.stderr, "\n"))
        end
        
        -- Add execution time at the bottom
        table.insert(output, "")
        table.insert(output, string.rep(" ", width - #duration_str - 2) .. duration_str)
        
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
      end
    end)
  end)
end

function M.ai_popup(cmd_args, title)
  title = title or "AI CLI"
  local cols, lines = vim.o.columns, vim.o.lines
  local width  = math.max(40, math.floor(cols * 0.45))
  local height = math.max(10, lines - 4)
  local row, col = 1, cols - width - 1

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor", row = row, col = col,
    width = width, height = height,
    style = "minimal", border = "rounded",
    title = title, title_pos = "center",
  })

  local cmd = cmd_args or {'claude', '--help'}
  vim.fn.termopen(cmd, { on_exit = function() pcall(vim.api.nvim_win_close, win, true) end })
  vim.cmd("startinsert")

  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = buf, silent = true })
  vim.keymap.set("n", "q", function() pcall(vim.api.nvim_win_close, win, true) end,
    { buffer = buf, silent = true })
end

-- Claude wrapper functions
function M.claude_popup_echo(cmd_args)
  return M.ai_popup_echo(cmd_args, "Claude Code")
end

function M.claude_popup(cmd_args)
  return M.ai_popup(cmd_args, "Claude Code")
end

-- Gemini wrapper functions
function M.gemini_popup_echo(cmd_args)
  return M.ai_popup_echo(cmd_args, "Gemini CLI")
end

function M.gemini_popup(cmd_args)
  return M.ai_popup(cmd_args, "Gemini CLI")
end

-- Qwen wrapper functions
function M.qwen_popup_echo(cmd_args)
  return M.ai_popup_echo(cmd_args, "Qwen CLI")
end

function M.qwen_popup(cmd_args)
  return M.ai_popup(cmd_args, "Qwen CLI")
end

-- Keymaps for Claude commands
vim.keymap.set('n', '<leader>cq', function()
  local query = vim.fn.input('Query: ')
  if query ~= '' then M.claude_popup_echo({'claude', '-p', query .. ' Be minimal quick'}) end
end, { desc = 'Claude: Quick query' })

vim.keymap.set('v', '<leader>cs', function()
  local lines = vim.fn.getline(vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2])
  M.claude_popup_echo({'claude', '-p', 'Explain this code:\n```\n' .. table.concat(lines, '\n') .. '\n```'})
end, { desc = 'Claude: Explain selection' })

-- Specific agent commands
vim.keymap.set('n', '<leader>cr', function()
  M.claude_popup({'claude', '-p', '!task --subagent_type code-reviewer "Review the current code for quality, security, and maintainability issues"'})
end, { desc = 'Claude: Code review' })

vim.keymap.set('n', '<leader>cp', function()
  M.claude_popup({'claude', '-p', '!task --subagent_type python-code-reviewer "Perform expert-level Python code review focusing on subtle bugs and execution flow"'})
end, { desc = 'Claude: Python review' })

vim.keymap.set('n', '<leader>ce', function()
  M.claude_popup({'claude', '-p', '!task --subagent_type codebase-explorer "Analyze the codebase architecture, identify key abstractions, and document code structure"'})
end, { desc = 'Claude: Explore codebase' })

vim.keymap.set('n', '<leader>cf', function()
  M.claude_popup({'claude', '-p', '!task --subagent_type deep-flow-analyzer "Analyze data flow through the system and create comprehensive documentation"'})
end, { desc = 'Claude: Trace data flow' })

vim.keymap.set('n', '<leader>cd', function()
  M.claude_popup({'claude', '-p', '!task --subagent_type quick-docs "Create minimal, practical documentation with usage examples"'})
end, { desc = 'Claude: Create docs' })

vim.keymap.set('n', '<leader>cR', function()
  M.claude_popup({'claude', '-p', '!task --subagent_type web-research-critic "Research potential issues, criticisms, and detailed opinions about the specified topic"'})
end, { desc = 'Claude: Research issues' })

vim.keymap.set('n', '<leader>cc', function()
  M.claude_popup({'claude', '-c'})
end, { desc = 'Claude: Continue conversation' })

-- Keymaps for Gemini commands
vim.keymap.set('n', '<leader>gq', function()
  local query = vim.fn.input('Query: ')
  if query ~= '' then M.gemini_popup_echo({'gemini', '-p', query .. ' Be minimal quick'}) end
end, { desc = 'Gemini: Quick query' })

vim.keymap.set('v', '<leader>gs', function()
  local lines = vim.fn.getline(vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2])
  M.gemini_popup_echo({'gemini', '-p', 'Explain this code:\n```\n' .. table.concat(lines, '\n') .. '\n```'})
end, { desc = 'Gemini: Explain selection' })

vim.keymap.set('n', '<leader>gc', function()
  M.gemini_popup({'gemini'})
end, { desc = 'Gemini: Interactive mode' })

vim.keymap.set('n', '<leader>gi', function()
  local query = vim.fn.input('Interactive prompt: ')
  if query ~= '' then M.gemini_popup({'gemini', '-i', query}) end
end, { desc = 'Gemini: Interactive prompt' })

vim.keymap.set('n', '<leader>gy', function()
  local query = vim.fn.input('YOLO query: ')
  if query ~= '' then M.gemini_popup({'gemini', '-p', query, '-y'}) end
end, { desc = 'Gemini: YOLO mode' })

vim.keymap.set('n', '<leader>gm', function()
  local model = vim.fn.input('Model (default: gemini-2.5-flash): ')
  local query = vim.fn.input('Query: ')
  if query ~= '' then
    if model ~= '' then
      M.gemini_popup_echo({'gemini', '-m', model, '-p', query})
    else
      M.gemini_popup_echo({'gemini', '-p', query})
    end
  end
end, { desc = 'Gemini: Custom model query' })

-- Keymaps for Qwen commands
vim.keymap.set('n', '<leader>qq', function()
  local query = vim.fn.input('Query: ')
  if query ~= '' then M.qwen_popup_echo({'qwen', '-p', query .. ' Be minimal quick'}) end
end, { desc = 'Qwen: Quick query' })

vim.keymap.set('v', '<leader>qs', function()
  local lines = vim.fn.getline(vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2])
  M.qwen_popup_echo({'qwen', '-p', 'Explain this code:\n```\n' .. table.concat(lines, '\n') .. '\n```'})
end, { desc = 'Qwen: Explain selection' })

vim.keymap.set('n', '<leader>qc', function()
  M.qwen_popup({'qwen'})
end, { desc = 'Qwen: Interactive mode' })

vim.keymap.set('n', '<leader>qi', function()
  local query = vim.fn.input('Interactive prompt: ')
  if query ~= '' then M.qwen_popup({'qwen', '-i', query}) end
end, { desc = 'Qwen: Interactive prompt' })

vim.keymap.set('n', '<leader>qy', function()
  local query = vim.fn.input('YOLO query: ')
  if query ~= '' then M.qwen_popup({'qwen', '-p', query, '-y'}) end
end, { desc = 'Qwen: YOLO mode' })

vim.keymap.set('n', '<leader>qm', function()
  local model = vim.fn.input('Model: ')
  local query = vim.fn.input('Query: ')
  if query ~= '' then
    if model ~= '' then
      M.qwen_popup_echo({'qwen', '-m', model, '-p', query})
    else
      M.qwen_popup_echo({'qwen', '-p', query})
    end
  end
end, { desc = 'Qwen: Custom model query' })

return M