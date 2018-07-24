
-- BRIC Drop Tower App
-- Version: 0.01
-- physicsgame.lua
-- Authors: Saul Flores & Marc Willis
-- Supervising Professor: Matthew Fendt
---------------------------------------------------------------------------------------

local widget = require( "widget" )
local physics = require("physics")

local gH = display.contentHeight
local gW = display.contentWidth

local M = {}

local animFrames = 0
local ballVelocity = 1

--[[
local function updateTime(event)
	count = count - 1
	timeDisplay = string.format("%02d", count)
	clockText.text = timeDisplay
	if(count <= 0) then
	timer.cancel(countDownTimer)
	print("here")
	gameGroup.isVisible = true
	gameGroup.animFrames = 10
	end
end
]]--

function buttonHandler(event)
	if("GravOnOff" == event.target.id) then
		if(gravButton:getLabel() == "Gravity:\n On")then
			gravButton:setLabel("Gravity:\n Off")
			physics.setGravity(0,0)
			print("here")
		elseif(gravButton:getLabel() == "Gravity:\n Off")then
			gravButton:setLabel("Gravity:\n On")
			physics.setGravity(0,9.8)
		end
	elseif(animFrames == 0) then
		M:hide()
	end
end

--main display function
function M:makeDisplay()

	local dGroup = display.newGroup()
	
	gameGroup = display.newGroup()
	-----------------
	-- BACK BUTTON --
	-----------------
	--make back button
	backButton = widget.newButton(
	{
		id = "Back",
		x = display.contentCenterX,
		y = gH * 0.95,
		width = gW * 0.5,
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
	
	gravButton = widget.newButton(
	{
		id = "GravOnOff",
		x = display.contentCenterX * .25,
		y = gH * 0.95,
		width = gW * 0.15,
		height = gH * 0.075,
		shape = "rectangle",
		fillColor = {default={.75, .75, .75, 1}, over={1,1,1,1}},
		strokeColor = {default={ .25 , .25, .25, 1}, over={ .50,.50,.50, 1 } },
		strokeWidth = 3,
		label = "Gravity:\n On",
		font = native.systemFont,
		fontSize = 10,
		labelColor = {default = {0,0,0,1}, over = {0,0,0,1}},
		onRelease = buttonHandler
	})
	
	darkenerButton = widget.newButton(
		{
			id = "Darkener",
			x = display.contentCenterX,
			y = display.contentCenterY,
			width = gW,
			height = gH,
			shape = "rectangle",
			fillColor = { default={ 0,0,0,0.85 }, over={ 0,0,0,0.85 } },
			onRelease = buttonHandler
		})
	
	--create box for text to appear on
	gameOverBox = display.newRect(display.contentCenterX, display.contentCenterY, gW * 0.8, gH * 0.25)
	gameOverBox:setFillColor(1, 1, 1, 1)
	gameOverBox.strokeWidth = 3
	gameOverBox:setStrokeColor(1,0,0,1)
	--create text and shrink to box
	i = 31
	repeat
		if(gameOverText ~= nil) then
			gameOverText:removeSelf()
		end
		i = i - 1
		gameOverText = display.newText(
			{
				text="Score: 0\n Click to go to main menu!",
				x=gameOverBox.x,
				y=gameOverBox.y,
				width=gameOverBox.width - 6, --keep inside the lines
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until gameOverText.height <= gameOverBox.height or i == 1
	gameOverText:setFillColor(1,0,0,1)
	
	gameGroup:insert(darkenerButton)
	gameGroup:insert(gameOverBox)
	gameGroup:insert(gameOverText)
	gameGroup.isVisible = false
	gameGroup.alpha = 0.01
	--set up fade in animation
	gameGroup.animFrames = 0
	function gameGroup:enterFrame(event)
		if(self.animFrames > 0) then
			self.animFrames = self.animFrames - 1
			self.alpha = 1 - (self.animFrames * 0.05)
		elseif(self.animFrames < 0) then
			self.animFrames = self.animFrames + 1
			self.alpha = (self.animFrames * -0.05)
		end
	end
	Runtime:addEventListener( "enterFrame", gameGroup )
	
	--timer counter
	--count = 5
	
	--timer text 
	--clockText = display.newText("60", display.contentCenterX * 0.35, gH * 0.85, native.systemFont, 16)
	--clockText:setFillColor(0.7,0.7,1)
	
	--physics game background container background 
	physBkg = display.newRect(display.contentCenterX, display.contentCenterY, gW, gH)
	physBkg:setFillColor(.3, .5, .9, 1)

	
	-- catch box 
	catchBox = display.newRect(display.contentCenterX, display.contentCenterY * 1.54, gW * 0.25, gH * 0.25)
	catchBox:setFillColor(0.3, .5, .9, 1)
	
	--ball
	ball = display.newCircle(display.contentCenterX, display.contentCenterY * 0.19, 50)
	ball:setFillColor(1,0,0,1)
	
	--ball
	ball2 = display.newCircle(display.contentCenterX * .80, display.contentCenterY * 0.10, 25)
	ball2:setFillColor(0,1,0,1)
		
	--ball
	ball3 = display.newCircle(display.contentCenterX * 1.20, display.contentCenterY * 0.10, 25)
	ball3:setFillColor(0,0,1,1)
	
	--floor
	physFloor = display.newRect(display.contentCenterX, gH * 0.9, gW, gH * 0.005)
	physFloor:setFillColor(0,0,0,1)
	
	--wall
	physLeftWall = display.newRect(0,display.contentCenterY,0.001,gH)
	physRightWall = display.newRect(gW,display.contentCenterY,0.001,gH)
	
	--ceiling
	physCeiling = display.newRect(display.contentCenterX, 0, gW, 0.001)
	
	--insert all components of the page into the group
	dGroup:insert(physBkg)
	dGroup:insert(backButton)
	dGroup:insert(catchBox)
	dGroup:insert(ball)
	dGroup:insert(gameGroup)
	dGroup:insert(physFloor)
	dGroup:insert(gravButton)
	dGroup:insert(ball2)
	dGroup:insert(ball3)
	dGroup:insert(physLeftWall)
	dGroup:insert(physRightWall)
	dGroup:insert(physCeiling)
	dGroup.isVisible = false
	self.dGroup = dGroup

end

--function to reveal this page
function M:reveal()
	animFrames = 10
	--count = 5
	--timeDisplay = string.format("%02d", count)
	--clockText.text = timeDisplay
	--clockText.isVisible = false
	physics.start()
	physics.setGravity(0, 9.8)
	physics.setDrawMode("hybrid")
	physics.addBody(ball, {radius = 50, density=1.0, friction=0.3, bounce=0.2} )
	physics.addBody(ball2, {radius = 25, density=1.0, friction=0.3, bounce=0.2} )
	physics.addBody(ball3, {radius = 25, density=1.0, friction=0.3, bounce=0.2} )
	physics.addBody(physFloor, {density=1.0, friction=0.3, bounce=0.5})
	physics.addBody(physLeftWall, {density=1.0, friction=0.3, bounce=0.5})
	physics.addBody(physRightWall, {density=1.0, friction=0.3, bounce=0.5})
	physics.addBody(physCeiling, {density=1.0, friction=0.3, bounce=0.5})
	physFloor.bodyType = "static"
	physLeftWall.bodyType = "static"
	physRightWall.bodyType = "static"
	physCeiling.bodyType = "static"
	self.dGroup.isVisible = true
	gameGroup.isVisible = false
	print("reveal")
end

--function to hide this page
function M:hide()
	animFrames = -10
	--if(countDownTimer ~= nil) then
	--	timer.cancel(countDownTimer)
	--end
	physics.removeBody(ball)
	physics.removeBody(physFloor)
	physics.removeBody(ball2)
	physics.removeBody(ball3)
	physics.removeBody(physCeling)
	physics.removeBody(physLeftWall)
	physics.removeBody(physRightWall)
	physics.stop()
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