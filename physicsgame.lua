
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
local densityValue = 0.1
local ballPlaced = 0
local tutorialState = 0
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

function tapListener(event)
	--ball3
	if(event.phase == "began") then 
		if(ballPlaced == 1) then 
			physics.removeBody(ball3)
			ballPlaced = 0
		end
		print("here")
		ball3.x = event.x
		ball3.y = event.y
		physics.addBody(ball3, {radius = 50, density=densityValue, friction=0.3, bounce=0.5} )
		ballPlaced = 1
	end
	return true
end
	
	
function buttonHandler(event)
	if("GravOnOff" == event.target.id) then
		if(gravButton:getLabel() == "Gravity: On")then
			gravButton:setLabel("Gravity: Off")
			physics.setGravity(0,0)
			print("here")
		elseif(gravButton:getLabel() == "Gravity: Off")then
			gravButton:setLabel("Gravity: On")
			physics.setGravity(9.8,0)
		end
	elseif("weight1" == event.target.id) then
		densityValue = 0.5
		weight1:setFillColor(1,1,1,1)
		weight2:setFillColor(.75,.75,.75,1)
		weight3:setFillColor(.75,.75,.75,1)
	elseif("weight2" == event.target.id) then
		densityValue = 1
		weight2:setFillColor(1,1,1,1)
		weight1:setFillColor(.75,.75,.75,1)
		weight3:setFillColor(.75,.75,.75,1)
	elseif("weight3" == event.target.id) then
		densityValue = 2
		weight3:setFillColor(1,1,1,1)
		weight1:setFillColor(.75,.75,.75,1)
		weight2:setFillColor(.75,.75,.75,1)
	elseif("Reset" == event.target.id) then
		ball3.x = gW * 4
		ball3.y = gH * 4
		physics.removeBody(ball3)
		ballPlaced = 0
		board:setLinearVelocity(0,0)
		block:setLinearVelocity(0,0)
		board.angularVelocity = 0
		block.angularVelocity = 0
		board.rotation = 0
		block.rotation = 0
		board.x = gW * 0.77
		board.y = gH * 0.80
		block.x = gW * 0.7375
		block.y = gH * 0.875
	elseif("Next" == event.target.id) then	
		if(tutorialState == 0) then	
			gameGroup.isVisible = false
			nextButton.isVisible = false
			tutorialState = 1
		end
	elseif("Back" == event.target.id) then
		M:hide()
	end
end

