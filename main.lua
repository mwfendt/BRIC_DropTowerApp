
-- BRIC Drop Tower App
-- Version: 0.01
-- main.lua
---------------------------------------------------------------------------------------

-- Hide device status bar
display.setStatusBar( display.HiddenStatusBar )
-- Require libraries/plugins
local widget = require( "widget" )

---------------------
-- BUTTON HANDLERS --
---------------------

local function endVideo()
	if (video ~= nil) then
		video:removeSelf()
		video = nil
	end
	stopVidButton.isVisible = false
end

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
		end
	end
end

--handles button presses for the various sections of the drop tower
local sectionButtonHandler = function( event )
	animFrames = 10
	if(appState == 0) then
		--display the video button
		--videoGroup.isVisible = true
		--figure out which section to display then display it
		if(event.target.id == "DropCapsule") then
			--go to zoomed drop capsule state
			appState = 1
			capsuleGroup.isVisible = true
		elseif (event.target.id == "Netting") then
			--go to zoomed netting state
			appState = 2
			nettingGroup.isVisible = true
		elseif (event.target.id == "Winch") then
			--go to zoomed winch state
			appState = 3
			winchGroup.isVisible = true
		elseif (event.target.id == "DecelContainer") then
			--go to zoomed decelration chamber state
			appState = 4
			decelGroup.isVisible = true
		elseif(event.target.id == "ExperimentButton") then
			--go to Experiment Menu
			appState = 5
			experimentGroup.isVisible = true
			video = native.newVideo(gW * 1.45, display.contentCenterY * 1.05, gW / 2.35, gH / 2.6)
			video:load("videos/ExperimentPageVid.mp4")
			video:addEventListener("video", videoListener)
		end
		
		--if the appState has been changed, disable all buttons on this screen
		if(appState ~= 0) then
			--turning buttons invisible also deactivates them, and is actually the ideal way to deactivate them
			mainMenuButtons.isVisible = false;
		end
	else
		--do nothing, report that handler fired when it shouldn't have
		print("WARNING: Button \"" .. event.target.id .. "\" fired when it shouldn't have")
	end
end

--handles button presses for the full-screen button
local screenButtonHandler = function ( event )
	videoGroup.isVisible = false
	if(appState == 1) then
		--dismiss drop capsule zoomed image
		capsuleGroup.isVisible = false
		appState = 0
	elseif (appState == 2) then
		--dismiss net zoomed image
		nettingGroup.isVisible = false
		appState = 0
	elseif (appState == 3) then
		--dismiss winch zoomed image
		winchGroup.isVisible = false
		appState = 0
	elseif (appState == 4) then
		decelGroup.isVisible = false
		appState = 0
	elseif(appState == 5) then 
		endVideo()
		experimentGroup.isVisible = false
		appState = 0
	end
	if(appState == 0) then
		--if the appState brings you back to the main menu, enable the main menu buttons
		mainMenuButtons.isVisible = true
	end
end

--declaration of handler for BaylorLogo button
local function handleBaylorEvent(event)

	if("ended" == event.phase) then 
		system.openURL("https://www.baylor.edu")
	end
end

--delaration of handler for BricLogo button
local function handleBricEvent(event)

	if("ended" == event.phase) then
		system.openURL("https://www.baylor.edu/bric")
	end
end

local function handleVideo(event)
	if(appState == 0) then
		print("WARNING: handleVideo called when appState was 0")
	elseif (appState >= 1 and appState <= 5) then
		stopVidButton.isVisible = true
		video = native.newVideo(gW * 0.5, gH * 0.5, gW, gW * 0.75)
		video:load( "videos/PlaceholderVid" ..appState.. ".mp4")
		video:addEventListener( "video", videoListener )
	else
		print("WARNING: No video for appstate "..appstate.." (yet)")
	end
end

local function handleMicroGravEvent(event)
	if("ended" == event.phase) then	
		microGravText.text = "Microgravity is everything"
		microGravText.x = gW * 0.5
		microGravText.y = gH * 0.125
		 
	end
