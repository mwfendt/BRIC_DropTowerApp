
-- BRIC Drop Tower App
-- Version: 0.01
-- experiment.lua
-- Authors: Saul Flores & Marc Willis
-- Supervising Professor: Matthew Fendt
---------------------------------------------------------------------------------------

local widget = require( "widget" )

local gH = display.contentHeight
local gW = display.contentWidth

local M = {}

--This page has its own set of states:
-- STATES: --
-- 0 - Experiment menu
-- 1 - Create Experiment
-- 2 - Run experiment
-- 3 - Experiment results
local expState = 0
local animFrames = 0
local expSelected = 0
local hypSelected = 0

--ends current video playing
local function endVideo()
	if (video ~= nil) then
		video:removeSelf()
		video = nil
	end
end

--starts and ends video 
local function videoListener (event)
	if(event.errorCode) then
		print("ERROR: " .. event.errorMessage)
		native.showAlert("ERROR!", event.errorMessage, {"OK"})
	else
		if ("ready" == event.phase) then
			--video ready, start playing it
			video:play()
		elseif ("ended" == event.phase) then
			--video is over, close it
			endVideo()
			if(expState == 2) then
				--if you're done watching the experiment, advance
				expState = 3
				createExpGroup.isVisible = false
				expVideoGroup.isVisible = false
				postExpGroup.isVisible = true
			end
		end
	end
end

local function resetExpButtons()
	expSelected = 0
	drop1:setFillColor(.75, .75, .75, 1)
	drop2:setFillColor(.75, .75, .75, 1)
	drop3:setFillColor(.75, .75, .75, 1)
	hypSelected = 0
	happen1:setFillColor(.75,.75,.75,1)
	happen2:setFillColor(.75,.75,.75,1)
	happen3:setFillColor(.75,.75,.75,1)
	hypothesis1.isVisible = false
	hypothesis2.isVisible = false
	hypothesis3.isVisible = false
end

--controls the functionality of buttons and navigation of pages through the experiment group
function buttonHandler(event)
	if(event.target.id == "Back") then
		--back from page 1 sends to main screen
		if(expState == 0) then
			M:hide()
			endVideo()
		--back from page 2 sends to page 1 and restarts video
		elseif(expState == 1) then
			--reset the experiment buttons
			resetExpButtons()
			createExpGroup.isVisible = false
			experimentGroup.isVisible = true
			video = native.newVideo(display.contentCenterX * 1.45, display.contentCenterY * .975, display.contentCenterX * .6, display.contentCenterY * .5)
			video:load("videos/ExperimentPageVid.mp4")
			video:addEventListener("video", videoListener)
			expState = 0
		--back from page 3 to page 2
		elseif(expState == 2) then
			endVideo()
			expVideoGroup.isVisible = false
			expState = 1
		--back from the past-experiment page gots back to the first page
		elseif(expState == 3) then
			expState = 0
			postExpGroup.isVisible = false
			experimentGroup.isVisible = true
			video = native.newVideo(display.contentCenterX * 1.45, display.contentCenterY * .975, display.contentCenterX * .6, display.contentCenterY * .5)
			video:load("videos/ExperimentPageVid.mp4")
			video:addEventListener("video", videoListener)
		end
		--bottom experiment button sends from page 1 to page 2
	elseif(event.target.id == "Bottom Button") then
		expState = 1
		createExpGroup.isVisible = true
		experimentGroup.isVisible = false
		endVideo()
	elseif(event.target.id == "ScreenDarkener") then
		expState = 3
		endVideo()
		createExpGroup.isVisible = false
		expVideoGroup.isVisible = false
		postExpGroup.isVisible = true
	end
end

--replaces the text on "What is microgravity" button when clicked
local function handleMicroGravEvent(event)
	if("ended" == event.phase) then	
		microGravText.text = "Microgravity (more or less a synonym for weightlessness) describes an environment where the forces of gravity are very small or almost zero - either due to being far away from any gravitational influence of other masses or due to being in temporary or constant free fall. "
		microGravText.x = gW * 0.5
		microGravText.y = gH * 0.125
		microGravText.size = textSizeH
	end
