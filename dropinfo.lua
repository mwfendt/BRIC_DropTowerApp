
-- BRIC Drop Tower App
-- Version: 0.01
-- dropinfo.lua
---------------------------------------------------------------------------------------

local widget = require( "widget" )

local gH = display.contentHeight
local gW = display.contentWidth

local M = {}

local animFrames = 0

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


function buttonHandler(event)
	if(animFrames == 0) then
		M:hide()
		endVideo()
	end
end

function M:makeDisplay()
	dGroup = display.newGroup()
	-- What is a drop tower? Page

	infoBkg = display.newRect(display.contentCenterX, display.contentCenterY, gW, gH)
	infoBkg:setFillColor(.3, .5, .9, 1)
	dGroup:insert(infoBkg)

	towerInfoText = widget.newButton(
		{
			id = "Info Text",
			x = gW * 0.5,
			y = gH * 0.125,
			width = gW * 0.9, 
			height = gH * 0.20,
			shape = "rectangle",
			fillColor = { default={ .75, .75, .75, 1 }, over={ 0.15,0.5,1,1 } },
		})
	dGroup:insert(towerInfoText)


	towerTextOptions = 
		{
			text = "In physics and materials science, a drop tower or drop tube is a structure used to produce a controlled period of weightlessness for an object under study. Air bags, polystyrene pellets, and magnetic or mechanical brakes are sometimes used to arrest the fall of the experimental payload.",
			x = gW * 0.5,
			y = gH * 0.125,
			width = gW * 0.8,
			align = "center",
			font = native.systemFont,
			fontSize = 12
		}
		
	towerText = display.newText(towerTextOptions)
	towerText:setFillColor(0,0,0,1)
	dGroup:insert(towerText)

	bricInfo = widget.newButton(
		{
			id = "BRIC Info",
			x = gW * 0.5,
			y = gH * 0.8,
			width = gW * 0.9, 
			height = gH * 0.20,
			shape = "rectangle",
			fillColor = { default={ .75, .75, .75, 1 }, over={ 0.15,0.5,1,1 } },
		})
	dGroup:insert(bricInfo)

	bricInfoOptions = 
		{
			text = "The Baylor Research and Innovation Collaborative (BRIC) is the flagship project for the Central Texas Technology and Research Park, an initiative by organizations and higher educational institutions in Central Texas to develop, promote and market science and engineering technologies, university research and advanced technology training and workforce development.",
			x = gW * 0.5,
			y = gH * 0.8,
			width = gW * 0.8,
			align = "center",
			font = native.systemFont,
			fontSize = 12
		}

	bricText = display.newText(bricInfoOptions)
	bricText:setFillColor(0,0,0,1)
	dGroup:insert(bricText)
	
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
	dGroup:insert(backButton)
	
	dGroup.isVisible = false
	--set object variables (so they can be accessed elsewhere)
	self.dGroup = dGroup
end

function M:reveal()
	animFrames = 10
	self.dGroup.isVisible = true
	video = native.newVideo(gW * 0.5, gH * 0.475, gW, gW * 0.75)
	video:load("videos/PlaceholderVid5.mp4")
	video:addEventListener("video", videoListener)
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