
-- BRIC Drop Tower App
-- Version: 0.01
-- fixit.lua
---------------------------------------------------------------------------------------

local widget = require( "widget" )

local gH = display.contentHeight
local gW = display.contentWidth

local M = {}

function M:makeDisplay()
	dGroup = display.newGroup()
	local bkg = display.newRect(display.contentCenterX, display.contentCenterY, gW, gH)
	bkg:setFillColor(0.3, 0.5, 0.9, 1)
	self.dGroup = dGroup
end

function M:invisible()
	dGroup.visible = false
end

return M