end 

local function dropButtonHandler(event)
	resetExpButtons()
	event.target:setFillColor(1,1,0,1)
	if("Drop1" == event.target.id) then
		--Lego men
		expSelected = 1
		hypothesis1.isVisible = true
	elseif ("Drop2" == event.target.id) then
		--water
		expSelected = 2
		hypothesis2.isVisible = true
	elseif ("Drop3" == event.target.id) then
		--candle
		expSelected = 3
		hypothesis3.isVisible = true
	end
end

local function happenButtonHandler(event)
	if(expSelected ~= 0) then
		happen1:setFillColor(.75,.75,.75,1)
		happen2:setFillColor(.75,.75,.75,1)
		happen3:setFillColor(.75,.75,.75,1)
		event.target:setFillColor(1,1,0,1)
		if("Happen1" == event.target.id) then
			--leftmost choice
			hypSelected = 1
		elseif ("Happen2" == event.target.id) then
			--middle choice
			hypSelected = 2
		elseif ("Happen3" == event.target.id) then
			--rightmost choice
			hypSelected = 3
		end
	end
end

local function runExperimentHandler(event)
	if(expSelected ~= 0 and hypSelected ~= 0) then
		expVideoGroup.isVisible = true
		expState = 2
		video = native.newVideo(gW * 0.5, gH * 0.45, gH * 0.506 , gH * 0.9)
		video:load("videos/ExperimentVid" .. expSelected .. ".mp4")
		video:addEventListener("video", videoListener)
	end
end