end 
-----------------
-- ACTUAL CODE --
-----------------

--get global height and width
gH = display.contentHeight
gW = display.contentWidth

--animFrames should be 0 when no animation is happening
animFrames = 0

--set state
appState = 0
-- STATES: --
-- 0 - Main screen
-- 1 - Close-up of capsule
-- 2 - Close-up of netting
-- 3 - Close-up of winch
-- 4 - Close-up of deceleration container
-- 5 - Experiment State 

--the screen-sized button can't be invisible in order for it to work, so it needs to be behind everything else
screenSizedButton = widget.newButton(
	{
		id = "screen",
		x = display.contentCenterX,
		y = display.contentCenterY,
		width = gW,
		height = gH,
		shape = "rectangle",
		fillColor = { default={ 0,0,0,1 }, over={ 0,0,0,1 } },
		onRelease = screenButtonHandler
	})

--display background image (width and height are required in function but overwritten later)
local bkg = display.newImageRect( "images/DropTowerDiagram.png", gW, gH )
bkg.x = display.contentCenterX
bkg.y = display.contentCenterY

------------------------------
-- DECLARING DISPLAY GROUPS --
--      ORDER MATTERS!      --
------------------------------
mainMenuButtons = display.newGroup()
capsuleGroup = display.newGroup()
capsuleGroup.isVisible = false
nettingGroup = display.newGroup()
nettingGroup.isVisible = false
winchGroup = display.newGroup()
winchGroup.isVisible = false
decelGroup = display.newGroup()
decelGroup.isVisible = false
experimentGroup = display.newGroup()
experimentGroup.isVisible = false
videoGroup = display.newGroup()
videoGroup.isVisible = false

-- videos jump to the front no matter when they're declared, but declare last to remind ourselves
video = nil

--decelration container button
decelButton = widget.newButton(
	{
		id = "DecelContainer",
		x = gW * 0.397,
		y = gH * 0.629,
		width = gW * 0.250,
		height = gH * 0.172,
		shape = "rectangle",
		fillColor = { default={ 1,0,0,0.25 }, over={ 1,0,0,0.5 } },
		--strokeColor = { default={ 1,0,0 }, over={ 1,0,0 } },
		--strokeWidth = 1,
		onRelease = sectionButtonHandler
	})
mainMenuButtons:insert(decelButton)	
	
--netting button
netButton = widget.newButton(
	{
		id = "Netting",
		x = gW * 0.397,
		y = gH * 0.404,
		width = gW * 0.250,
		height = gH * 0.278,
		shape = "rectangle",
		fillColor = { default={ 0,1,0,0.25 }, over={ 0,1,0,0.5 } },
		--strokeColor = { default={ 0,1,0 }, over={ 0,1,0 } },
		--strokeWidth = 1,
		onRelease = sectionButtonHandler
	})
mainMenuButtons:insert(netButton)
	
--drop capsule button	
capsuleButton = widget.newButton(
	{
		id = "DropCapsule",
		x = gW * 0.397,
		y = gH * 0.199,
		width = gW * 0.250,
		height = gH * 0.132,
		shape = "rectangle",
		fillColor = { default={ 0,0,1,0.25 }, over={ 0,0,1,0.5 } },
		--strokeColor = { default={ 0, 0, 1 }, over={ 0, 0, 1 } },
		--strokeWidth = 1,
		onRelease = sectionButtonHandler
	})
--capsuleButton:setStrokeColor(0,0,1,1)
--capsuleButton.strokeWidth = 20
mainMenuButtons:insert(capsuleButton)

--winch button	
winchButton = widget.newButton(
	{
		id = "Winch",
		x = gW * 0.586,
		y = gH * 0.282,
		width = gW * 0.128,
		height = gH * 0.086,
		shape = "rectangle",
		fillColor = { default={ 1,1,0,0.25 }, over={ 1,1,0,0.5 } },
		--strokeColor = { default={ 1,1,0 }, over={ 1,1,0 } },
		--strokeWidth = 1,
		onRelease = sectionButtonHandler
	})
