-- Edit colorscheme
--
-- Use this file to override color themes.
require("colorbuddy")

local colorbuddy = require('colorbuddy')
local Color = colorbuddy.Color
local Group = colorbuddy.Group
local c = colorbuddy.colors
local g = colorbuddy.groups
local s = colorbuddy.styles

Color.new('green', '#77ff77')
Group.new('Comment', c.green, nil, s.italic)
