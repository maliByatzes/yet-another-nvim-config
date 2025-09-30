local FilePath = function()
  local conditions = require('heirline.conditions')
  return {
    init = function(self)
      self.filename = vim.api.nvim_buf_get_name(0)
    end,
    provider = function(self)
      -- First, trim the pattern relative to the current
      -- directory. For other options, see `:h
      -- filename-modifiers`.
      local filename = vim.fn.fnamemodify(self.filename, ':.')
      if filename == '' then return '[No Name]' end
      -- Now, if the filename would occupy more than 1/4th of
      -- the available space, we trim the file path to its
      -- initials.
      if not conditions.width_percent_below(#filename, 0.25) then
        filename = vim.fn.pathshorten(filename)
      end
      return filename
    end,
  }
end

local GitBranch = function()
  local conditions = require('heirline.conditions')
  return {
    condition = conditions.is_git_repo,

    init = function(self)
      ---@diagnostic disable-next-line:undefined-field
      self.status_dict = vim.b.gitsigns_status_dict
    end,

    -- git branch name
    provider = function(self)
      local branch = self.status_dict.head
      if branch == nil or branch == '' then
        branch = 'master'
      end
      return '   ' .. branch
    end,
  }
end

local Diagnostics = function()
  local conditions = require('heirline.conditions')
  return {
    condition = conditions.has_diagnostics,
    update = { 'DiagnosticChanged', 'BufEnter', 'WinEnter', 'WinLeave' },

    init = function(self)
      self.errors = #vim.diagnostic.get(nil, {
        severity = vim.diagnostic.severity.ERROR,
      })
      self.warnings = #vim.diagnostic.get(nil, {
        severity = vim.diagnostic.severity.WARN,
      })
      self.hints = #vim.diagnostic.get(nil, {
        severity = vim.diagnostic.severity.HINT,
      })
      self.info = #vim.diagnostic.get(nil, {
        severity = vim.diagnostic.severity.INFO,
      })
    end,

    {
      provider = ' ',
    },
    {
      condition = function(self)
        return self.errors > 0
      end,
      provider = function(self)
        return '  ' .. self.errors
      end,
      hl = function()
        return conditions.is_active() and { fg = 'diag_error' } or {}
      end,
    },
    {
      condition = function(self)
        return self.warnings > 0
      end,
      provider = function(self)
        return '  ' .. self.warnings
      end,
      hl = function()
        return conditions.is_active() and { fg = 'diag_warn' } or {}
      end,
    },
    {
      condition = function(self)
        return self.info > 0
      end,
      provider = function(self)
        return '  ' .. self.info
      end,
      hl = function()
        return conditions.is_active() and { fg = 'diag_info' } or {}
      end,
    },
    {
      condition = function(self)
        return self.hints > 0
      end,
      provider = function(self)
        return '  ' .. self.hints
      end,
      hl = function()
        return conditions.is_active() and { fg = 'diag_hint' } or {}
      end,
    },
  }
end

local LspServer = function()
  local conditions = require('heirline.conditions')
  return {
    condition = conditions.lsp_attached,
    update    = { 'LspAttach', 'LspDetach', 'WinEnter', 'WinLeave' },
    provider  = function()
      local names = {}
      for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
        table.insert(names, server.name)
      end
      return ' ' .. table.concat(names, ', ') .. '  '
    end,
  }
end

return {
  'rebelot/heirline.nvim',
  opts = function()
    local conditions = require('heirline.conditions')
    local hutils = require('heirline.utils')

    local get_colors = function()
      return {
        StatusLine = hutils.get_highlight('StatusLine'),
        StatusLineNC = hutils.get_highlight('StatusLineNC'),
        diag_error = hutils.get_highlight('DiagnosticError').fg,
        diag_warn = hutils.get_highlight('DiagnosticWarn').fg,
        diag_info = hutils.get_highlight('DiagnosticInfo').fg,
        diag_hint = hutils.get_highlight('DiagnosticHint').fg,
      }
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("Heirline", { clear = true }),
      desc = "Refresh heirline colors",
      callback = function()
        hutils.on_colorscheme(get_colors)
      end,
    })

    return {
      opts = {
        colors = get_colors(),
      },
      statusline = {
        hl = function()
          if conditions.is_active() then
            return 'StatusLine'
          end
          return 'StatusLineNC'
        end,
        {
          provider = '%<'
        },
        FilePath(),
        {
          provider = '%( %h%m%r%)'
        },
        GitBranch(),
        Diagnostics(),
        {
          provider = '  %=',
        },
        LspServer(),
        {
          provider = '%<%f %h%m%r%=%-14.(%l,%c%V%) %P'
        },
      },
    }
  end,
}