mainMenuButtons:insert(winchButton)

-- drop capsule display group --
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
			text="The FitnessGram™ Pacer Test is a multistage aerobic capacity test that progressively gets more difficult as it continues. The 20 meter pacer test will begin in 30 seconds. Line up at the start. The running speed starts slowly, but gets faster each minute after you hear this signal. [beep] A single lap should be completed each time you hear this sound. [ding] Remember to run in a straight line, and run as long as possible. The second time you fail to complete a lap before the sound, your test is over. The test will begin on the word start. On your mark, get ready, start.",
			x=dropCapTextBkg.x,
			y=dropCapTextBkg.y, --change to align top?
			width=dropCapTextBkg.width,
			font=native.systemFont,
			fontSize=i,
			align="center"
		})
until dropCapText.height <= dropCapTextBkg.height or i == 1
dropCapText:setFillColor(0,0,0,1)
--insert all into group
capsuleGroup:insert(dropCapZoomed)
capsuleGroup:insert(dropCapTextBkg)
capsuleGroup:insert(dropCapText)

-- netting display group --
--zoomed netting image
netZoomed = display.newImageRect("images/Netting.jpg", gW, gH)
netZoomed.x = display.contentCenterX
netZoomed.y = display.contentCenterY
--rectangle to display text on
nettingTextBkg = display.newRect(gW * 0.5, gH * 0.125, gW, gH * 0.25)
nettingTextBkg:setFillColor(1,1,1,0.85)
--text to display (shrink until it fits in the box)
i = 31
repeat
	if(nettingText ~= nil) then
		nettingText:removeSelf()
	end
	i = i - 1
	nettingText = display.newText(
		{
			text="Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It’s not a story the Jedi would tell you. It’s a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying. The dark side of the Force is a pathway to many abilities some consider to be unnatural. He became so powerful… the only thing he was afraid of was losing his power, which eventually, of course, he did. Unfortunately, he taught his apprentice everything he knew, then his apprentice killed him in his sleep. Ironic. He could save others from death, but not himself.",
			x=nettingTextBkg.x,
			y=nettingTextBkg.y,
			width=nettingTextBkg.width,
			font=native.systemFont,
			fontSize=i,
			align="center"
		})
until nettingText.height <= nettingTextBkg.height or i == 1
nettingText:setFillColor(0,0,0,1)
--insert all into group
nettingGroup:insert(netZoomed)
nettingGroup:insert(nettingTextBkg)
nettingGroup:insert(nettingText)

-- winch display group --
--zoomed winch image
winchZoomed = display.newImageRect("images/Winch.jpg",gW, gH)
winchZoomed.x = display.contentCenterX
winchZoomed.y = display.contentCenterY
--rectangle to display text on
winchTextBkg = display.newRect(gW * 0.5, gH * 0.125, gW, gH * 0.25)
winchTextBkg:setFillColor(1,1,1,0.85)
--text to display (shrink until it fits in the box)
i = 31
repeat
	if(winchText ~= nil) then
		winchText:removeSelf()
	end
	i = i - 1
	winchText = display.newText(
		{
			text="Something shorter",
			x=winchTextBkg.x,
			y=winchTextBkg.y,
			width=winchTextBkg.width,
			font=native.systemFont,
			fontSize=i,
			align="center"
		})
until winchText.height <= winchTextBkg.height or i == 1
winchText:setFillColor(0,0,0,1)
--insert all into group
winchGroup:insert(winchZoomed)
winchGroup:insert(winchTextBkg)
winchGroup:insert(winchText)

