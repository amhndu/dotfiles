-- https://tduyng.com/blog/neovim-session-management/

vim.opt.sessionoptions = 'buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

local session_dir = vim.fn.stdpath 'state' .. '/sessions/'

if vim.fn.isdirectory(session_dir) == 0 then
  vim.fn.mkdir(session_dir, 'p')
end

local function get_session_file()
  local cwd = vim.fn.getcwd()

  local session_name = cwd:gsub('/', '%%')

  return session_dir .. session_name .. '.vim'
end

-- Only manage a per-directory session when nvim is started bare (no file
-- arguments). When another tool opens nvim on a specific file (like git editing a commit message),
-- and often deleted afterwards; saving it would clobber the directory's real
-- session with a dangling file. In that case we neither restore nor save.
local manage_session = false

vim.api.nvim_create_autocmd('VimEnter', {

  callback = function()
    if vim.fn.argc() ~= 0 then
      return
    end

    manage_session = true

    local session_file = get_session_file()

    if vim.fn.filereadable(session_file) == 1 then
      vim.cmd 'silent! set winminwidth=1 winwidth=1 winminheight=1 winheight=1'

      vim.cmd('source ' .. vim.fn.fnameescape(session_file))
    end
  end,
})

vim.api.nvim_create_autocmd('VimLeavePre', {

  callback = function()
    if not manage_session then
      return
    end

    local stop_file = session_dir .. '.stop_saving'

    if vim.fn.filereadable(stop_file) == 1 then
      vim.fn.delete(stop_file)

      return
    end

    local buf_count = 0

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= '' then
        buf_count = buf_count + 1
      end
    end

    if buf_count >= 1 then
      local session_file = get_session_file()

      vim.cmd('mksession! ' .. vim.fn.fnameescape(session_file))
    end
  end,
})

-- Load session for current directory
vim.keymap.set('n', '<leader>qs', function()
  local session_file = get_session_file()

  if vim.fn.filereadable(session_file) == 1 then
    vim.cmd('source ' .. vim.fn.fnameescape(session_file))
  else
    print 'No session found'
  end
end, { desc = 'Load session' })

vim.keymap.set('n', '<leader>qS', function()
  local sessions = {}

  local session_files = vim.fn.glob(session_dir .. '*.vim', false, true)

  for _, file in ipairs(session_files) do
    local name = vim.fn.fnamemodify(file, ':t:r')

    name = name:gsub('%%', '/')

    table.insert(sessions, name)
  end

  if #sessions == 0 then
    print 'No sessions found'

    return
  end

  vim.ui.select(sessions, { prompt = 'Select session:' }, function(choice)
    if choice then
      local session_file = session_dir .. choice:gsub('/', '%%') .. '.vim'

      vim.cmd('source ' .. vim.fn.fnameescape(session_file))
    end
  end)
end, { desc = 'Select session' })

vim.keymap.set('n', '<leader>qd', function()
  local stop_file = session_dir .. '.stop_saving'

  vim.fn.writefile({}, stop_file)

  print 'Session saving disabled'
end, { desc = 'Disable session saving' })
