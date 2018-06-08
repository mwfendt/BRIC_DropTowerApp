
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
--handles button presses for the various sections of the drop tower
local sectionButtonHandler = function( event )
	if(appState == 0) then
		--figure out which section to display then display it
		if(event.target.id == "DropCapsule") then
			--go to zoomed drop capsule state
			appState = 1
			dropCapZoomed.isVisible = true
		elseif (event.target.id == "Netting") then
			--go to zoomed netting state
			appState = 2
			netZoomed.isVisible = true
		elseif (event.target.id == "Winch") then
			--go to zoomed winch state
			appState = 3
			winchZoomed.isVisible = true
		elseif (event.target.id == "DecelContainer") then
			--go to zoomed decelration chamber state
			appState = 4
			decelZoomed.isVisible = true
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
	print("Screen Button Press")
	if(appState == 1) then
		--dismiss drop capsule zoomed image
		dropCapZoomed.isVisible = false
		appState = 0
	elseif (appState == 2) then
		--dismiss net zoomed image
		netZoomed.isVisible = false
		appState = 0
	elseif (appState == 3) then
		--dismiss winch zoomed image
		winchZoomed.isVisible = false
		appState = 0
	elseif (appState == 4) then
		decelZoomed.isVisible = false
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

local function handleBricEvent(event)

	if("ended" == event.phase) then
		system.openURL("https://www.baylor.edu/bric")
	end
end

-----------------
-- ACTUAL CODE --
-----------------

--get global height and width
local gH = display.contentHeight
local gW = display.contentWidth

--set state
appState = 0
-- STATES: --
-- 0 - Main screen
-- 1 - Close-up of capsule
-- 2 - Close-up of netting
-- 3 - Close-up of winch
-- 4 - Close-up of deceleration container

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

mainMenuButtons = display.newGroup()

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
		onRelease = sectionButtonHandler
	})
mainMenuButtons:insert(winchButton)

--zoomed drop capsule image
dropCapZoomed = display.newImageRect("images/DropCapsule.jpg", gW, gH)
dropCapZoomed.x = display.contentCenterX
dropCapZoomed.y = display.contentCenterY
dropCapZoomed.isVisible = false

--zoomed netting image
netZoomed = display.newImageRect("images/Netting.jpg", gW, gH)
netZoomed.x = display.contentCenterX
netZoomed.y = display.contentCenterY
netZoomed.isVisible = false

--zoomed winch image
winchZoomed = display.newImageRect("images/Winch.jpg",gW, gH)
winchZoomed.x = display.contentCenterX
winchZoomed.y = display.contentCenterY
winchZoomed.isVisible = false

--zoomed deceleration container image
decelZoomed = display.newImageRect("images/DecelContainer.jpg", gW, gH)
decelZoomed.x = display.contentCenterX
decelZoomed.y = display.contentCenterY
decelZoomed.isVisible = false
		
-- baylor button
local baylorButton = widget.newButton(
	{
		id = "BaylorLogo",
		defaultFile = "images/BaylorGreen.png",
		overFile = "images/BaylorGreen.png",
		onEvent = handleBaylorEvent,
		x = display.contentCenterX / 2,
		width = display.contentCenterX,
		y = gH * 0.086 * 0.5,
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
		y = gH * 0.086 * 0.5,
		height = gH * 0.086
	})
mainMenuButtons:insert(bricButton)