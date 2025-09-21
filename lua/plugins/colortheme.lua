return {
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
      -- Core/editor
      hl.Normal         = { fg = c.fg,      bg = c.bg }
      hl.NormalNC       = { fg = c.fg_dark, bg = c.bg }
      hl.SignColumn     = { bg = c.bg }
      hl.EndOfBuffer    = { fg = c.bg }

      -- Cursorline & Visual
      hl.CursorLine     = { bg = "#121923" }
      hl.CursorLineNr   = { fg = "#e2e8f0", bold = true }
      hl.Visual         = { bg = "#26324a" }

      -- Split bars / separators
      local sep = "#1e2633"
      hl.WinSeparator   = { fg = sep, bg = c.bg }
      hl.VertSplit      = { fg = sep, bg = c.bg }

      -- Statusline
      hl.StatusLine     = { fg = c.fg,      bg = c.bg_dark }
      hl.StatusLineNC   = { fg = c.fg_dark, bg = c.bg_dark }

      -- Floats/menus
      hl.NormalFloat    = { fg = c.fg, bg = c.bg_dark }
      hl.FloatBorder    = { fg = sep,  bg = c.bg_dark }
      hl.Pmenu          = { fg = c.fg, bg = c.bg_dark }
      hl.PmenuSel       = { bg = "#1a2240", bold = true }

      -- Telescope
      hl.TelescopeNormal = { fg = c.fg, bg = c.bg_dark }
      hl.TelescopeBorder = { fg = sep,  bg = c.bg_dark }

      -- Search
      hl.Search         = { fg = "#000000", bg = "#eab308" }
      hl.IncSearch      = { fg = "#000000", bg = "#22d3ee", bold = true }

      -- Diagnostics
      hl.DiagnosticVirtualTextError = { fg = "#fca5a5", bg = "#311a1a" }
      hl.DiagnosticVirtualTextWarn  = { fg = "#fde68a", bg = "#2e2815" }
      hl.DiagnosticVirtualTextInfo  = { fg = "#93c5fd", bg = "#152234" }
      hl.DiagnosticVirtualTextHint  = { fg = "#a7f3d0", bg = "#0f2a23" }

      -- Neo-tree
      hl.NeoTreeNormal       = { fg = c.fg_dark, bg = c.bg_dark }
      hl.NeoTreeNormalNC     = { fg = c.fg_dark, bg = c.bg_dark }
      hl.NeoTreeWinSeparator = { fg = sep,       bg = c.bg_dark }
      hl.NeoTreeCursorLine   = { bg = "#172131" }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight-night")

    -- === Transparent background toggle ===
    local bg      = "#0d1117"  -- keep in sync with on_colors
    local bg_dark = "#0b0f14"

    local trans_groups = {
      "Normal", "NormalNC", "SignColumn", "EndOfBuffer",
      "NeoTreeNormal", "NeoTreeNormalNC",
    }

    local function set_bg(group, color)
      local ok, cur = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
      local new = { fg = cur and cur.fg or nil, bg = color }
      vim.api.nvim_set_hl(0, group, new)
    end

    local function apply_transparent(on)
      if on then
        for _, g in ipairs(trans_groups) do set_bg(g, "NONE") end
      else
        -- restore solids
        set_bg("Normal",      bg)
        set_bg("NormalNC",    bg)
        set_bg("SignColumn",  bg)
        vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = bg }) -- match background
        set_bg("NeoTreeNormal",   bg_dark)
        set_bg("NeoTreeNormalNC", bg_dark)
      end
    end

    -- state + reapply after any colorscheme switch
    vim.g.transparent_bg = true  -- start transparent (change to false if you want solid on start)
    apply_transparent(vim.g.transparent_bg)
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function() apply_transparent(vim.g.transparent_bg) end,
    })

  end,
}

