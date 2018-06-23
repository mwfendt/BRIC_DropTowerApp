
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
		winchProblemGroup.isVisible = true
	elseif (num == 2) then
		probButtonsGroup.isVisible = true
		backButtonGroup.isVisible = true
		capsuleProblemGroup.isVisible = true
	elseif (num == 3) then
		probButtonsGroup.isVisible = true
		backButtonGroup.isVisible = true
		nettingProblemGroup.isVisible = true
	elseif (num == 4) then
		probButtonsGroup.isVisible = true
		backButtonGroup.isVisible = true
		decelProblemGroup.isVisible = true
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
		winchProblemGroup.isVisible = false
	elseif (num == 2) then
		probButtonsGroup.isVisible = false
		backButtonGroup.isVisible = false
		capsuleProblemGroup.isVisible = false
	elseif (num == 3) then
		probButtonsGroup.isVisible = false
		backButtonGroup.isVisible = false
		nettingProblemGroup.isVisible = false
	elseif (num == 4) then
		probButtonsGroup.isVisible = false
		backButtonGroup.isVisible = false
		decelProblemGroup.isVisible = false
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
		--fixitState = 2
		print("Randomly chosen state: " .. fixitState)
	elseif(event.target.id == "Back") then
		if(fixitState >= 1 and fixitState <= 4) then
			fixitState = 0
		end
	elseif(event.target.id == "Darkener") then
		incorrectGroup.isVisible = false
	elseif(event.target.id == "WinchGuess") then
		if(fixitState == 1) then
			--correct guess
			correctGroup.isVisible = true
		else
			--incorrect guess
			incorrectGroup.isVisible = true
		end
	elseif(event.target.id == "CapsuleGuess") then
		if(fixitState == 2) then
			--correct guess
			correctGroup.isVisible = true
		else
			--incorrect guess
			incorrectGroup.isVisible = true
		end
	elseif(event.target.id == "NettingGuess") then
		if(fixitState == 3) then
			--correct guess
			correctGroup.isVisible = true
		else
			--incorrect guess
			incorrectGroup.isVisible = true
		end
	elseif(event.target.id == "DecelGuess") then
		if(fixitState == 4) then
			--correct guess
			correctGroup.isVisible = true
		else
			--incorrect guess
			incorrectGroup.isVisible = true
		end
	elseif(event.target.id == "CDarkener") then
		correctGroup.isVisible = false
		fixitState = fixitState + 4
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
	winchProblemGroup = display.newGroup()
	capsuleProblemGroup = display.newGroup()
	nettingProblemGroup = display.newGroup()
	decelProblemGroup = display.newGroup()
	incorrectGroup = display.newGroup()
	correctGroup = display.newGroup()
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
	
	-------------------
	-- WINCH PROBLEM --
	-------------------
	--create problem description text, resizing to fit box
	i = 25
	repeat
		if(winchProbText ~= nil) then
			winchProbText:removeSelf()
		end
		i = i - 1
		winchProbText = display.newText(
			{
				text="The drop capsule cannot be raised to its starting height.",
				x=probTextBox.x,
				y=probTextBox.y,
				width=probTextBox.width - 6, --keep inside the lines
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until winchProbText.height <= probTextBox.height or i == 1
	winchProbText:setFillColor(0,0,0,1)
	--insert into group
	winchProblemGroup:insert(winchProbText)
	winchProblemGroup.isVisible = false
	
	---------------------
	-- CAPSULE PROBLEM --
	---------------------
	--create problem description text, resizing to fit box
	i = 25
	repeat
		if(capsuleProbText ~= nil) then
			capsuleProbText:removeSelf()
		end
		i = i - 1
		capsuleProbText = display.newText(
			{
				text="The drop capsule launch was initiated ten minutes ago, but the capsule has not yet fallen.",
				x=probTextBox.x,
				y=probTextBox.y,
				width=probTextBox.width - 6, --keep inside the lines
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until capsuleProbText.height <= probTextBox.height or i == 1
	capsuleProbText:setFillColor(0,0,0,1)
	--insert into group
	capsuleProblemGroup:insert(capsuleProbText)
	capsuleProblemGroup.isVisible = false
	
	---------------------
	-- NETTING PROBLEM --
	---------------------
	--create problem description text, resizing to fit box
	i = 25
	repeat
		if(nettingProbText ~= nil) then
			nettingProbText:removeSelf()
		end
		i = i - 1
		nettingProbText = display.newText(
			{
				text="There is a thick metal cord that appears to have fallen into the drop chamber.",
				x=probTextBox.x,
				y=probTextBox.y,
				width=probTextBox.width - 6, --keep inside the lines
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until nettingProbText.height <= probTextBox.height or i == 1
	nettingProbText:setFillColor(0,0,0,1)
	--insert into group
	nettingProblemGroup:insert(nettingProbText)
	nettingProblemGroup.isVisible = false
	
	--------------------------
	-- DECELERATION PROBLEM --
	--------------------------
	--create problem description text, resizing to fit box
	i = 25
	repeat
		if(decelProbText ~= nil) then
			decelProbText:removeSelf()
		end
		i = i - 1
		decelProbText = display.newText(
			{
				text="The drop capsule decelerates far too rapidly for the safety of the experiments inside.",
				x=probTextBox.x,
				y=probTextBox.y,
				width=probTextBox.width - 6, --keep inside the lines
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until decelProbText.height <= probTextBox.height or i == 1
	decelProbText:setFillColor(0,0,0,1)
	--insert into group
	decelProblemGroup:insert(decelProbText)
	decelProblemGroup.isVisible = false
	
	----------------------------
	-- INCORRECT ANSWER POPUP --
	----------------------------
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
	incorrectBox = display.newRect(display.contentCenterX, display.contentCenterY, gW * 0.8, gH * 0.25)
	incorrectBox:setFillColor(1, 1, 1, 1)
	incorrectBox.strokeWidth = 3
	incorrectBox:setStrokeColor(1,0,0,1)
	--create text and shrink to box
	i = 31
	repeat
		if(incorrectText ~= nil) then
			incorrectText:removeSelf()
		end
		i = i - 1
		incorrectText = display.newText(
			{
				text="Whoops!\nThat's not quite right. Try again!",
				x=incorrectBox.x,
				y=incorrectBox.y,
				width=incorrectBox.width - 6, --keep inside the lines
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until incorrectText.height <= incorrectBox.height or i == 1
	incorrectText:setFillColor(1,0,0,1)
	--insert into group
	incorrectGroup:insert(darkenerButton)
	incorrectGroup:insert(incorrectBox)
	incorrectGroup:insert(incorrectText)
	incorrectGroup.isVisible = false
	
	--------------------------
	-- CORRECT ANSWER POPUP --
	--------------------------
	correctDarkenerButton = widget.newButton(
		{
			id = "CDarkener",
			x = display.contentCenterX,
			y = display.contentCenterY,
			width = gW,
			height = gH,
			shape = "rectangle",
			fillColor = { default={ 0,0,0,0.85 }, over={ 0,0,0,0.85 } },
			onRelease = buttonHandler
		})
	--create box for text to appear on
	correctBox = display.newRect(display.contentCenterX, display.contentCenterY, gW * 0.8, gH * 0.25)
	correctBox:setFillColor(1, 1, 1, 1)
	correctBox.strokeWidth = 3
	correctBox:setStrokeColor(0,.8,0,1)
	--create text and shrink to box
	i = 31
	repeat
		if(correctText ~= nil) then
			correctText:removeSelf()
		end
		i = i - 1
		correctText = display.newText(
			{
				text="Good job!\nTap to continue.",
				x=correctBox.x,
				y=correctBox.y,
				width=correctBox.width - 6, --keep inside the lines
				font=native.systemFont,
				fontSize=i,
				align="center"
			})
	until correctText.height <= correctBox.height or i == 1
	correctText:setFillColor(0,0.8,0,1)
	--insert into group
	correctGroup:insert(correctDarkenerButton)
	correctGroup:insert(correctBox)
	correctGroup:insert(correctText)
	correctGroup.isVisible = false
	
	--insert objects into the major display group
	dGroup:insert(backgroundButton)
	dGroup:insert(bkg)
	dGroup:insert(titleGroup)
	dGroup:insert(probButtonsGroup)
	dGroup:insert(backButtonGroup)
	dGroup:insert(winchProblemGroup)
	dGroup:insert(capsuleProblemGroup)
	dGroup:insert(nettingProblemGroup)
	dGroup:insert(decelProblemGroup)
	dGroup:insert(incorrectGroup)
	dGroup:insert(correctGroup)
	
	--set object variables (so they can be accessed elsewhere)
	self.dGroup = dGroup
	--self.titleGroup = titleGroup
end

return M