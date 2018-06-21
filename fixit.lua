
-- BRIC Drop Tower App
-- Version: 0.01
-- fixit.lua
---------------------------------------------------------------------------------------

local widget = require( "widget" )

local gH = display.contentHeight
local gW = display.contentWidth

--Fixit has its own set of states:
-- STATES: --
-- 0 - Main screen
-- 1 - Winch problem
-- 2 - Capsule problem
-- 3 - Netting problem
-- 4 - Decel. Chamber problem
-- 5 - Winch minigame
-- 6 - Capsule minigame
-- 7 - Netting minigame
-- 8 - Decel. Chamber minigame
local fixitState = 0

local M = {}

function enterState(num)
	if(num == 0) then
		titleGroup.isVisible = true
	elseif (num == 1) then
		probButtonsGroup.isVisible = true
		backButtonGroup.isVisible = true
	elseif (num == 2) then
		probButtonsGroup.isVisible = true
		backButtonGroup.isVisible = true
	elseif (num == 3) then
		probButtonsGroup.isVisible = true
		backButtonGroup.isVisible = true
	elseif (num == 4) then
		probButtonsGroup.isVisible = true
		backButtonGroup.isVisible = true
	else
		print("Unknown State: " .. num)
	end
end

function exitState(num)
	if(num == 0) then
		titleGroup.isVisible = false
	elseif (num == 1) then
		probButtonsGroup.isVisible = false
		backButtonGroup.isVisible = false
	elseif (num == 2) then
		probButtonsGroup.isVisible = false
		backButtonGroup.isVisible = false
	elseif (num == 3) then
		probButtonsGroup.isVisible = false
		backButtonGroup.isVisible = false
	elseif (num == 4) then
		probButtonsGroup.isVisible = false
		backButtonGroup.isVisible = false
	else
		print("Unknown State: " .. num)
	end
end

--take care of everything necessary to quit the game
function exitFixit()
	exitState(fixitState)
	fixitState = 0
	enterState(fixitState)
	dGroup.isVisible = false
end

--handle button presses
function buttonHandler(event)
	exitState(fixitState)
	if(event.target.id == "BackLarge") then
		exitFixit()
	elseif(event.target.id == "PlayGame") then
		fixitState = math.random(1,4) --select a random state between 1 and 4
		print("Randomly chosen state: " .. fixitState)
	elseif(event.target.id == "Back") then
		if(fixitState >= 1 and fixitState <= 4) then
			fixitState = 0
		end
	else
		print("Unknown button: ".. event.target.id)
	end
	enterState(fixitState)
end

