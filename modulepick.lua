
-- BRIC Drop Tower App
-- Version: 0.01
-- modulepick.lua
-- Authors: Saul Flores & Marc Willis
-- Supervising Professor: Matthew Fendt
---------------------------------------------------------------------------------------

local widget = require( "widget" )

local gH = display.contentHeight
local gW = display.contentWidth

local labels = {}

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

local function labelButtonHandler (event)
	--print("test")
	for index,label in pairs(labels) do
		label:setFillColor(0.75, 0.75, 0.75, 1)
	end
	event.target.labelChange:setFillColor(1,1,1,1)
	moduleInfoText.text = event.target.textChange
end

function M:makeRow(rowTitle, rowTarget, rowY, description, group)
	--row label text
	rowText = display.newText(
		{
			text = rowTitle,
			x = gW * 0.385,
			width = gW * 0.75,
			align = "left",
			y = rowY,
			font = native.systemFont,
			fontSize = textSizeC,
		})
	rowText:setFillColor(0.75, 0.75, 0.75, 1)
	group:insert(rowText)
	
	table.insert(labels, rowText)
	
	--(mostly) invisible label row button
	labelButton = widget.newButton(
		{
			id = "label",
			x = gW * 0.385,
			y = rowY,
			width = gW * 0.75,
			height = gH * 0.06,
			shape = "rect",
			fillColor = { default = {1,1,1,0.01}, over = {1,1,1,0.01} },
			onRelease = labelButtonHandler
		})
	group:insert(labelButton)
	labelButton.textChange = description
	labelButton.labelChange = rowText

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