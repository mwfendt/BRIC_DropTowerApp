
-- BRIC Drop Tower App
-- Version: 0.01
-- netting.lua
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
	--zoomed netting image
	nettingZoomed = display.newImageRect("images/Netting.jpg", gW, gH)
	nettingZoomed.x = display.contentCenterX
	nettingZoomed.y = display.contentCenterY
	--rectangle to display text on
	nettingTextBkg = display.newRect(gW * 0.5, gH * 0.125, gW, gH * 0.25)
	nettingTextBkg:setFillColor(1,1,1,0.85)
	--text to display (shrink until it fits in the box)
	local i = 31
	repeat
		if(nettingText ~= nil) then
			nettingText:removeSelf()
		end
		i = i - 1
		nettingText = display.newText(
			{
				text="This is test text. It is going to be a lot of test text. This is test text. It is going to be a lot of test text. This is test text. It is going to be a lot of test text. This is test text. It is going to be a lot of test text. This is test text. It is going to be a lot of test text. This is test text. It is going to be a lot of test text. This is test text. It is going to be a lot of test text. This is test text. It is going to be a lot of test text. This is test text. It is going to be a lot of test text. This is test text. It is going to be a lot of test text. This is test text. It is going to be a lot of test text. This is test text. It is going to be a lot of test text.",
				x=nettingTextBkg.x,
				y=nettingTextBkg.y,
				width=nettingTextBkg.width,
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until nettingText.height <= nettingTextBkg.height or i == 1
	nettingText:setFillColor(0,0,0,1)
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
		fontSize = 16,
		labelColor = {default = {0,0,0,1}, over = {0,0,0,1}},
		onRelease = buttonHandler
	})
	--insert all into group
	dGroup:insert(nettingZoomed)
	dGroup:insert(nettingTextBkg)
	dGroup:insert(nettingText)
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