--main display function
function M:makeDisplay()
	
	--instantialize groups
	experimentGroup = display.newGroup()
	createExpGroup = display.newGroup()
	expVideoGroup = display.newGroup()
	postExpGroup = display.newGroup()
	backButtonGroup = display.newGroup()
	dGroup = display.newGroup()
	dGroup:insert(experimentGroup)
	dGroup:insert(createExpGroup)
	dGroup:insert(expVideoGroup)
	dGroup:insert(postExpGroup)
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
		fontSize = textSizeC,
		labelColor = {default = {0,0,0,1}, over = {0,0,0,1}},
		onRelease = buttonHandler
	})
	--insert into group
	backButtonGroup:insert(backButton)
	
	--experiment capsule container background 
	expBkg = display.newRect(display.contentCenterX, display.contentCenterY, gW, gH)
	expBkg:setFillColor(1,1,1,1)
	experimentGroup:insert(expBkg)
	
	--experiment capsule container image
	expCapsule = display.newImageRect("images/DropCapsule2.jpg", gW / 2, gH *.45)
	expCapsule.x = display.contentCenterX / 2
	expCapsule.y = display.contentCenterY * .9
	experimentGroup:insert(expCapsule)
			
	--experimentPage images
	secondsSection = display.newRect(display.contentCenterX * 1.45, display.contentCenterY * .90, gW / 2.25, gH / 2.5)
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
	
	--create an experiment button
	expPageButtonBottom = widget.newButton(
		{
			id = "Bottom Button",
			x = gW * 0.5,
			y = gH * 0.775,
			width = gW * 0.9, 
			height = gH * 0.20,
			shape = "rectangle",
			fillColor = { default={ 0.95,0.95,0,0.85 }, over={ 1,1,0,1 } },
			onRelease = buttonHandler
		})
	experimentGroup:insert(expPageButtonBottom)

	--options for what is micrograv text
	microGravTextOptions = 
		{
			text = "What is microgravity?",
			x = gW * 0.5,
			y = gH * 0.125,
			width = gW * 0.8,
			align = "center",
			font = native.systemFont,
			fontSize = textSizeC
		}
		
	--options for create experiment text
	startExperimentTextOptions = 
		{
			text = "Create an experiment!",
			x = gW * 0.5,
			y = gH * 0.775,
			width = gW * 0.8, 
			align = "center",
			font = native.systemFont,
			fontSize = textSizeC
		}

	--options for 1.5 seconds text
	secondsTextOptions = 
		{
			text = "1.5 Seconds... That seems short! What else is 1.5 seconds long?",
			x = display.contentCenterX * 1.45,
			y = display.contentCenterY * 0.625,
			width = gW / 2.35,
			height = gH / 10,
			align = "center",
			font = native.systemFont,
			fontSize = textSizeG
		}
	
	--create micrograv text
	microGravText = display.newText(microGravTextOptions)
	microGravText:setFillColor(0,0,0,1)
	experimentGroup:insert(microGravText)
	
	--create experiment text
	startExperimentText = display.newText(startExperimentTextOptions)
	startExperimentText:setFillColor(0,0,0,1)
	experimentGroup:insert(startExperimentText)
	
	--create 1.5 seconds text
	secondsText = display.newText(secondsTextOptions)
	secondsText:setFillColor(0,0,0,1)
	experimentGroup:insert(secondsText)

	------------------
	--What would you--
	--like to drop? --
	------------------
	--Create an Experiment page Buttons
	createBkg = display.newRect(display.contentCenterX, display.contentCenterY, gW, gH)
	createBkg:setFillColor(.3, .5, .9, 1)
	createExpGroup:insert(createBkg)
	
	--top button
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
			fontSize = textSizeH,
			labelColor = {default = {0,0,0,1}, over = {0,0,0,1}}
		})
	createExpGroup:insert(whatDrop)
	
	--first drop icon
	drop1 = widget.newButton(
		{
			id = "Drop1",
			x = display.contentCenterX * 0.5, 
			y = display.contentCenterY * .50,
			width = gW * .15,
			height = gW * .15,
			shape = "rectangle",
			onRelease = dropButtonHandler
		})
	drop1:setFillColor(0.75, 0.75, 0.75) --have to set fill color separately if you want to change it later
	createExpGroup:insert(drop1)

	--second drop icon
	drop2 = widget.newButton(
		{
			id = "Drop2",
			x = display.contentCenterX, 
			y = display.contentCenterY * .50,
			width = gW * .15,
			height = gW * .15,
			shape = "rectangle",
			onRelease = dropButtonHandler
		})
	drop2:setFillColor(0.75, 0.75, 0.75) --have to set fill color separately if you want to change it later
	createExpGroup:insert(drop2)

	--third drop icon
	drop3 = widget.newButton(
		{
			id = "Drop3",
			x = display.contentCenterX * 1.5, 
			y = display.contentCenterY * .50,
			width = gW * .15,
			height = gW * .15,
			shape = "rectangle",
			onRelease = dropButtonHandler
		})
	drop3:setFillColor(0.75, 0.75, 0.75) --have to set fill color separately if you want to change it later
	createExpGroup:insert(drop3)

	--box icon
	box = display.newImageRect("images/boxtemp.jpg", gW * .125, gW * .125)
	box.x = display.contentCenterX * .50
	box.y = display.contentCenterY * .50
	createExpGroup:insert(box)

	--water droplet icon
	nosign = display.newImageRect("images/waterDroplet.jpg", gW * .125, gW * .125)
	nosign.x = display.contentCenterX
	nosign.y = display.contentCenterY * .50
	createExpGroup:insert(nosign)

	--candle sign icon
	candle = display.newImageRect("images/candle.png", gW * .125, gW * .125)
	candle.x = display.contentCenterX * 1.5
	candle.y = display.contentCenterY * .50
	createExpGroup:insert(candle)

	--what happens button?
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
			fontSize = textSizeH,
			labelColor = {default = {0,0,0,1}, over = {0,0,0,1}}
		})
	createExpGroup:insert(whatHappen)

	--what happens1 box
	happen1 = widget.newButton(
		{
			id = "Happen1",
			x = display.contentCenterX * 0.3, 
			y = display.contentCenterY * 1.15,
			width = gW * .30,
			height = gW * .15,
			shape = "rectangle",
			onRelease = happenButtonHandler
		})
	happen1:setFillColor(0.75,0.75,0.75,1)
	createExpGroup:insert(happen1)
	
	--what happens2 box
	happen2 = widget.newButton(
		{
			id = "Happen2",
			x = display.contentCenterX, 
			y = display.contentCenterY * 1.15,
			width = gW * .30,
			height = gW * .15,
			shape = "rectangle",
			onRelease = happenButtonHandler
		})
	happen2:setFillColor(0.75,0.75,0.75,1)
	createExpGroup:insert(happen2)

	--what happens3 box
	happen3 = widget.newButton(
		{
			id = "Happen3",
			x = display.contentCenterX * 1.7, 
			y = display.contentCenterY * 1.15,
			width = gW * .30,
			height = gW * .15,
			shape = "rectangle",
			onRelease = happenButtonHandler
		})
	happen3:setFillColor(0.75,0.75,0.75,1)
	createExpGroup:insert(happen3)
	
	--hypothesis texts
	local hyp1A = nil
	local hyp1B = nil
	local hyp1C = nil
	local hyp2A = nil
	local hyp2B = nil
	local hyp2C = nil
	local hyp3A = nil
	local hyp3B = nil
	local hyp3C = nil
	
	--1st experiment hypotheses
	--group
	hypothesis1 = display.newGroup()
	hypothesis1.isVisible = false
	createExpGroup:insert(hypothesis1)
	
	--text A
	local i = textSizeC
	repeat
		if(hyp1A ~= nil) then
			hyp1A:removeSelf()
		end
		i = i - 1
		hyp1A = display.newText(
			{
				text="The lego men will not move.",
				x=happen1.x,
				y=happen1.y,
				width=happen1.width * 0.95,
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until hyp1A.height <= happen1.height * 0.95 or i == 1
	hyp1A:setFillColor(0,0,0,1)
	hypothesis1:insert(hyp1A)
	
	--text B
	i = textSizeC
	repeat
		if(hyp1B ~= nil) then
			hyp1B:removeSelf()
		end
		i = i - 1
		hyp1B = display.newText(
			{
				text="The lego men will move slowly upwards.",
				x=happen2.x,
				y=happen2.y,
				width=happen2.width * 0.95,
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until hyp1B.height <= happen2.height * 0.95 or i == 1
	hyp1B:setFillColor(0,0,0,1)
	hypothesis1:insert(hyp1B)
	
	--text C
	local i = textSizeC
	repeat
		if(hyp1C ~= nil) then
			hyp1C:removeSelf()
		end
		i = i - 1
		hyp1C = display.newText(
			{
				text="The lego men will pull on the chain downwards.",
				x=happen3.x,
				y=happen3.y,
				width=happen3.width * 0.95,
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until hyp1C.height <= happen3.height * 0.95 or i == 1
	hyp1C:setFillColor(0,0,0,1)
	hypothesis1:insert(hyp1C)
	
	--2nd experiment hypotheses
	--group
	hypothesis2 = display.newGroup()
	hypothesis2.isVisible = false
	createExpGroup:insert(hypothesis2)
	
	--text A
	local i = textSizeC
	repeat
		if(hyp2A ~= nil) then
			hyp2A:removeSelf()
		end
		i = i - 1
		hyp2A = display.newText(
			{
				text="The water will form a teardrop shape.",
				x=happen1.x,
				y=happen1.y,
				width=happen1.width * 0.95,
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until hyp2A.height <= happen1.height * 0.95 or i == 1
	hyp2A:setFillColor(0,0,0,1)
	hypothesis2:insert(hyp2A)
	
	--text B
	i = textSizeC
	repeat
		if(hyp2B ~= nil) then
			hyp2B:removeSelf()
		end
		i = i - 1
		hyp2B = display.newText(
			{
				text="The water will stay in the shape of its container.",
				x=happen2.x,
				y=happen2.y,
				width=happen2.width * 0.95,
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until hyp2B.height <= happen2.height * 0.95 or i == 1
	hyp2B:setFillColor(0,0,0,1)
	hypothesis2:insert(hyp2B)
	
	--text C
	local i = textSizeC
	repeat
		if(hyp2C ~= nil) then
			hyp2C:removeSelf()
		end
		i = i - 1
		hyp2C = display.newText(
			{
				text="The water will form a sphere.",
				x=happen3.x,
				y=happen3.y,
				width=happen3.width * 0.95,
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until hyp2C.height <= happen3.height * 0.95 or i == 1
	hyp2C:setFillColor(0,0,0,1)
	hypothesis2:insert(hyp2C)
	
	--3rd experiment hypotheses
	--group
	hypothesis3 = display.newGroup()
	hypothesis3.isVisible = false
	createExpGroup:insert(hypothesis3)
	
	--text A
	local i = textSizeC
	repeat
		if(hyp3A ~= nil) then
			hyp3A:removeSelf()
		end
		i = i - 1
		hyp3A = display.newText(
			{
				text="The flame will extinguish.",
				x=happen1.x,
				y=happen1.y,
				width=happen1.width * 0.95,
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until hyp3A.height <= happen1.height * 0.95 or i == 1
	hyp3A:setFillColor(0,0,0,1)
	hypothesis3:insert(hyp3A)
	
	--text B
	i = textSizeC
	repeat
		if(hyp3B ~= nil) then
			hyp3B:removeSelf()
		end
		i = i - 1
		hyp3B = display.newText(
			{
				text="The flame will form a sphere.",
				x=happen2.x,
				y=happen2.y,
				width=happen2.width * 0.95,
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until hyp3B.height <= happen2.height * 0.95 or i == 1
	hyp3B:setFillColor(0,0,0,1)
	hypothesis3:insert(hyp3B)
	
	--text C
	local i = textSizeC
	repeat
		if(hyp3C ~= nil) then
			hyp3C:removeSelf()
		end
		i = i - 1
		hyp3C = display.newText(
			{
				text="The flame will grow larger.",
				x=happen3.x,
				y=happen3.y,
				width=happen3.width * 0.95,
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until hyp3C.height <= happen3.height * 0.95 or i == 1
	hyp3C:setFillColor(0,0,0,1)
	hypothesis3:insert(hyp3C)
	
	--run experiment button
	local runExperiment = widget.newButton(
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
			fontSize = textSizeC,
			onRelease = runExperimentHandler
		})
	createExpGroup:insert(runExperiment)
	
	--video playing group
	local screenDarkener = widget.newButton(
		{
			id = "ScreenDarkener",
			x = gW * 0.5,
			y = gH * 0.5,
			width = gW, 
			height = gH,
			shape = "rectangle",
			fillColor = { default={ 0,0,0,0.85 }, over={ 0,0,0,0.85 } },
			label = "Loading Experiment Video...",
			labelColor = {default = {1,1,1,1}, over = {1,1,1,1}},
			font = native.systemFont,
			fontSize = textSizeA,
			onRelease = buttonHandler
		})
	expVideoGroup:insert(screenDarkener)
	expVideoGroup.isVisible = false
	
	createExpGroup.isVisible = false
	
	---------------------
	-- POST EXPERIMENT --
	---------------------
	postBkg = display.newRect(display.contentCenterX, display.contentCenterY, gW, gH)
	postBkg:setFillColor(.3, .5, .9, 1)
	postExpGroup:insert(postBkg)
	
	postExpGroup.isVisible = false
	
	dGroup.isVisible = false
	self.experimentGroup = experimentGroup
	self.createExpGroup = createExpGroup
	self.dGroup = dGroup
end

--function to reveal this page
function M:reveal()
	expSelected = 0
	animFrames = 10
	self.dGroup.isVisible = true
	video = native.newVideo(display.contentCenterX * 1.45, display.contentCenterY * .975, display.contentCenterX * .6, display.contentCenterY * .5)
	video:load("videos/ExperimentPageVid.mp4")
	video:addEventListener("video", videoListener)
	--print("reveal")
end

--function to hide this page
function M:hide()
	animFrames = -10
	--print("hide")
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
		--print(animFrames)
	end
end
Runtime:addEventListener( "enterFrame", M )

return M