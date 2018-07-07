
-- BRIC Drop Tower App
-- Version: 0.01
-- physicsgame.lua
-- Authors: Saul Flores & Marc Willis
-- Supervising Professor: Matthew Fendt
---------------------------------------------------------------------------------------

local widget = require( "widget" )

local gH = display.contentHeight
local gW = display.contentWidth

local M = {}

local animFrames = 0
local ballVelocity = 1

function buttonHandler(event)
	if(animFrames == 0) then
		M:hide()
	end
end

function ballHandler(event)
	
end
--main display function
function M:makeDisplay()

	local dGroup = display.newGroup()
	
	-----------------
	-- BACK BUTTON --
	-----------------
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
	
	--drop button
	
	dropButton = widget.newButton(
	{
		id = "Drop",
		x = display.contentCenterX * 1.65,
		y = gH * 0.85,
		width = gW * 0.25,
		height = gH * 0.075,
		shape = "rectangle",
		fillColor = {default={.75, .75, .75, 1}, over={1,1,1,1}},
		strokeColor = {default={ .25 , .25, .25, 1}, over={ .50,.50,.50, 1 } },
		strokeWidth = 3,
		label = "Drop",
		font = native.systemFont,
		fontSize = 16,
		labelColor = {default = {0,0,0,1}, over = {0,0,0,1}},
		--onRelease = ballHandler
	})
	
	-- start button
	
	startButton = widget.newButton(
	{
		id = "Start",
		x = display.contentCenterX * 0.35,
		y = gH * 0.85,
		width = gW * 0.25,
		height = gH * 0.075,
		shape = "rectangle",
		fillColor = {default={.75, .75, .75, 1}, over={1,1,1,1}},
		strokeColor = {default={ .25 , .25, .25, 1}, over={ .50,.50,.50, 1 } },
		strokeWidth = 3,
		label = "Start",
		font = native.systemFont,
		fontSize = 16,
		labelColor = {default = {0,0,0,1}, over = {0,0,0,1}},
		--onRelease = ballHandler
	})
	--physics game background container background 
	physBkg = display.newRect(display.contentCenterX, display.contentCenterY, gW, gH)
	physBkg:setFillColor(.3, .5, .9, 1)

	-- catch box outline
	catchBoxOut = display.newRect(display.contentCenterX, display.contentCenterY * 1.55, gW * 0.27, gH * 0.25)
	catchBoxOut:setFillColor(1,1,1,1)
	
	-- catch box 
	catchBox = display.newRect(display.contentCenterX, display.contentCenterY * 1.54, gW * 0.25, gH * 0.25)
	catchBox:setFillColor(0.3, .5, .9, 1)
	
	-- slider on top
	slider = display.newRect(display.contentCenterX, display.contentCenterY * 0.075, gW * 0.25, gH * 0.03)
	slider:setFillColor(0,0,0,1)
	
	--ball holder 
	holder = display.newRect(display.contentCenterX, display.contentCenterY * 0.10, gW * 0.01, gH * 0.02)
	holder:setFillColor(0,0,0,1)
	
	--ball
	ball = display.newCircle(display.contentCenterX, display.contentCenterY * 0.19, display.contentCenterY * 0.07)
	ball:setFillColor(1,0,0,1)
	
	instructionsText = display.newText( "Click start to begin.", display.contentCenterX, display.contentCenterY * .90, native.systemFont, 30)
	instructionsText.width = gW * 0.8
	instructionsText:setFillColor( 0.7, 0.7, 1 )
	
	instructionsText2 = display.newText( "One minute to get as many balls in the deceleration container!", display.contentCenterX, display.contentCenterY, native.systemFont, 10)
	instructionsText2.width = gW * 0.8
	instructionsText2:setFillColor( 0.7, 0.7, 1 )
	
	--insert all components of the page into the group
	dGroup:insert(physBkg)
	dGroup:insert(backButton)
	dGroup:insert(catchBoxOut)
	dGroup:insert(catchBox)
	dGroup:insert(slider)
	dGroup:insert(holder)
	dGroup:insert(ball)
	dGroup:insert(dropButton)
	dGroup:insert(startButton)
	dGroup:insert(instructionsText)
	dGroup:insert(instructionsText2)
	dGroup.isVisible = false
	self.dGroup = dGroup
end

--function to reveal this page
function M:reveal()
	animFrames = 10
	self.dGroup.isVisible = true
	print("reveal")
end

--function to hide this page
function M:hide()
	animFrames = -10
	print("hide")
end

--function to zoom in/out
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