-- decel chamber display group --
--zoomed deceleration container image
decelZoomed = display.newImageRect("images/DecelContainer.jpg", gW, gH)
decelZoomed.x = display.contentCenterX
decelZoomed.y = display.contentCenterY
--rectangle to display text on
decelTextBkg = display.newRect(gW * 0.5, gH * 0.125, gW, gH * 0.25)
decelTextBkg:setFillColor(1,1,1,0.85)
--text to display (shrink until it fits in the box)
i = 31
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
--insert all into group
decelGroup:insert(decelZoomed)
decelGroup:insert(decelTextBkg)
decelGroup:insert(decelText)


--experiment capsule container background 
expBkg = display.newRect(display.contentCenterX, display.contentCenterY, gW, gH)
expBkg:setFillColor(1,1,1,1)
experimentGroup:insert(expBkg)

--video play button group
--"Play video" button
playVidButton = widget.newButton(
	{
		id = "VidPlay",
		x = gW * 0.125,
		y = gH * 0.975,
		width = gW * 0.250,
		height = gH * 0.050,
		shape = "rectangle",
		fillColor = { default={ .75,.75,.75,1 }, over={ 1,1,1,1 } },
		font = native.systemFont,
		fontSize = 12,
		label = "Play Video",
		labelColor = { default={ 0,0,0,1 }, over={ 0,0,0,1 } },
		onRelease = handleVideo
	})
stopVidButton = widget.newButton(
	{
		id = "VidStop",
		x = gW * 0.5,
		y = gH * 0.5,
		width = gW,
		height = gH,
		shape = "rectangle",
		fillColor = { default={ 0,0,0,.85 }, over={ 0,0,0,.85 } },
		font = native.systemFont,
		fontSize = 20,
		label = "Loading...",
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
		onRelease = endVideo
	})
stopVidButton.isVisible = false
videoGroup:insert(playVidButton)
videoGroup:insert(stopVidButton)

--top border image
borderImage = display.newImageRect("images/radialGradient3.png", (gW/2), (gH /10))
borderImage.x = display.contentCenterX
borderImage.y = display.contentCenterY / 10
mainMenuButtons:insert(borderImage)

--experiment capsule container image

expCapsule = display.newImageRect("images/DropCapsule2.jpg", gW / 2, gH / 2)
expCapsule.x = display.contentCenterX / 2
expCapsule.y = display.contentCenterY
experimentGroup:insert(expCapsule)
		
--experimentPage images

secondsSection = display.newRect(display.contentCenterX * 1.45, display.contentCenterY, gW / 2.25, gH / 2.5)
secondsSection:setFillColor(0,.85,0,1)
experimentGroup:insert(secondsSection)

-- baylor button
local baylorButton = widget.newButton(
	{
		id = "BaylorLogo",
		defaultFile = "images/BaylorGreen.png",
		overFile = "images/BaylorGreen.png",
		onEvent = handleBaylorEvent,
		x = display.contentCenterX / 2,
		width = display.contentCenterX,
		y = gH - (gH * 0.086 * 0.5),
		height = gH * 0.086
	})
mainMenuButtons:insert(baylorButton)

-- bric button 
local bricButton = widget.newButton(
	{
		id = "BRICLogo",
		defaultFile = "images/BRICWhite.png",
		overFile = "images/BRICWhite.png",
		onEvent = handleBricEvent,
		x = display.contentCenterX * 1.5,
		width = display.contentCenterX,

		y = gH - (gH * 0.086 * 0.5),
		height = gH * 0.086
	})
mainMenuButtons:insert(bricButton)

-- experimentButton 
local experimentButton = widget.newButton(
	{
		id = "ExperimentButton",
		defaultFile = "images/DropCapsule2.jpg",
		overFile = "images/DropCapsule2.jpg",
		onRelease = sectionButtonHandler,

		x = display.contentCenterX * 1.60,
		width = gH * 0.125,

		y = gH - (gH * 0.19),
		height = gH * 0.125
	})
mainMenuButtons:insert(experimentButton)

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
	})
experimentGroup:insert(expPageButtonBottom)



