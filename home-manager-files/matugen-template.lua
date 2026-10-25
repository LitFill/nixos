local M = {}

function M.setup()
    require("base16-colorscheme").setup {
        -- Background tones (base00 transparent, base01/02 = overlay visible)
        base00 = "{{colors.surface.default.hex}}", -- Primary Background (will be overridden to NONE)
        base01 = "{{colors.surface_container_highest.default.hex}}", -- Lighter Background (Status bar, line number)
        base02 = "{{colors.surface_container_high.default.hex}}", -- Selection Background
        base03 = "{{colors.on_surface_variant.default.hex}}", -- Comments, Invisibles

        -- Foreground tones
        base04 = "{{colors.on_surface_variant.default.hex}}", -- Dark Foreground (Status bar text)
        base05 = "{{colors.on_surface.default.hex}}", -- Default Foreground
        base06 = "{{colors.inverse_on_surface.default.hex}}", -- Light Foreground
        base07 = "{{colors.on_background.default.hex}}", -- Lightest Foreground

        -- Accent colors — optimized for visibility on wallpaper
        base08 = "{{colors.error.default.hex}}", -- Variables, Errors
        base09 = "{{colors.tertiary_fixed.default.hex}}", -- Integers, Constants, Booleans
        base0A = "{{colors.secondary_fixed.default.hex}}", -- Classes, Search BG
        base0B = "{{colors.primary_fixed.default.hex}}", -- Strings
        base0C = "{{colors.secondary.default.hex}}", -- Regex, Escape Chars
        base0D = "{{colors.primary.default.hex}}", -- Functions, Methods
        base0E = "{{colors.tertiary.default.hex}}", -- Keywords
        base0F = "{{colors.primary_fixed_dim.default.hex}}", -- Deprecated / Tags
    }

    -- Bold and Italic definitions
    local bold = { bold = true }
    local italic = { italic = true }

    -- Transparency Overrides: Ensure the wallpaper is visible
    local transparency_groups = {
        "Normal",
        "NormalNC",
        "NormalFloat",
        "FloatBorder",
        "SignColumn",
        "LineNr",
        "CursorLineNr",
        "EndOfBuffer",
        "MsgArea",
        "WinBar",
        "WinBarNC",
        "Pmenu",
        "PmenuSel",
        "TelescopeNormal",
        "TelescopeBorder",
    }
    for _, group in ipairs(transparency_groups) do
        vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
    end

    -- Specific Highlights for better UI structure on transparent background
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "{{colors.outline.default.hex}}", bg = "NONE" })
    vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "PmenuSel", { bg = "{{colors.surface_container_high.default.hex}}", blend = 0 })

    -- Treesitter & Syntax refinement
    -- Keywords & structure
    vim.api.nvim_set_hl(0, "@keyword", bold)
    vim.api.nvim_set_hl(0, "@keyword.import", bold)
    vim.api.nvim_set_hl(0, "@module", bold)

    -- Types — especially important for Haskell
    vim.api.nvim_set_hl(0, "@type", bold)
    vim.api.nvim_set_hl(0, "@type.builtin", bold)
    vim.api.nvim_set_hl(0, "@type.qualifier", bold)
    vim.api.nvim_set_hl(0, "@constructor", bold)

    -- Type signatures and operators
    vim.api.nvim_set_hl(0, "@operator", bold)

    -- Italic for comments & metadata
    vim.api.nvim_set_hl(0, "@comment", italic)
    vim.api.nvim_set_hl(0, "@variable.parameter", italic)
    vim.api.nvim_set_hl(0, "@comment.documentation", italic)
    vim.api.nvim_set_hl(0, "@attribute", italic)
end

-- Register a signal handler for SIGUSR1 (matugen updates)
local signal = vim.uv.new_signal()
if signal then
    signal:start(
        "sigusr1",
        vim.schedule_wrap(function()
            package.loaded["matugen"] = nil
            require("matugen").setup()
        end)
    )
end

return M
