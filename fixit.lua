
-- BRIC Drop Tower App
-- Version: 0.01
-- fixit.lua
---------------------------------------------------------------------------------------

local widget = require( "widget" )

local gH = display.contentHeight
local gW = display.contentWidth

local M = {}

function exitFixit()
	dGroup.isVisible = false
end

function M:makeDisplay()
	--Fixit has its own set of states:
	-- STATES: --
	-- 0 - Main screen
	local fixitState = 0
	--create display group
	dGroup = display.newGroup()
	--make background rectangle
	local bkg = display.newRect(display.contentCenterX, display.contentCenterY, gW, gH)
	bkg:setFillColor(0.3, 0.5, 0.9, 1)
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
	--make buttons
	--"Play game" button
	playGameButton = widget.newButton(
		{
			id = "PlayGame",
			x = display.contentCenterX,
			y = gH * 0.4,
			width = gW * 0.666,
			height = gH * 0.175,
			shape = "rectangle",
			fillColor = { default={ .75,.75,.75,1 }, over={ 1,1,1,1 } },
			font = native.systemFont,
			fontSize = 12,
			label = "Play Game",
			labelColor = { default={ 0,0,0,1 }, over={ 0,0,0,1 } },
			strokeColor = { default={ .25,.25,.25 }, over={ 0.5,0.5,0.5 } },
			strokeWidth = 3
			--onRelease = handleVideo
		})
	backButton = widget.newButton(
		{
			id = "Back",
			x = display.contentCenterX,
			y = gH * 0.7,
			width = gW * 0.666,
			height = gH * 0.170,
			shape = "rectangle",
			fillColor = { default={ .75,.75,.75,1 }, over={ 1,1,1,1 } },
			font = native.systemFont,
			fontSize = 12,
			label = "Go Back",
			labelColor = { default={ 0,0,0,1 }, over={ 0,0,0,1 } },
			strokeColor = { default={ .25,.25,.25 }, over={ 0.5,0.5,0.5 } },
			strokeWidth = 3,
			onRelease = exitFixit
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
			--onRelease = handleVideo
		})
	--insert objects into group
	dGroup:insert(backgroundButton)
	dGroup:insert(bkg)
	dGroup:insert(titleText)
	dGroup:insert(playGameButton)
	dGroup:insert(backButton)
	--set object variable (so it can be accessed elsewhere)
	self.dGroup = dGroup
end

function M:invisible()
	dGroup.visible = false
end

return M