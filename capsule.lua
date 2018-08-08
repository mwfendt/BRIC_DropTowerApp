
-- BRIC Drop Tower App
-- Version: 0.01
-- capsule.lua
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
	--zoomed drop capsule image
	dropCapZoomed = display.newImageRect("images/DropCapsule.jpg", gW, gH)
	dropCapZoomed.x = display.contentCenterX
	dropCapZoomed.y = display.contentCenterY
	--rectangle to display text on
	dropCapTextBkg = display.newRect(gW * 0.5, gH * 0.125, gW, gH * 0.25)
	dropCapTextBkg:setFillColor(1,1,1,0.85)
	--text to display (shrink until it fits in the box)
	local i = 31
	repeat
		if(dropCapText ~= nil) then
			dropCapText:removeSelf()
		end
		i = i - 1
		dropCapText = display.newText(
			{
				text="The drop capsule has two separate pieces: the inner layer and the outer layer. The outer layer is designed to reduce air resistance so that the inner layer can experience microgravity closer to true weightlessness. The inner capsule is not physically connected to the outer layer so that it can experience free fall without being slowed down by air resistance like the outer layer is. Thus the inner layer is where the experiments are housed.",
				x=dropCapTextBkg.x,
				y=dropCapTextBkg.y, --change to align top?
				width=dropCapTextBkg.width,
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until dropCapText.height <= dropCapTextBkg.height or i == 1
	dropCapText:setFillColor(0,0,0,1)
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
	dGroup:insert(dropCapZoomed)
	dGroup:insert(dropCapTextBkg)
	dGroup:insert(dropCapText)
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