function M:makeDisplay()
	--create overall display group
	dGroup = display.newGroup()
	--create other display groups
	titleGroup = display.newGroup()
	probButtonsGroup = display.newGroup()
	backButtonGroup = display.newGroup()
	--make background rectangle
	local bkg = display.newRect(display.contentCenterX, display.contentCenterY, gW, gH)
	bkg:setFillColor(0.3, 0.5, 0.9, 1)
	------------------
	-- TITLE SCREEN --
	------------------
	--make title text (shrink until it fits on one line)
	local i = 31
	repeat
		if(titleText ~= nil) then
			titleText:removeSelf()
			titleText = nil
		end
		if(testText ~= nil) then
			testText:removeSelf()
			testText = nil
		end
		i = i - 1
		titleText = display.newText(
			{
				text="Can you fix the drop tower?",
				x=display.contentCenterX,
				y=gH * 0.060,
				width=gW * 0.95,
				font=native.systemFontBold,
				fontSize=i,
				align="center"
			})
		testText = display.newText(
			{
				--Test string covers max height and min height characters, and is short enough to not break into 2 lines
				text="Ay",
				x=display.contentCenterX,
				y=gH * 0.125,
				width=gW,
				font=native.systemFontBold,
				fontSize=i,
				align="center"
			})
	until titleText.height <= testText.height or i == 1
	titleText:setFillColor(1,1,1,1)
	testText:removeSelf()
	testText = nil
	--make drop shadow text
	dropShadowTitle = display.newText(
			{
				text="Can you fix the drop tower?",
				x=gW * 0.51,
				y=gH * 0.065,
				width=gW * 0.95,
				font=native.systemFontBold,
				fontSize=i,
				align="center",
			})
	dropShadowTitle:setFillColor(0,0,0,.5)
	--make description text (no need to resize; there's plenty of room)
	local descText = display.newText(
			{
				text="There's been a problem with the drop tower! Based on a description of the problem, you'll need to find out where on the tower the problem is occurring and then do what needs to be done to fix it!",
				x=display.contentCenterX,
				y=gH * 0.275,
				width=gW * 0.95,
				font=native.systemFont,
				fontSize=16,
				align="center"
			})
	--make buttons
	--"Play game" button
	playGameButton = widget.newButton(
		{
			id = "PlayGame",
			x = display.contentCenterX,
			y = gH * 0.575,
			width = gW * 0.666,
			height = gH * 0.175,
			shape = "rectangle",
			fillColor = { default={ .75,.75,.75,1 }, over={ 1,1,1,1 } },
			font = native.systemFont,
			fontSize = 24,
			label = "Play Game",
			labelColor = { default={ 0,0,0,1 }, over={ 0,0,0,1 } },
			strokeColor = { default={ .25,.25,.25 }, over={ 0.5,0.5,0.5 } },
			strokeWidth = 3,
			onRelease = buttonHandler
		})
	backButtonL = widget.newButton(
		{
			id = "BackLarge",
			x = display.contentCenterX,
			y = gH * 0.825,
			width = gW * 0.666,
			height = gH * 0.170,
			shape = "rectangle",
			fillColor = { default={ .75,.75,.75,1 }, over={ 1,1,1,1 } },
			font = native.systemFont,
			fontSize = 24,
			label = "Go Back",
			labelColor = { default={ 0,0,0,1 }, over={ 0,0,0,1 } },
			strokeColor = { default={ .25,.25,.25 }, over={ 0.5,0.5,0.5 } },
			strokeWidth = 3,
			onRelease = buttonHandler
		})
	backgroundButton = widget.newButton(
		{
			id = "Background",
			x = display.contentCenterX,
			y = display.contentCenterY,
			width = gW,
			height = gH,
			shape = "rectangle",
			fillColor = { default={ 0,0,0,1 }, over={ 0,0,0,1 } },
			onRelease = buttonHandler
		})
	--insert objects into titleGroup
	titleGroup:insert(dropShadowTitle)
	titleGroup:insert(titleText)
	titleGroup:insert(descText)
	titleGroup:insert(playGameButton)
	titleGroup:insert(backButtonL)
	
	---------------------
	-- PROBLEM BUTTONS --
	---------------------
	winchGuessButton = widget.newButton(
		{
			id = "WinchGuess",
			x = gW* .25,
			y = gH * 0.45,
			width = gW * 0.3,
			height = gH * 0.175,
			shape = "roundedRect",
			cornerRadius = 6,
			fillColor = { default={ .75,.75,.75,1 }, over={ 1,1,1,1 } },
			font = native.systemFont,
			fontSize = 18,
			label = "Winch",
			labelColor = { default={ 0,0,0,1 }, over={ 0,0,0,1 } },
			strokeColor = { default={ .25,.25,.25 }, over={ 0.5,0.5,0.5 } },
			strokeWidth = 3,
			onRelease = buttonHandler
		})
	nettingGuessButton = widget.newButton(
		{
			id = "NettingGuess",
			x = gW* .75,
			y = gH * 0.45,
			width = gW * 0.3,
			height = gH * 0.175,
			shape = "roundedRect",
			cornerRadius = 6,
			fillColor = { default={ .75,.75,.75,1 }, over={ 1,1,1,1 } },
			font = native.systemFont,
			fontSize = 18,
			label = "Netting",
			labelColor = { default={ 0,0,0,1 }, over={ 0,0,0,1 } },
			strokeColor = { default={ .25,.25,.25 }, over={ 0.5,0.5,0.5 } },
			strokeWidth = 3,
			onRelease = buttonHandler
		})
	capsuleGuessButton = widget.newButton(
		{
			id = "CapsuleGuess",
			x = gW* .25,
			y = gH * 0.73,
			width = gW * 0.3,
			height = gH * 0.175,
			shape = "roundedRect",
			cornerRadius = 6,
			fillColor = { default={ .75,.75,.75,1 }, over={ 1,1,1,1 } },
			font = native.systemFont,
			fontSize = 18,
			label = "Capsule",
			labelColor = { default={ 0,0,0,1 }, over={ 0,0,0,1 } },
			strokeColor = { default={ .25,.25,.25 }, over={ 0.5,0.5,0.5 } },
			strokeWidth = 3,
			onRelease = buttonHandler
		})
	decelGuessButton = widget.newButton(
		{
			id = "DecelGuess",
			x = gW* .75,
			y = gH * 0.73,
			width = gW * 0.3,
			height = gH * 0.175,
			shape = "roundedRect",
			cornerRadius = 6,
			fillColor = { default={ .75,.75,.75,1 }, over={ 1,1,1,1 } },
			font = native.systemFont,
			fontSize = 18,
			label = "Deceleration\nChamber",
			labelColor = { default={ 0,0,0,1 }, over={ 0,0,0,1 } },
			strokeColor = { default={ .25,.25,.25 }, over={ 0.5,0.5,0.5 } },
			strokeWidth = 3,
			onRelease = buttonHandler
		})
	--make question text (resize to fit on one line)
	i = 31
	repeat
		if(questionText ~= nil) then
			questionText:removeSelf()
			questionText = nil
		end
		if(testText ~= nil) then
			testText:removeSelf()
			testText = nil
		end
		i = i - 1
		questionText = display.newText(
			{
				text="Where is the problem?",
				x=display.contentCenterX,
				y=gH * 0.285,
				width=gW * 0.95,
				font=native.systemFontBold,
				fontSize=i,
				align="center"
			})
		testText = display.newText(
			{
				--Test string covers max height and min height characters, and is short enough to not break into 2 lines
				text="Ay",
				x=display.contentCenterX,
				y=gH * 0.125,
				width=gW,
				font=native.systemFontBold,
				fontSize=i,
				align="center"
			})
	until questionText.height <= testText.height or i == 1
	questionText:setFillColor(1,1,1,1)
	testText:removeSelf()
	testText = nil
	--insert problem text display box
	probTextBox = display.newRect(display.contentCenterX, gH * 0.125, gW * 0.95, gH * 0.2)
	probTextBox:setFillColor(1, 1, 1, 1)
	probTextBox.strokeWidth = 3
	probTextBox:setStrokeColor(0,0,0,1)
	
	--insert objects into problem button group
	probButtonsGroup:insert(winchGuessButton)
	probButtonsGroup:insert(nettingGuessButton)
	probButtonsGroup:insert(capsuleGuessButton)
	probButtonsGroup:insert(decelGuessButton)
	probButtonsGroup:insert(questionText)
	probButtonsGroup:insert(probTextBox)
	probButtonsGroup.isVisible = false
	
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
	backButtonGroup.isVisible = false
	
	--insert objects into the major display group
	dGroup:insert(backgroundButton)
	dGroup:insert(bkg)
	dGroup:insert(titleGroup)
	dGroup:insert(probButtonsGroup)
	dGroup:insert(backButtonGroup)
	
	--set object variables (so they can be accessed elsewhere)
	self.dGroup = dGroup
	self.titleGroup = titleGroup
end

return M