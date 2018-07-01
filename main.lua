
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
	--animFrames = 10
	if(appState == 0) then
		--figure out which section to display then display it
		if(event.target.id == "DropCapsule") then
			--go to zoomed drop capsule state
			appState = 1
			capsuleInfo:reveal()
		elseif (event.target.id == "Netting") then
			--go to zoomed netting state
			appState = 2
			nettingInfo:reveal()
		elseif (event.target.id == "Winch") then
			--go to zoomed winch state
			appState = 3
			winchInfo:reveal()
		elseif (event.target.id == "DecelContainer") then
			--go to zoomed decelration chamber state
			appState = 4
			decelInfo:reveal()
		elseif(event.target.id == "ExperimentButton") then
			--go to Experiment Menu
			appState = 5
			--experimentGroup.isVisible = true
			experimentPage:reveal()
			--video = native.newVideo(display.contentCenterX * 1.45, display.contentCenterY * 1.025, display.contentCenterX * .6, display.contentCenterY * .5)
			--video:load("videos/ExperimentPageVid.mp4")
			--video:addEventListener("video", videoListener)
		elseif(event.target.id == "RepairButton") then
			--go to fixit
			--appState = 6
			--animFrames = 0
			--fixItGroup.isVisible = true
			fixIt:reveal()
		elseif(event.target.id == "DropTowerButton") then
			--go to Drop Tower Info
			appState = 7
			dropInfoPage:reveal()
			--video = native.newVideo(gW * 0.5, gH * 0.475, gW, gW * 0.75)
			--video:load("videos/PlaceholderVid5.mp4")
			--video:addEventListener("video", videoListener)
			--dropTowerGroup.isVisible = true
			
		end
	elseif(appState == 5) then
		appState = 6
		experimentGroup.isVisible = false
		createExpGroup.isVisible = true
		--if(video ~= nil) then
			--endVideo()
		--end
		--if the appState has been changed, disable all buttons on this screen
	else
		--do nothing, report that handler fired when it shouldn't have
		print("WARNING: Button \"" .. event.target.id .. "\" fired when it shouldn't have")
	end
	if(appState ~= 0) then
		--turning buttons invisible also deactivates them, and is actually the ideal way to deactivate them
		mainMenuButtons.isVisible = false
	end
end

--handles button presses for the full-screen button
local screenButtonHandler = function ( event )
	videoGroup.isVisible = false
	if(appState == 5) then 
		--endVideo()
		--experimentGroup.isVisible = false
		--appState = 0
	elseif(appState == 6) then
		createExpGroup.isVisible = false
		experimentGroup.isVisible = true
		appState = 5
		video = native.newVideo(display.contentCenterX * 1.45, display.contentCenterY * 1.025, display.contentCenterX * .6, display.contentCenterY * .5)
		video:load("videos/ExperimentPageVid.mp4")
		video:addEventListener("video", videoListener)
	elseif(appState == 7) then
		--endVideo()
		--dropTowerGroup.isVisible = false
		--appState = 0
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
-- 6 - Create Experiment 
-- 7 - Drop Tower Information

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
--import capsule group
capsuleInfo = require("capsule")
capsuleInfo:makeDisplay()
display:getCurrentStage():insert(capsuleInfo.dGroup)
--import winch group
winchInfo = require("winch")
winchInfo:makeDisplay()
display:getCurrentStage():insert(winchInfo.dGroup)
--import netting group
nettingInfo = require("netting")
nettingInfo:makeDisplay()
display:getCurrentStage():insert(nettingInfo.dGroup)
--import deceleration chamber group
decelInfo = require("decel")
decelInfo:makeDisplay()
display:getCurrentStage():insert(decelInfo.dGroup)

--other groups
videoGroup = display.newGroup()
videoGroup.isVisible = false
--import the fixIt group
fixIt = require( "fixit" )
fixIt:makeDisplay()
display:getCurrentStage():insert( fixIt.dGroup )
fixItGroup = fixIt.dGroup
fixItGroup.isVisible = false
--import the experiment page group
experimentPage = require("experiment")
experimentPage:makeDisplay()
display:getCurrentStage():insert(experimentPage.dGroup)


