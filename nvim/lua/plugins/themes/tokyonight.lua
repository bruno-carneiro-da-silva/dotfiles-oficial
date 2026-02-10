return {
  "folke/tokyonight.nvim",
  lazy = false, -- carrega logo na inicialização
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "moon",          -- opções: storm, moon, night, day
      transparent = true,     -- fundo transparente (você já gosta)
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "transparent",
        floats = "transparent",
      },
      sidebars = { "qf", "help", "vista_kind", "terminal", "packer" },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = true,

      on_highlights = function(hl, c)
        -- Deixa o fundo dos diagnostics transparente também
        local prompt = "#2d3149"
        hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg }
        hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
        hl.TelescopePromptNormal = { bg = prompt }
        hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
        hl.TelescopePromptTitle = { bg = c.purple, fg = c.bg }
        hl.TelescopePreviewTitle = { bg = c.blue, fg = c.bg }
        hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }

        -- Diagnostics transparentes
        hl.DiagnosticVirtualTextError = { bg = nil, fg = c.error }
        hl.DiagnosticVirtualTextWarn  = { bg = nil, fg = c.warning }
        hl.DiagnosticVirtualTextInfo  = { bg = nil, fg = c.info }
        hl.DiagnosticVirtualTextHint  = { bg = nil, fg = c.hint }
      end,
    })

    vim.cmd([[colorscheme tokyonight-moon]])

    -- Toggle de transparência (mantendo seu atalho antigo <leader>bg)
    local toggle_transparency = function()
      local current = require("tokyonight.config").options.transparent
      require("tokyonight").setup({ transparent = not current })
      vim.cmd("colorscheme tokyonight-moon")
    end

    vim.keymap.set("n", "<leader>bg", toggle_transparency, { desc = "Toggle background transparency" })
  end,
}
