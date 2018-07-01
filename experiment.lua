
-- BRIC Drop Tower App
-- Version: 0.01
-- experiment.lua
---------------------------------------------------------------------------------------

local widget = require( "widget" )

local gH = display.contentHeight
local gW = display.contentWidth

local M = {}

--This page has its own set of states:
-- STATES: --
-- 0 - Experiment menu
-- 1 - Create Experiment
-- 2 - Run experiment (not used yet)
local expState = 0

local animFrames = 0

function buttonHandler(event)
	if(event.target.id == "Back") then
		if(expState == 0) then
			M:hide()
		elseif(expState == 1) then
			createExpGroup.isVisible = false
			experimentGroup.isVisible = true
			expState = 0
		end
	elseif(event.target.id == "Bottom Button") then
		expState = 1
		createExpGroup.isVisible = true
		experimentGroup.isVisible = false
	end
end

local function handleMicroGravEvent(event)
	if("ended" == event.phase) then	
		microGravText.text = "Microgravity is everything"
		microGravText.x = gW * 0.5
		microGravText.y = gH * 0.125
	end
end 

function M:makeDisplay()
	
	experimentGroup = display.newGroup()
	createExpGroup = display.newGroup()
	backButtonGroup = display.newGroup()
	dGroup = display.newGroup()
	dGroup:insert(experimentGroup)
	dGroup:insert(createExpGroup)
	dGroup:insert(backButtonGroup)
	
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
	--insert into group
	backButtonGroup:insert(backButton)
	--backButtonGroup.isVisible = false
	
	--experiment capsule container background 
	expBkg = display.newRect(display.contentCenterX, display.contentCenterY, gW, gH)
	expBkg:setFillColor(1,1,1,1)
	experimentGroup:insert(expBkg)
	
	--experiment capsule container image

	expCapsule = display.newImageRect("images/DropCapsule2.jpg", gW / 2, gH / 2)
	expCapsule.x = display.contentCenterX / 2
	expCapsule.y = display.contentCenterY
	experimentGroup:insert(expCapsule)
			
	--experimentPage images

	secondsSection = display.newRect(display.contentCenterX * 1.45, display.contentCenterY, gW / 2.25, gH / 2.5)
	secondsSection:setFillColor(0,.85,0,1)
	experimentGroup:insert(secondsSection)

	--buttons on the experiment page
	expPageButtonTop = widget.newButton(
		{
			id = "Top Button",
			x = gW * 0.5,
			y = gH * 0.125,
			width = gW * 0.9, 
			height = gH * 0.20,
			shape = "rectangle",
			fillColor = { default={ 0.1,0.4,0.9,0.85 }, over={ 0.15,0.5,1,1 } },
			onRelease = handleMicroGravEvent
		})
	experimentGroup:insert(expPageButtonTop)

	expPageButtonBottom = widget.newButton(
		{
			id = "Bottom Button",
			x = gW * 0.5,
			y = gH * 0.875,
			width = gW * 0.9, 
			height = gH * 0.20,
			shape = "rectangle",
			fillColor = { default={ 0.95,0.95,0,0.85 }, over={ 1,1,0,1 } },
			onRelease = buttonHandler
		})
	experimentGroup:insert(expPageButtonBottom)

	--create the text for the experiment page 
	microGravTextOptions = 
		{
			text = "What is microgravity?",
			x = gW * 0.5,
			y = gH * 0.125,
			width = gW * 0.8,
			align = "center",
			font = native.systemFont,
			fontSize = 20
		}
		
	startExperimentTextOptions = 
		{
			text = "Create an experiment!",
			x = gW * 0.5,
			y = gH * 0.875,
			width = gW * 0.8, 
			align = "center",
			font = native.systemFont,
			fontSize = 20
		}

	secondsTextOptions = 
		{
			text = "1.5 Seconds... That seems short! What else is 1.5 seconds long?",
			x = display.contentCenterX * 1.45,
			y = display.contentCenterY * 0.725,
			width = gW / 2.35,
			height = gH / 10,
			align = "center",
			font = native.systemFont,
			fontSize = 10
		}
		
	microGravText = display.newText(microGravTextOptions)
	microGravText:setFillColor(0,0,0,1)
	experimentGroup:insert(microGravText)

	startExperimentText = display.newText(startExperimentTextOptions)
	startExperimentText:setFillColor(0,0,0,1)
	experimentGroup:insert(startExperimentText)

	secondsText = display.newText(secondsTextOptions)
	secondsText:setFillColor(0,0,0,1)
	experimentGroup:insert(secondsText)
	
	
	--Create an Experiment page Buttons

	createBkg = display.newRect(display.contentCenterX, display.contentCenterY, gW, gH)
	createBkg:setFillColor(.3, .5, .9, 1)
	createExpGroup:insert(createBkg)

	whatDrop = widget.newButton(
		{
			x = display.contentCenterX, 
			y = display.contentCenterY * .20,
			width = gW * .75, 
			height = display.contentCenterY * .25,
			shape = "rectangle",
			fillColor = {default={.75, .75, .75, 1}, over={.75,.75,.75,1}},
			strokeColor = {default={ .25 , .25, .25, 1}, over={ .25,.25,.25, 1 } },
			strokeWidth = 3,
			label = "What do you want to drop?",
			font = native.systemFont,
			fontSize = 16,
			labelColor = {default = {0,0,0,1}, over = {0,0,0,1}}
		})
	createExpGroup:insert(whatDrop)

	drop1 = widget.newButton(
		{
			x = display.contentCenterX * 0.5, 
			y = display.contentCenterY * .50,
			width = gW * .15,
			height = gW * .15,
			shape = "rectangle",
			fillColor = {default={.75, .75, .75, 1}, over={1,1,1,1}},
			strokeColor = {default={ .95 , .95, 0, 1}, over={ .50,.50,.50, 1 } },
		})
	createExpGroup:insert(drop1)

	drop2 = widget.newButton(
		{
			x = display.contentCenterX, 
			y = display.contentCenterY * .50,
			width = gW * .15,
			height = gW * .15,
			shape = "rectangle",
			fillColor = {default={.75, .75, .75, 1}, over={1,1,1,1}},
			strokeColor = {default={ .95 , .95, 0, 1}, over={ .50,.50,.50, 1 } },
		})
	createExpGroup:insert(drop2)

	drop3 = widget.newButton(
		{
			x = display.contentCenterX * 1.5, 
			y = display.contentCenterY * .50,
			width = gW * .15,
			height = gW * .15,
			shape = "rectangle",
			fillColor = {default={.75, .75, .75, 1}, over={1,1,1,1}},
			strokeColor = {default={ .95 , .95, 0, 1}, over={ .50,.50,.50, 1 } },
		})
	createExpGroup:insert(drop3)

	box = display.newImageRect("images/boxtemp.jpg", gW * .125, gW * .125)
	box.x = display.contentCenterX * .50
	box.y = display.contentCenterY * .50
	createExpGroup:insert(box)

	nosign = display.newImageRect("images/nosign.png", gW * .125, gW * .125)
	nosign.x = display.contentCenterX
	nosign.y = display.contentCenterY * .50
	createExpGroup:insert(nosign)

	candle = display.newImageRect("images/candle.png", gW * .125, gW * .125)
	candle.x = display.contentCenterX * 1.5
	candle.y = display.contentCenterY * .50
	createExpGroup:insert(candle)

	whatHappen = widget.newButton(
		{
			x = display.contentCenterX, 
			y = display.contentCenterY * .85,
			width = gW * .75, 
			height = display.contentCenterY * .25,
			shape = "rectangle",
			fillColor = {default={.75, .75, .75, 1}, over={.75,.75,.75,1}},
			strokeColor = {default={ .25 , .25, .25, 1}, over={ .25,.25,.25, 1 } },
			strokeWidth = 3,
			label = "What do you think will happen?",
			font = native.systemFont,
			fontSize = 16,
			labelColor = {default = {0,0,0,1}, over = {0,0,0,1}}
		})
	createExpGroup:insert(whatHappen)

	happen1 = widget.newButton(
		{
			x = display.contentCenterX * 0.3, 
			y = display.contentCenterY * 1.15,
			width = gW * .30,
			height = gW * .15,
			shape = "rectangle",
			fillColor = {default={.75, .75, .75, 1}, over={1,1,1,1}},
			strokeColor = {default={ .95 , .95, 0, 1}, over={ .50,.50,.50, 1 } },
		})
	createExpGroup:insert(happen1)

	happen2 = widget.newButton(
		{
			x = display.contentCenterX, 
			y = display.contentCenterY * 1.15,
			width = gW * .30,
			height = gW * .15,
			shape = "rectangle",
			fillColor = {default={.75, .75, .75, 1}, over={1,1,1,1}},
			strokeColor = {default={ .95 , .95, 0, 1}, over={ .50,.50,.50, 1 } },
		})
	createExpGroup:insert(happen2)

	happen3 = widget.newButton(
		{
			x = display.contentCenterX * 1.7, 
			y = display.contentCenterY * 1.15,
			width = gW * .30,
			height = gW * .15,
			shape = "rectangle",
			fillColor = {default={.75, .75, .75, 1}, over={1,1,1,1}},
			strokeColor = {default={ .95 , .95, 0, 1}, over={ .50,.50,.50, 1 } },
		})
	createExpGroup:insert(happen3)

	runExperiment = widget.newButton(
		{
			id = "Run Experiment Button",
			x = gW * 0.5,
			y = gH * 0.7625,
			width = gW * 0.9, 
			height = gH * 0.20,
			shape = "rectangle",
			fillColor = { default={ 0.95,0.95,0,0.85 }, over={ 1,1,0,1 } },
			label = "Run Experiment",
			labelColor = {default = {0,0,0,1}, over = {0,0,0,1}},
			font = native.systemFont,
			fontSize = 15,
		})
	createExpGroup:insert(runExperiment)

	--[[backBar = widget.newButton(
		{
			id = "Back Bar",
			x = display.contentCenterX,
			y = gH * 0.95,
			width = gW,
			height = gH * 0.075,
			shape = "rectangle",
			fillColor = {default={.75, .75, .75, 1}, over={1,1,1,1}},
			strokeColor = {default={ .25 , .25, .25, 1}, over={ .5,.5,.5, 1 } },
			strokeWidth = 3,
			label = "Back",
			font = native.systemFont,
			fontSize = 16,
			labelColor = {default = {0,0,0,1}, over = {0,0,0,1}},
			onRelease = buttonHandler
		})
	createExpGroup:insert(backBar)]]--
	
	createExpGroup.isVisible = false
	--experimentGroup.isVisible = false
	dGroup.isVisible = false
	
	self.experimentGroup = experimentGroup
	self.createExpGroup = createExpGroup
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