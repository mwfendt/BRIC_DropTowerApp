
-- BRIC Drop Tower App
-- Version: 0.01
-- decel.lua
-- Authors: Saul Flores & Marc Willis
-- Supervising Professor: Matthew Fendt
---------------------------------------------------------------------------------------

local widget = require( "widget" )

local gH = display.contentHeight
local gW = display.contentWidth

local M = {}

local animFrames = 0

function buttonHandler(event)
	if(animFrames == 0) then
		M:hide()
	end
end

function M:makeDisplay()
	dGroup = display.newGroup()
	--zoomed decel chamber image
	decelZoomed = display.newImageRect("images/DecelContainer.jpg", gW, gH)
	decelZoomed.x = display.contentCenterX
	decelZoomed.y = display.contentCenterY
	--rectangle to display text on
	decelTextBkg = display.newRect(gW * 0.5, gH * 0.125, gW, gH * 0.25)
	decelTextBkg:setFillColor(1,1,1,0.85)
	--text to display (shrink until it fits in the box)
	local i = 31
	repeat
		if(decelText ~= nil) then
			decelText:removeSelf()
		end
		i = i - 1
		decelText = display.newText(
			{
				text="Something kind of in the middle; long enough for a couple lines at 30 but not enough to knock it down.",
				x=decelTextBkg.x,
				y=decelTextBkg.y,
				width=decelTextBkg.width,
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until decelText.height <= decelTextBkg.height or i == 1
	decelText:setFillColor(0,0,0,1)
	--make back button
	backButton = widget.newButton(
	{
		id = "Back",
		x = display.contentCenterX,
		y = gH * 0.95,
		width = gW * 0.95,
		height = gH * 0.075,
		shape = "rectangle",
		fillColor = {default={.75, .75, .75, 1}, over={1,1,1,1}},
		strokeColor = {default={ .25 , .25, .25, 1}, over={ .50,.50,.50, 1 } },
		strokeWidth = 3,
		label = "Back",
		font = native.systemFont,
		fontSize = textSizeC,
		labelColor = {default = {0,0,0,1}, over = {0,0,0,1}},
		onRelease = buttonHandler
	})
	--insert all into group
	dGroup:insert(decelZoomed)
	dGroup:insert(decelTextBkg)
	dGroup:insert(decelText)
	dGroup:insert(backButton)
	dGroup.isVisible = false
	--set object variables (so they can be accessed elsewhere)
	self.dGroup = dGroup
end

function M:reveal()
	animFrames = 10
	self.dGroup.isVisible = true
	print("reveal")
end

function M:hide()
	animFrames = -10
	print("hide")
end

function M:enterFrame(event)
	if(animFrames > 0) then
		animFrames = animFrames - 1
		local newScale = 1 - (animFrames * 0.1)
		self.dGroup.xScale = newScale
		self.dGroup.yScale = newScale
		self.dGroup.x = display.contentCenterX * (1-newScale)
		self.dGroup.y = display.contentCenterY * (1-newScale)
		print(newScale)
	end
	if(animFrames < 0) then
		animFrames = animFrames + 1
		if(animFrames ~= 0) then
			local newScale = -1 * (animFrames * 0.1)
			self.dGroup.xScale = newScale
			self.dGroup.yScale = newScale
			self.dGroup.x = display.contentCenterX * (1-newScale)
			self.dGroup.y = display.contentCenterY * (1-newScale)
		else
			self.dGroup.isVisible = false
			appState = 0
			mainMenuButtons.isVisible = true
		end
		print(animFrames)
	end
end

Runtime:addEventListener( "enterFrame", M )

return M