-- options for text below experiment button
local experimentTextOptions = 
	{
		text = "Start your own experiment!",
		x = display.contentCenterX * 1.60,
		y = gH - (gH * 0.11),
		font = native.systemFont,
		fontSize = 10
	}
	
-- options for text in the header border
local headerTextOptions = 
	{
		text = " Learn about Microgravity\nusing Baylor's Drop Tower!",
		x = display.contentCenterX,
		align = "center",
		y = gH / 20,
		font = native.systemFont,
		fontSize = 12
	}
	
--create and insert the text into the main menu
local experimentText = display.newText(experimentTextOptions)
experimentText:setFillColor(0,0,0,1)
mainMenuButtons:insert(experimentText)

local headerText = display.newText(headerTextOptions)
headerText:setFillColor(0,0,0,1)
mainMenuButtons:insert(headerText)

--create the text for the experiment page 
microGravTextOptions = 
	{
		text = "What is microgravity?",
		x = gW * 0.5,
		y = gH * 0.125,
		align = center,
		font = native.systemFont,
		fontSize = 20
	}
	
startExperimentTextOptions = 
	{
		text = "Create an experiment!",
		x = gW * 0.5,
		y = gH * 0.875,
		align = center,
		font = native.systemFont,
		fontSize = 20
	}

secondsTextOptions = 
	{
		text = "1.5 Seconds... That seems short!\n\n What else is 1.5 seconds long?",
		x = display.contentCenterX * 1.45,
		y = display.contentCenterY * 0.70,
		align = center,
		font = native.systemFont,
		fontSize = 12
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

-- Enter Frame functions (handle animation) --
function capsuleGroup:enterFrame (event)
	if(animFrames > 0 and appState == 1) then

		animFrames = animFrames - 1
		local newScale = 1 - (animFrames * 0.1)
		self.xScale = newScale
		self.yScale = newScale
		self.x = display.contentCenterX * (1-newScale)
		self.y = display.contentCenterY * (1-newScale)
		if(animFrames == 0) then
			videoGroup.isVisible = true
		end
	end
end
function winchGroup:enterFrame (event)
	if(animFrames > 0 and appState == 3) then

		animFrames = animFrames - 1
		local newScale = 1 - (animFrames * 0.1)
		self.xScale = newScale
		self.yScale = newScale
		self.x = display.contentCenterX * (1-newScale)
		self.y = display.contentCenterY * (1-newScale)
		if(animFrames == 0) then
			videoGroup.isVisible = true
		end
	end
end
function nettingGroup:enterFrame (event)
	if(animFrames > 0 and appState == 2) then

		animFrames = animFrames - 1
		local newScale = 1 - (animFrames * 0.1)
		self.xScale = newScale
		self.yScale = newScale
		self.x = display.contentCenterX * (1-newScale)
		self.y = display.contentCenterY * (1-newScale)
		if(animFrames == 0) then
			videoGroup.isVisible = true
		end
	end
end
function decelGroup:enterFrame (event)
	if(animFrames > 0 and appState == 4) then

		animFrames = animFrames - 1
		local newScale = 1 - (animFrames * 0.1)
		self.xScale = newScale
		self.yScale = newScale
		self.x = display.contentCenterX * (1-newScale)
		self.y = display.contentCenterY * (1-newScale)
		if(animFrames == 0) then
			videoGroup.isVisible = true
		end
	end
end
function experimentGroup:enterFrame (event)
	if(animFrames > 0 and appState == 5) then

		animFrames = animFrames - 1
		local newScale = 1 - (animFrames * 0.1)
		self.xScale = newScale
		self.yScale = newScale
		self.x = display.contentCenterX * (1-newScale)
		self.y = display.contentCenterY * (1-newScale)
	end
end


Runtime:addEventListener( "enterFrame", capsuleGroup )
Runtime:addEventListener( "enterFrame", nettingGroup )
Runtime:addEventListener( "enterFrame", winchGroup )
Runtime:addEventListener( "enterFrame", decelGroup )
Runtime:addEventListener( "enterFrame", experimentGroup )
