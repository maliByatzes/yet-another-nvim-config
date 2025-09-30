local function hex2rgb(hex)
  return tonumber(hex:sub(2, 3), 16),
      tonumber(hex:sub(4, 5), 16),
      tonumber(hex:sub(6, 7), 16)
end

local function rgb2hex(r, g, b)
  return string.format('#%02X%02X%02X', r, g, b)
end

local function blend(c1, c2, alpha)
  local r1, g1, b1 = hex2rgb(c1)
  local r2, g2, b2 = hex2rgb(c2)

  local r = (1 - alpha) * r1 + alpha * r2
  local g = (1 - alpha) * g1 + alpha * g2
  local b = (1 - alpha) * b1 + alpha * b2

  return rgb2hex(r, g, b)
end

local colors = {
  foreground = '#dbd9ff',
  background = '#0e0d18',
  red = '#e464cb',
  orange = '#fab387',
  yellow = '#9e7ffe',
  cyan = '#52aae6',
}

local groups = {
  Normal                     = {
    fg = colors.foreground,
    bg = colors.background,
  },
  DiagnosticVirtualTextError = {
    fg = colors.red,
    bg = blend(colors.red, colors.background, .9),
  },
  DiagnosticVirtualTextWarn  = {
    fg = colors.orange,
    bg = blend(colors.orange, colors.background, .9),
  },
  DiagnosticVirtualTextInfo  = {
    fg = colors.yellow,
    bg = blend(colors.yellow, colors.background, .9),
  },
  DiagnosticVirtualTextHint  = {
    fg = colors.cyan,
    bg = blend(colors.cyan, colors.background, .9),
  },
}

return function()
  vim.o.background = 'dark'

  if vim.g.colors_name then
    vim.cmd('highlight clear')
  end

  vim.g.colors_name = 'user'

  if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
  end

  for _, group in ipairs(vim.fn.getcompletion('@lsp', 'highlight')) do
    vim.api.nvim_set_hl(0, group, {})
  end

  for name, opts in pairs(groups) do
    vim.api.nvim_set_hl(0, name, opts)
  end
end