--main display function
function M:makeDisplay()

	local dGroup = display.newGroup()
	
	gameGroup = display.newGroup()
	
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
	
	-----------------
	-- BACK BUTTON --
	-----------------
	--make back button
	backButton = widget.newButton(
	{
		id = "Back",
		x = gW * .938,
		y = gH * 0.1425,
		width = gW * 0.5,
		height = gH * 0.0635,
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
	backButton.rotation = -90
	backButton:setEnabled(false)
	
	gravButton = widget.newButton(
	{
		id = "GravOnOff",
		x = gW * .938,
		y = gH - gH * 0.1425,
		width = gW * 0.5,
		height = gH * 0.0635,
		shape = "rectangle",
		fillColor = {default={.75, .75, .75, 1}, over={1,1,1,1}},
		strokeColor = {default={ .25 , .25, .25, 1}, over={ .50,.50,.50, 1 } },
		strokeWidth = 3,
		label = "Gravity: On",
		font = native.systemFont,
		fontSize = 16,
		labelColor = {default = {0,0,0,1}, over = {0,0,0,1}},
		onRelease = buttonHandler
	})
	gravButton.rotation = -90
	gravButton:setEnabled(false)
		
	weight1 = widget.newButton(
		{
		id = "weight1",
		x = gW * .938,
		y = gH * .70,
		width = gW * 0.1,
		height = gH * 0.0635,
		shape = "rectangle",
		strokeColor = {default={ .25 , .25, .25, 1}, over={ .25, .25, .25, 1 } },
		strokeWidth = 3,
		label = "25lb",
		font = native.systemFont,
		fontSize = 13,
		labelColor = {default = {0,0,0,1}, over = {0,0,0,1}},
		onRelease = buttonHandler
		})
	weight1:setFillColor(1,1,1,1)
	weight1.rotation = -90
	weight1:setEnabled(false)
	
	weight2 = widget.newButton(
		{
		id = "weight2",
		x = gW * .938,
		y = gH * .64,
		width = gW * 0.1,
		height = gH * 0.0635,
		shape = "rectangle",
		strokeColor = {default={ .25 , .25, .25, 1}, over={.25 , .25, .25, 1} },
		strokeWidth = 3,
		label = "50lb",
		font = native.systemFont,
		fontSize = 13,
		labelColor = {default = {0,0,0,1}, over = {0,0,0,1}},
		onRelease = buttonHandler
		})
	weight2:setFillColor(.75,.75,.75,1)
	weight2.rotation = -90
	weight2:setEnabled(false)
	
	weight3 = widget.newButton(
		{
		id = "weight3",
		x = gW * .938,
		y = gH * .58,
		width = gW * 0.1,
		height = gH * 0.0635,
		shape = "rectangle",
		strokeColor = {default={ .25 , .25, .25, 1}, over={.25 , .25, .25, 1} },
		strokeWidth = 3,
		label = "75lb",
		font = native.systemFont,
		fontSize = 13,
		labelColor = {default = {0,0,0,1}, over = {0,0,0,1}},
		onRelease = buttonHandler
		})
	weight3:setFillColor(.75,.75,.75,1)
	weight3.rotation = -90
	weight3:setEnabled(false)
	
	resetButton = widget.newButton(
	{
		id = "Reset",
		x = gW * .938,
		y = gH * 0.4175,
		width = gW * 0.47,
		height = gH * 0.0635,
		shape = "rectangle",
		fillColor = {default={.75, .75, .75, 1}, over={1,1,1,1}},
		strokeColor = {default={ .25 , .25, .25, 1}, over={ .50,.50,.50, 1 } },
		strokeWidth = 3,
		label = "Reset",
		font = native.systemFont,
		fontSize = 16,
		labelColor = {default = {0,0,0,1}, over = {0,0,0,1}},
		onRelease = buttonHandler
	})
	resetButton.rotation = -90
	resetButton:setEnabled(false)
	
	nextButton = widget.newButton(
	{
		id = "Next",
		x = gW * .79,
		y = gH * 0.5,
		width = gW * 0.47,
		height = gH * 0.0635,
		shape = "rectangle",
		fillColor = {default={.75, .75, .75, 1}, over={1,1,1,1}},
		strokeColor = {default={ .25 , .25, .25, 1}, over={ .50,.50,.50, 1 } },
		strokeWidth = 3,
		label = "Next",
		font = native.systemFont,
		fontSize = 16,
		labelColor = {default = {0,0,0,1}, over = {0,0,0,1}},
		onRelease = buttonHandler
	})
	nextButton.rotation = -90
	
	--create box for text to appear on
	gameOverBox = display.newRect(display.contentCenterX, display.contentCenterY, gW * 0.8, gH * 0.25)
	gameOverBox:setFillColor(1, 1, 1, 1)
	gameOverBox.strokeWidth = 3
	gameOverBox:setStrokeColor(1,0,0,1)
	gameOverBox.rotation = -90
	--create text and shrink to box
	i = 31
	repeat
		if(gameOverText ~= nil) then
			gameOverText:removeSelf()
		end
		i = i - 1
		gameOverText = display.newText(
			{
				text="Welcome to the Physics Playground!\n\n In the physics playground you will get to learn about physics while testing your knowledge in a catapult game!\n\n First lets take a look at what you can do in the playground. Hit the next button on your screen to begin the tutorial!",
				x=gameOverBox.x,
				y=gameOverBox.y,
				width=gameOverBox.width - 6, --keep inside the lines
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until gameOverText.height <= gameOverBox.height or i == 1
	gameOverText:setFillColor(1,0,0,1)
	gameOverText.rotation = -90
	
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
	catchBox = display.newRect(gW * .65 , gW * .125, gW * 0.25, gH * 0.25)
	catchBox:setFillColor(0, 0, 0, 1)
	catchBox.rotation = -90
	--catch box wall

	catchLeftWall = display.newRect(display.contentCenterX + gW * 0.15,display.contentCenterY * 0.275,gH * 0.005,gH * 0.25)
	catchLeftWall:setFillColor(1,1,1,1)
	catchLeftWall.rotation = -90
	
	--ball
	ball = display.newCircle(display.contentCenterX, display.contentCenterY * 0.10, 45)
	ball:setFillColor(1,0,0,1)
	
	--ball
	ball2 = display.newCircle(display.contentCenterX * .80, display.contentCenterY * 0.20, 25)
	ball2:setFillColor(0,1,0,1)
	
	-- placeable ball
	ball3 = display.newCircle(gW * 4, gH * 4, 50)
	ball3:setFillColor(0,0,1,1)
	
	--block
	block = display.newRect(gW * 0.7375, gH * 0.875, gW * 0.065, gW * 0.065)
	
	--floor
	physFloor = display.newRect(gW * .875, display.contentCenterY, gW * 0.005, gH)
	physFloor:setFillColor(0,0,0,1)
	
	--wall
	physLeftWall = display.newRect(0,gH,gW * 2,0.001)
	physRightWall = display.newRect(0, 0, gW * 2, 0.001)
	
	--ceiling
	physCeiling = display.newRect(-gW,display.contentCenterY,0.001,gH)
	
	--seeSaw peg
	peg = display.newRect(gW * 0.835, gH * 0.80, gW * 0.075, gH * 0.025)
	peg2 = display.newRect(gW * 0.835, gH * 0.875, gW * 0.075, gH * 0.025)
	
	--seeSaw board
	board = display.newRect(gW * 0.76, gH * 0.80, gW * 0.025, gH * 0.20)
	
	placeButton = display.newRect(gW * .355, gH * .57, gW * 0.6975, gH * 0.85)
	placeButton:setFillColor(0,0,0,0.01)
	placeButton:addEventListener("touch", tapListener)
	placeButton.strokeWidth = 3
	placeButton:setStrokeColor(0.5,0,0,1)
	
	--insert all components of the page into the group
	dGroup:insert(physBkg)
	dGroup:insert(backButton)
	dGroup:insert(catchBox)
	dGroup:insert(ball)
	dGroup:insert(physFloor)
	dGroup:insert(gravButton)
	dGroup:insert(ball2)
	dGroup:insert(ball3)
	dGroup:insert(physLeftWall)
	dGroup:insert(physRightWall)
	dGroup:insert(physCeiling)
	dGroup:insert(catchLeftWall)
	dGroup:insert(peg)
	dGroup:insert(peg2)
	dGroup:insert(board)
	dGroup:insert(block)
	dGroup:insert(weight1)
	dGroup:insert(weight2)
	dGroup:insert(weight3)
	dGroup:insert(placeButton)
	dGroup:insert(resetButton)
	dGroup:insert(gameGroup)
	dGroup:insert(nextButton)
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
	physics.setGravity(9.8, 0)
	physics.setDrawMode("normal")
	ball.x = display.contentCenterX
	ball.y = display.contentCenterY * 0.10
	ball2.x = display.contentCenterX * 0.80
	ball2.y = display.contentCenterY * 0.20
--	ball3.x = gW * 0.15
--	ball3.y = gH * 0.70
	physics.addBody(ball, {radius = 45, density=1.0, friction=0.3, bounce=0.5} )
	physics.addBody(ball2, {radius = 25, density=1.0, friction=0.3, bounce=0.5} )
	--physics.addBody(ball3, {radius = 50, density=1.0, friction=0.3, bounce=0.5} )
	physics.addBody(physFloor, {density=1.0, friction=0.3, bounce=0.75})
	physics.addBody(physLeftWall, {density=1.0, friction=0.3, bounce=0.9})
	physics.addBody(physRightWall, {density=1.0, friction=0.3, bounce=0.9})
	physics.addBody(physCeiling, {density=1.0, friction=0.3, bounce=0.75})
	physics.addBody(catchLeftWall, {density=1, friction=0.2, bounce=0.8})
	physics.addBody(peg, {density=1, friction=0.2, bounce=0.8})
	physics.addBody(peg2, {density=1, friction=0.2, bounce=0.8})
	physics.addBody(board, {density=1, friction=0.2, bounce=0.8})
	physics.addBody(block, {density=1, friction=0.2, bounce=0.1})
	physFloor.bodyType = "static"
	physLeftWall.bodyType = "static"
	physRightWall.bodyType = "static"
	physCeiling.bodyType = "static"
	catchLeftWall.bodyType = "static"
	peg.bodyType = "static"
	peg2.bodyType = "static"
	self.dGroup.isVisible = true
	gameGroup.animFrames = 10
	gameGroup.isVisible = true
	print("reveal")
end

--function to hide this page
function M:hide()
	animFrames = -10
	--if(countDownTimer ~= nil) then
	--	timer.cancel(countDownTimer)
	--end
	gravButton:setLabel("Gravity: On")
	physics.setGravity(0,9.8)
	physics.removeBody(ball)
	physics.removeBody(physFloor)
	physics.removeBody(ball2)
	if(ballPlaced == 1) then
		ball.x = gW * 4
		ball.y = gH * 4
		physics.removeBody(ball3)
		ballPlaced = 0
	end
	physics.removeBody(physCeiling)
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