dropInfoPage = require("dropinfo")
dropInfoPage:makeDisplay()
display:getCurrentStage():insert(dropInfoPage.dGroup)

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

borderRect = display.newRect(display.contentCenterX, display.contentCenterY / 10,  (gW), (gH /10))
borderRect:setFillColor(0,.188,.082, 1)
mainMenuButtons:insert(borderRect)

--click to learn more box && accompanying text

learnRect = display.newRect(display.contentCenterX * .20, display.contentCenterY * .85, display.contentCenterX * .40, gH / 10)
learnRect:setFillColor(0,0,0,0)
learnRect:setStrokeColor(1,1,0)
learnRect.strokeWidth = 3
mainMenuButtons:insert(learnRect)

local learnTextOptions = 
	{
		text = "Click on a section to learn more!",
		x = display.contentCenterX * .20,
		y = display.contentCenterY * .92,
		font = native.systemFont,
		fontSize = 7,
		align = "center",
		width = display.contentCenterX * .30,
		height = gH / 11
	}
	
learnText = display.newText(learnTextOptions)
learnText:setFillColor(0,0,0,1)
mainMenuButtons:insert(learnText)
	
--What is a drop tower? button

dropTowerButton = widget.newButton(
	{
		id = "DropTowerButton",
		x = display.contentCenterX * 1.80,
		y = display.contentCenterY * .85,
		width = display.contentCenterX * .40,
		height = gH / 10,
		shape = "rectangle",
		fillColor = { default={ 0,0,0,0.01}, over={0,0,0,0.01} },
		font = native.systemFont,
		fontSize = 7,
		label = "What is a drop tower?",
		align = "center",
		labelColor = {default= {0,0,0,1}, over = {0,0,0,1}},
		strokeColor = { default={ 1,1,0 }, over={ 1,1,0 } },
		strokeWidth = 3,
		onRelease = sectionButtonHandler
	})
mainMenuButtons:insert(dropTowerButton)

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

-- options for text below experiment button
local experimentTextOptions = 
	{
		text = "Start your own experiment!",
		x = display.contentCenterX * 1.60,
		y = gH - (gH * 0.10),
		font = native.systemFont,
		fontSize = 8,
		align = "center",
		width = gH * 0.15,
		height = gH * 0.05
	}
	
--create and insert the text into the main menu
local experimentText = display.newText(experimentTextOptions)
experimentText:setFillColor(0,0,0,1)
mainMenuButtons:insert(experimentText)

i = 51
repeat
	if(headerText ~= nil) then
		headerText:removeSelf()
	end
	i = i - 1
	headerText = display.newText(
		{
			text = " Learn about Microgravity using Baylor's Drop Tower!",
			x = display.contentCenterX,
			align = "center",
			y = gH / 20,
			font = native.systemFont,
			fontSize = i
		})
until headerText.width <= gW * .97 or i == 1
print(i)
headerText:setFillColor(1,1,1,1)
mainMenuButtons:insert(headerText)

-- repairButton
local repairButton = widget.newButton(
	{
		id = "RepairButton",
		defaultFile = "images/wrench.jpg",
		overFile = "images/wrench.jpg",
		onRelease = sectionButtonHandler,
		x = display.contentCenterX * 0.30,
		width = gH * 0.125,
		y = gH - (gH * 0.19),
		height = gH * 0.125,
	})
mainMenuButtons:insert(repairButton)

--main menu repair text

local repairTextOptions = 
	{
		text = "Think you know enough to repair the drop tower?",
		x = display.contentCenterX * 0.30,
		y = gH - (gH * 0.10),
		font = native.systemFont,
		fontSize = 8,
		align = "center",
		width = gH * 0.15,
		height = gH * 0.05
	}
	
repairText = display.newText(repairTextOptions)
repairText:setFillColor(0,0,0,1)
mainMenuButtons:insert(repairText)
