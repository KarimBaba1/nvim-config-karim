require 'core.options'
require 'core.keymaps'


-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
	if vim.v.shell_error ~= 0 then
		error('Error cloning lazy.nvim:\n' .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
  },
{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    transparent = false,
    terminal_colors = true,
    dim_inactive = false,
    styles = {
      comments = { italic = false },
      keywords = { italic = false },
      sidebars = "dark",
      floats   = "dark",
    },
    on_colors = function(c)
      c.bg       = "#0d1117"
      c.bg_dark  = "#0b0f14"
      c.bg_float = c.bg_dark
      c.border   = c.bg_dark
      c.fg       = "#cfe1ff"
      c.fg_dark  = "#b9c7f5"
      c.comment  = "#9aa6b2"
    end,
on_highlights = function(hl, c)
  -- === Core/editor ===
  hl.Normal         = { fg = c.fg,      bg = c.bg }
  hl.NormalNC       = { fg = c.fg_dark, bg = c.bg }
  hl.SignColumn     = { bg = c.bg }
  hl.EndOfBuffer    = { fg = c.bg }

  -- Cursorline: slightly lighter than bg so it’s always visible
  hl.CursorLine     = { bg = "#121923" }              -- was #10161d
  hl.CursorLineNr   = { fg = "#e2e8f0", bold = true }

  -- Visual selection: more contrast, still easy on eyes
  hl.Visual         = { bg = "#26324a" }              -- was #1a2230

  -- === Split bars / window separators ===
  -- Use a distinct, darker steel-blue so it shows on both bg and bg_dark
  local sep = "#1e2633"
  hl.WinSeparator   = { fg = sep, bg = c.bg }         -- editor splits
  hl.VertSplit      = { fg = sep, bg = c.bg }         -- some plugins still read VertSplit

  -- Statusline
  hl.StatusLine     = { fg = c.fg,      bg = c.bg_dark }
  hl.StatusLineNC   = { fg = c.fg_dark, bg = c.bg_dark }

  -- === Floats/menus ===
  hl.NormalFloat    = { fg = c.fg, bg = c.bg_dark }
  hl.FloatBorder    = { fg = sep,  bg = c.bg_dark }
  hl.Pmenu          = { fg = c.fg, bg = c.bg_dark }
  hl.PmenuSel       = { bg = "#1a2240", bold = true }

  -- === Telescope (if used) ===
  hl.TelescopeNormal = { fg = c.fg, bg = c.bg_dark }
  hl.TelescopeBorder = { fg = sep,  bg = c.bg_dark }

  -- === Search (high-contrast) ===
  hl.Search         = { fg = "#000000", bg = "#eab308" }
  hl.IncSearch      = { fg = "#000000", bg = "#22d3ee", bold = true }

  -- === Diagnostics (legible virtual text) ===
  hl.DiagnosticVirtualTextError = { fg = "#fca5a5", bg = "#311a1a" }
  hl.DiagnosticVirtualTextWarn  = { fg = "#fde68a", bg = "#2e2815" }
  hl.DiagnosticVirtualTextInfo  = { fg = "#93c5fd", bg = "#152234" }
  hl.DiagnosticVirtualTextHint  = { fg = "#a7f3d0", bg = "#0f2a23" }

  -- === Neo-tree ===
  hl.NeoTreeNormal       = { fg = c.fg_dark, bg = c.bg_dark }
  hl.NeoTreeNormalNC     = { fg = c.fg_dark, bg = c.bg_dark }
  hl.NeoTreeWinSeparator = { fg = sep,       bg = c.bg_dark } -- make bar visible in the sidebar
  -- a dedicated cursorline for Neo-tree (mapped via autocmd below)
  hl.NeoTreeCursorLine   = { bg = "#172131" }                -- slightly different from editor to stand out
end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight-night")
  end,
}
})
--karimtestinglink
