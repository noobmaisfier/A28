-- Aurora for NvChad/base46: palette of the aurora shell
-- (~/.iCode/kumizo theme.rs, entry "Aurora").
-- bg #0b0e14, accent #00e8c6, accent2 #8b7cff.

local M = {}

M.base_30 = {
  white         = "#e6edf7",
  black         = "#0b0e14",
  darker_black  = "#070a10",
  black2        = "#131824",
  one_bg        = "#1c2333",
  one_bg2       = "#232b40",
  one_bg3       = "#2e3a52",
  grey          = "#46546e",
  grey_fg       = "#6b7794",
  grey_fg2      = "#8b98b0",
  light_grey    = "#c3cede",
  red           = "#ff5c7a",
  baby_pink     = "#ff8fa3",
  pink          = "#f472a3",
  line          = "#232b40",
  green         = "#4ade80",
  vibrant_green = "#86efac",
  nord_blue     = "#7dd3fc",
  blue          = "#8b7cff",
  yellow        = "#fbbf24",
  sun           = "#fcd34d",
  purple        = "#a78bfa",
  dark_purple   = "#8b7cff",
  teal          = "#00e8c6",
  orange        = "#fb923c",
  cyan          = "#5eead4",
  statusline_bg = "#0b0e14",
  lightbg       = "#1c2333",
  pmenu_bg      = "#131824",
  folder_bg     = "#00e8c6",
}

M.base_16 = {
  base00 = "#0b0e14",
  base01 = "#131824",
  base02 = "#1c2333",
  base03 = "#46546e",
  base04 = "#6b7794",
  base05 = "#e6edf7",
  base06 = "#f2f7fd",
  base07 = "#ffffff",
  base08 = "#ff5c7a",
  base09 = "#fb923c",
  base0A = "#fbbf24",
  base0B = "#4ade80",
  base0C = "#00e8c6",
  base0D = "#8b7cff",
  base0E = "#a78bfa",
  base0F = "#5b2530",
}

M.type = "dark"

M = require("base46").override_theme(M, "aurora")

return M
