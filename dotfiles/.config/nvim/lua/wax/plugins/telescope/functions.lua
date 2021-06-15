require("wax.plugins.telescope.layout")
local constants = require("wax.plugins.telescope.constants")

local builtin = require('telescope.builtin')
local actions = require('telescope.actions')

local M = {}

-- Custom Grep to be fuzzy
M.git_grep_string = function()
  local git_root, _ = get_os_command_output({ "git", "rev-parse", "--show-toplevel" })
  local opts = {
    prompt_title = "~ git grep string ~",
    -- search = '' ,  -- https://github.com/nvim-telescope/telescope.nvim/issues/564
    cwd = git_root[1],
    -- vimgrep_arguments = grep_cmds["git"],
    vimgrep_arguments = constants.grep_cmds["rg"],
  }

  -- local theme_opts = require('telescope.themes').get_dropdown({})
  -- local theme_opts = require('telescope.themes').get_ivy({})
  -- for k,v in pairs(theme_opts) do opts[k] = v end
  return builtin.grep_string(opts)
end
M.rg_grep_string = function()
  local root_dir = constants.find_root_dir(".")

  local opts = {
    prompt_title = "~ rg grep string ~",
    search = '' ,  -- https://github.com/nvim-telescope/telescope.nvim/issues/564
    cwd = root_dir,
    vimgrep_arguments = constants.grep_cmds["rg"],
  }
  return builtin.grep_string(opts)
end
M.fallback_grep_string = function()
  if is_git() then
    return M.git_grep_string()
  else
    return M.rg_grep_string()
  end
end


-- Custom find file (defaulting to git files if is git)
M.fallback_grep_file = function(opts)
  opts = opts or {}
  if is_git(opts.cwd) then
    local default_opts = {prompt_title='~ git files ~', hidden=true}
    for k,v in pairs(default_opts) do opts[k] = v end
    return builtin.git_files(opts)
  else
    local default_opts = {prompt_title='~ files ~', hidden=true}
    for k,v in pairs(default_opts) do opts[k] = v end
    return builtin.find_files(opts)
  end
end


-- Dotfiles find file
M.wax_file = function()
  local opts = {
    prompt_title = "~ dotfiles waxdir ~",
    hidden=true,
    -- find_command="find",
    search_dirs={
      "~/src/waxcraft",
      "~/.config/nvim",
      -- Local not versioned in dotfiles:
      "~/.gitconfig",
      "~/.python_startup_local.py",
      "~/.zshrc",
    },
    layout_strategy = "vertical",
  }
  return builtin.find_files(opts)
end


-- Projects find file
M.projects_files = function()
  local scan = require('plenary.scandir')
  local Path = require('plenary.path')
  local os_sep = Path.path.sep

  local action_set = require('telescope.actions.set')
  local action_state = require('telescope.actions.state')
  local conf = require('telescope.config').values
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local make_entry = require('telescope.make_entry')
  local tele_path = require'telescope.path'

  local opts = {
    prompt_title = "~ projects files ~",
    cwd = "~/src",
    depth = 1,
  }

  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
  opts.new_finder = opts.new_finder or function(path)
    opts.cwd = path
    local data = {}

    scan.scan_dir(path, {
      hidden = opts.hidden or false,
      add_dirs = true,
      depth = opts.depth,
      on_insert = function(entry, typ)
        table.insert(data, typ == 'directory' and (entry .. os_sep) or entry)
      end
    })

    local entry_maker_fn = function()
      local gen = make_entry.gen_from_file(opts)
      return function(entry)
        local tmp = gen(entry)
        tmp.ordinal = tele_path.make_relative(entry, opts.cwd)
        return tmp
      end
    end

    return finders.new_table {
      results = data,
      entry_maker = entry_maker_fn()
    }
  end

  pickers.new(opts, {
    prompt_title = 'File Browser',
    finder = opts.new_finder(opts.cwd),
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      action_set.select:replace(function()
        local entry = action_state.get_selected_entry()
        local project = entry[1]
        actions.close(prompt_bufnr)
        M.fallback_grep_file({ cwd = project })
        vim.cmd(":normal! A")  -- small fix to be in insert mode
        return true
      end)

      return true
    end
  }):find()
end

-- Add all M commands to builtin for the builtin.builtin leader b search
for key, value in pairs(M) do
  builtin[key] = value
end


-- Fallback to builtin
return setmetatable({}, {
  __index = function(_, k)
    if M[k] then
      return M[k]
    else
      return require('telescope.builtin')[k]
    end
  end
})