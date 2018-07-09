
-- BRIC Drop Tower App
-- Version: 0.01
-- modulepick.lua
-- Authors: Saul Flores & Marc Willis
-- Supervising Professor: Matthew Fendt
---------------------------------------------------------------------------------------

local widget = require( "widget" )

local gH = display.contentHeight
local gW = display.contentWidth

local M = {}

local function moduleButtonHandler (event)
	if(event.target.offTarget.isVisible) then
		event.target.flipTarget.isVisible = true
		event.target.offTarget.isVisible = false
	else
		event.target.flipTarget.isVisible = false
		event.target.offTarget.isVisible = true
	end
end

--converts a height in pixels to the equivalent pt value for text
--may need some fine-tuning
local function px2pt( pixels )
	return pixels * 0.75
end

function M:makeRow(rowTitle, rowTarget, rowY, group)
	rowText = display.newText(
		{
			text = rowTitle,
			x = gW * 0.385,
			width = gW * 0.75,
			align = "left",
			y = rowY,
			font = native.systemFont,
			fontSize = math.floor(px2pt(gH * 0.05)),
		})
	rowText:setFillColor(0.75, 0.75, 0.75, 1)
	group:insert(rowText)

	--Off label
	rowOff = display.newImageRect("images/OFF.png", gW * 0.2, gW * 0.1)
	rowOff.x = gW * 0.875
	rowOff.y = rowY

	--button
	rowButton = widget.newButton(
		{
			id = "row",
			x = gW * 0.875,
			y = rowY,
			width = gW * 0.2,
			height = gW * 0.1,
			defaultFile = "images/ON.png",
			onRelease = moduleButtonHandler,
		})
	rowButton.flipTarget = rowTarget
	rowButton.offTarget = rowOff
	group:insert(rowButton)
	group:insert(rowOff)
	rowOff.isVisible = not rowTarget.isVisible
end

return M