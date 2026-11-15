local wezterm = require "wezterm"

-- Function to load colors from Noctalia's json
-- local function get_noctalia_colors()
--     -- wezterm.home_dir provides the absolute path to the user's home directory
--     local colors_path = wezterm.home_dir .. "/.config/noctalia/colors.json"
--     local handle = io.open(colors_path, "r")
--     if not handle then
--         wezterm.log_error("Noctalia colors not found at: " .. colors_path)
--         return nil
--     end
--     local content = handle:read "*a"
--     handle:close()
--     -- wezterm.json_parse is a built-in utility to parse JSON
--     local colors, err = wezterm.json_parse(content)
--     if not colors then
--         wezterm.log_error("Failed to parse noctalia colors.json: " .. err)
--         return nil
--     end
--     return colors
-- end

---@class Wezterm
---@field action WeztermAction
---@field action_callback fun (action: fun (window: Window, pane: Pane)): Action
---@field config_builder fun (): Config
---@field font fun (font_name: string, opts?: {}): string
---@field font_with_fallback fun (fonts: string[]): string
---@field home_dir string
---@field mux MuxManager
---@field plugin PluginManager

---@class WeztermAction
---@field CloseCurrentPane fun (opt: {confirm: boolean}): Action

---@class PluginManager
---@field require fun (plugin_repo: string): Plugin

---@class MuxManager
---@field get_pane fun (id): Pane

---@class Plugin
---@field apply_to_config fun (config: Config)
---@field setup fun ()

---@class Pane
---@field activate fun ()
---@field current_working_dir { file_path: string }
---@field get_current_working_dir fun (): { file_path: string }
---@field is_zoomed  boolean
---@field pane_id    integer
---@field process_id integer
---@field pty_id     string
---@field send_text fun (self: Pane, text: string)
---@field split fun (self: Pane, opt: SplitPaneOpt): Pane
---@field tab_id     integer
---@field title      string
---@field window_id  integer
---@field workspace  string

---@class SplitPaneOpt
---@field args      string[]?
---@field command   string[]?
---@field direction "Top" | "Bottom" | "Right" | "Left"
---@field size      number?

---@class Tab
---@field active_pane Pane
---@field is_zoomed fun (): boolean -- Added for clarity if needed, check Wezterm API
---@field panes       Pane[]
---@field panes_with_info fun (): { pane: Pane, is_active: boolean }[]
---@field set_zoomed fun (self: Tab, zoomed: boolean): boolean -- Returns previous state
---@field tab_id      integer
---@field window_id   integer

---@class Window
---@field active_tab fun (): Tab
---@field gui_window any -- Type depends on OS
---@field tabs       Tab[]
---@field window_id  integer

---@class ConfigKeyBind
---@field action Action
---@field key    string
---@field mods   string

---@class Action

---@class Config
---@field colors                       table
---@field color_scheme                 string
---@field default_prog                 string[]
---@field enable_tab_bar               boolean
---@field font                         string
---@field hide_tab_bar_if_only_one_tab boolean
---@field keys                         ConfigKeyBind[]
---@field tab_bar_at_bottom            boolean
---@field window_background_opacity    number
---@field win32_system_backdrop "Auto" | "Disable" | "Acrylic" | "Mica" | "Tabbed"
---@field window_decorations    "NONE" | "TITLE" | "RESIZE" | "TITLE | RESIZE"
local config = wezterm.config_builder()

-- Try to apply Noctalia colors
-- local noctalia_colors = get_noctalia_colors()
-- if noctalia_colors then
--     config.colors = {
--         background = noctalia_colors.mSurface,
--         foreground = noctalia_colors.mOnSurface,
--
--         cursor_bg = noctalia_colors.mPrimary,
--         cursor_fg = noctalia_colors.mOnPrimary,
--         cursor_border = noctalia_colors.mPrimary,
--
--         selection_bg = noctalia_colors.mSecondary,
--         selection_fg = noctalia_colors.mOnSecondary,
--
--         compose_cursor = noctalia_colors.mTertiary,
--
--         split = noctalia_colors.mOutline,
--
--         -- ANSI colors
--         ansi = {
--             noctalia_colors.mSurfaceVariant, -- Black
--             noctalia_colors.mError,          -- Red
--             noctalia_colors.mSecondary,      -- Green
--             noctalia_colors.mTertiary,       -- Yellow
--             noctalia_colors.mPrimary,        -- Blue
--             noctalia_colors.mSecondary,      -- Magenta
--             noctalia_colors.mPrimary,        -- Cyan
--             noctalia_colors.mOnSurface,      -- White
--         },
--         -- Bright ANSI colors
--         brights = {
--             noctalia_colors.mSurfaceVariant, -- Bright Black
--             noctalia_colors.mError,          -- Bright Red
--             noctalia_colors.mSecondary,      -- Bright Green
--             noctalia_colors.mTertiary,       -- Bright Yellow
--             noctalia_colors.mPrimary,        -- Bright Blue
--             noctalia_colors.mSecondary,      -- Bright Magenta
--             noctalia_colors.mPrimary,        -- Bright Cyan
--             noctalia_colors.mOnSurface,      -- Bright White
--         },
--     }
-- end

-- config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
-- config.font = wezterm.font(
--     "MonaspiceRn Nerd Font Propo",
--     { weight = "Regular", stretch = "Normal", style = "Normal" }
-- ) -- (AKA: MonaspiceRn NFP) /home/litfill/.nix-profile/share/fonts/opentype/NerdFonts/Monaspice/MonaspiceRnNerdFontPropo-Italic.otf, FontConfig

config.default_prog = { "nu" }

config.window_decorations = "NONE"
config.window_background_opacity = 0.75
config.tab_bar_at_bottom = false

config.adjust_window_size_when_changing_font_size = false
config.use_resize_increments = false
config.enable_wayland = false

config.enable_kitty_keyboard = true

---@param window Window
---@param pane   Pane
local function toggle_terminal(window, pane)
    local tab = window:active_tab()
    local panes = tab:panes_with_info()
    local cwd = pane:get_current_working_dir().file_path
    local cmd = "j " .. cwd .. "\n"

    local other_pane = nil

    for _, p in ipairs(panes) do
        if not p.is_active then
            other_pane = p.pane
        end
    end

    if #panes == 1 then
        other_pane = pane:split {
            direction = "Bottom",
            size = 0.2,
        }
        if not cmd:match "/mnt/c" then
            other_pane:send_text(cmd)
        end

        other_pane:activate()
    else
        if other_pane then
            other_pane:activate()
        end
        tab:set_zoomed(not tab:set_zoomed(false))
    end
end

config.keys = {
    {
        key = ";",
        mods = "CTRL",
        action = wezterm.action_callback(toggle_terminal),
    },
    {
        key = "q",
        mods = "CTRL|ALT",
        action = wezterm.action.CloseCurrentPane {
            confirm = true,
        },
    },
}

-- Plugins

local add_plugin = wezterm.plugin.require

local tabline = add_plugin "https://github.com/michaelbrusegard/tabline.wez"
tabline.setup()
tabline.apply_to_config(config)

return config
