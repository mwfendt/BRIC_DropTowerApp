
-- BRIC Drop Tower App
-- Version: 0.01
-- main.lua
---------------------------------------------------------------------------------------

-- Hide device status bar
display.setStatusBar( display.HiddenStatusBar )

-- Require libraries/plugins
local widget = require( "widget" )

--get global height and width
local gH = display.contentHeight
local gW = display.contentWidth

--display background image
local bkg = display.newImageRect( "images/DropTowerDiagram.png", 320, 480 )
bkg.x = display.contentCenterX
bkg.y = display.contentCenterY
bkg.width = gW
bkg.height = gH

--decelration container button
local decelButton = widget.newButton(
	{
		id = "DecelContainer",
		x = gW * 0.397,
		y = gH * 0.629,
		width = gW * 0.250,
		height = gH * 0.172,
		shape = "rectangle",
		fillColor = { default={ 1,0,0,0.25 }, over={ 1,0,0,0.5 } },
		--onRelease = buttonHandler
	})
	
--netting button
local netButton = widget.newButton(
	{
		id = "Netting",
		x = gW * 0.397,
		y = gH * 0.404,
		width = gW * 0.250,
		height = gH * 0.278,
		shape = "rectangle",
		fillColor = { default={ 0,1,0,0.25 }, over={ 0,1,0,0.5 } },
		--onRelease = buttonHandler
	})

--drop capsule button	
local capsuleButton = widget.newButton(
	{
		id = "DropCapsule",
		x = gW * 0.397,
		y = gH * 0.199,
		width = gW * 0.250,
		height = gH * 0.132,
		shape = "rectangle",
		fillColor = { default={ 0,0,1,0.25 }, over={ 0,0,1,0.5 } },
		--onRelease = buttonHandler
	})
	
--winch button	
local winchButton = widget.newButton(
	{
		id = "Winch",
		x = gW * 0.586,
		y = gH * 0.282,
		width = gW * 0.128,
		height = gH * 0.086,
		shape = "rectangle",
		fillColor = { default={ 1,1,0,0.25 }, over={ 1,1,0,0.5 } },
		--onRelease = buttonHandler
	})