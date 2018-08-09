
-- BRIC Drop Tower App
-- Version: 0.01
-- main.lua
-- Authors: Saul Flores & Marc Willis
-- Supervising Professor: Matthew Fendt
---------------------------------------------------------------------------------------

-- Hide device status bar
display.setStatusBar( display.HiddenStatusBar )
-- Require libraries/plugins
local widget = require( "widget" )

-- "constants"
local COMPANIONSITEURL = "https://room.eu.com/article/a-new-microgravity-research-facility-for-central-texas-and-beyond"
local LOCALCOMPANIONSITE = "web/index.html"
local COMPANIONTIMEOUTLENGTH = 60

--converts a height in pixels to the equivalent pt value for text
--may need some fine-tuning
function px2pt( pixels )
	return math.floor((pixels * 0.75) + 0.5)
end

--get global height and width
gH = display.contentHeight
gW = display.contentWidth

--Text sizes because calling functions in tables is wonky and may break the app on android
textSizeA = px2pt(gH * 0.025)
textSizeB = px2pt(gH * 0.019)
textSizeC = px2pt(gH * 0.05)
textSizeD = px2pt(gH * 0.06)
textSizeE = px2pt(gH * 0.07)
textSizeF = px2pt(gH * 0.04)
textSizeG = px2pt(gH * 0.02)
textSizeH = px2pt(gH * 0.03)

--the object to hold any webpages that are loaded by the app
webDisplay = nil

--a flag for whether the companion site could be reached or not
companionSiteAvailable = false
baylorSiteAvailable = false
bricSiteAvailable = false

---------------------
-- BUTTON HANDLERS --
---------------------

local function configHandler( event )
	moduleTitleGroup.isVisible = false
end

local function moduleBackHandler (event)
	--save the current settings to a string
	local saveData = ""
	
	--drop capsule
	if(capsuleButton.isVisible) then
		saveData = saveData .. "1"
	else
		saveData = saveData .. "0"
	end
	--winch
	if(winchButton.isVisible) then
		saveData = saveData .. "1"
	else
		saveData = saveData .. "0"
	end
	--netting
	if(netButton.isVisible) then
		saveData = saveData .. "1"
	else
		saveData = saveData .. "0"
	end
	--decel chamber
	if(decelButton.isVisible) then
		saveData = saveData .. "1"
	else
		saveData = saveData .. "0"
	end
	--fixit
	if(repairButtonGroup.isVisible) then
		saveData = saveData .. "1"
	else
		saveData = saveData .. "0"
	end
	--experiment
	if(experimentButtonGroup.isVisible) then
		saveData = saveData .. "1"
	else
		saveData = saveData .. "0"
	end
	--phys game
	if(physicsGameButtonGroup.isVisible) then
		saveData = saveData .. "1"
	else
		saveData = saveData .. "0"
	end
	
	--open file for writing
	local configPath = system.pathForFile("config.txt", system.DocumentsDirectory)
	local configFile, errStr = io.open(configPath, "w")
	if (not configFile) then
		--could not open config file
		print("File error: " .. errStr)
	else
		--opened successfully, write and close
		configFile:write(saveData)
		io.close(configFile)
		--make the popup, well, pop up
		configPopupGroup.animFrames = 100
	end
	configFile = nil
	
	--hide the module menu
	moduleGroup.isVisible = false
end

--ends the video playing currently
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
			experimentPage:reveal()
		elseif(event.target.id == "RepairButton") then
			--go to fixit
			fixIt:reveal()
		elseif(event.target.id == "DropTowerButton") then
			--go to Drop Tower Info
			appState = 7
			dropInfoPage:reveal()
		elseif(event.target.id == "PhysicsGameButton") then
			appState = 8
			physicsGamePage:reveal()
		elseif(event.target.id == "SettingsButton") then
			moduleGroup.isVisible = true
			moduleTitleGroup.isVisible = false
		end
	elseif(appState == 5) then
		appState = 6
		experimentGroup.isVisible = false
		createExpGroup.isVisible = true
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

--declaration of handler for web based events
local function handleWebEvent(event)
	if("Back" == event.target.id) then
		webGroup.isVisible = false
		--if (webDisplay ~= nil) then
		webDisplay:removeSelf()
		--end
	elseif("BaylorLogo" == event.target.id) then
		webGroup.isVisible = true
		webDisplay = native.newWebView(display.contentCenterX, gH * 0.45, gW, gH * 0.9)
		if(baylorSiteAvailable) then
			webDisplay:request("https://www.baylor.edu")
		else
			webDisplay:request(LOCALCOMPANIONSITE, system.ResourceDirectory)
		end
	elseif("BRICLogo" == event.target.id) then
		webGroup.isVisible = true
		webDisplay = native.newWebView(display.contentCenterX, gH * 0.45, gW, gH * 0.9)
		if(bricSiteAvailable) then
			webDisplay:request("https://www.baylor.edu/bric/")
		else
			webDisplay:request(LOCALCOMPANIONSITE, system.ResourceDirectory)
		end
	elseif("CompanionSite" == event.target.id) then
		webGroup.isVisible = true
		webDisplay = native.newWebView(display.contentCenterX, gH * 0.45, gW, gH * 0.9)
		if(companionSiteAvailable) then
			webDisplay:request(COMPANIONSITEURL)
		else
			webDisplay:request(LOCALCOMPANIONSITE, system.ResourceDirectory)
		end
	end
end

--opens proper video for current state
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

---------------------
-- NETWORK HANDLER --
---------------------

local function netListen( event )
	if ( event.isError ) then
		print("Could not reach " .. event.url)
		if(COMPANIONSITEURL == event.url) then
			--use the placeholder site
			companionSiteAvailable = false
			companionSiteGroup.isVisible = true
		elseif(event.url = "https://www.baylor.edu") then
			baylorSiteAvailable = false
		elseif(event.url = "https://www.baylor.edu/bric/") then
			bricSiteAvailable = false
		end
	else
		if("ended" == event.phase) then
			print ( "Response from: " .. event.url )
			if(COMPANIONSITEURL == event.url) then
				--use the real site
				companionSiteGroup.isVisible = true
				companionSiteAvailable = true
			elseif(event.url = "https://www.baylor.edu") then
				baylorSiteAvailable = true
			elseif(event.url = "https://www.baylor.edu/bric/") then
				bricSiteAvailable = true
			end
		end
	end
end

-----------------
-- ACTUAL CODE --
-----------------

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
--create video group
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
--import the dropInfoPage group
dropInfoPage = require("dropinfo")
dropInfoPage:makeDisplay()
display:getCurrentStage():insert(dropInfoPage.dGroup)
--import the physicsGamePage group
physicsGamePage = require("physicsgame")
physicsGamePage:makeDisplay()
display.getCurrentStage():insert(physicsGamePage.dGroup)

--group for web popup display
webGroup = display.newGroup()
webGroup.isVisible = false

--group for "config updated" popup
configPopupGroup = display.newGroup()
configPopupGroup.isVisible = false

--group for the modular selection
moduleGroup = display.newGroup()
moduleTitleGroup = display.newGroup()

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
	
--"Stop video" button 
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

--click to learn more box && accompanying text
local learnRect = display.newRect(gW * 0.1, gH * 0.425, gW * .20, gH * 0.1)
learnRect:setFillColor(1,1,1,1)
mainMenuButtons:insert(learnRect)

--create the text	
local learnText = display.newText(
	{
		text = "Click on a section to learn more!",
		x = gW * 0.1,
		y = gH * 0.425,
		font = native.systemFont,
		fontSize = textSizeA,
		align = "center",
		width = gW * .15,
	})
learnText:setFillColor(0,0,0,1)
mainMenuButtons:insert(learnText)
	
---------------------------
-- WHAT IS A DROP TOWER? --
---------------------------
dropTowerButtonGroup = display.newGroup()
mainMenuButtons:insert(dropTowerButtonGroup)

--make the button
local dropTowerButton = widget.newButton(
	{
		id = "DropTowerButton",
		x = gW * 0.9,
		y = gH * 0.425,
		width = gW * 0.20,
		height = gH * 0.1,
		shape = "rectangle",
		fillColor = { default={ 1,1,1,1}, over={1,1,1,1} },
		strokeColor = { default={ 0,0,1 }, over={ 0,0,1 } },
		strokeWidth = 3,
		onRelease = sectionButtonHandler
	})
dropTowerButtonGroup:insert(dropTowerButton)

--text
local dropTowerText = display.newText(
	{
		text = "What is a drop tower?",
		x = gW * 0.90,
		y = gH * 0.425,
		width = gW * 0.20,
		font = native.systemFont,
		align = "center",
		fontSize = textSizeA
	})
dropTowerText:setFillColor(0,0,0,1)
dropTowerButtonGroup:insert(dropTowerText)

-------------------
-- BAYLOR BUTTON --
-------------------

baylorButtonGroup = display.newGroup()
mainMenuButtons:insert(baylorButtonGroup)

--image
local baylorButton = widget.newButton(
	{
		id = "BaylorLogo",
		defaultFile = "images/BaylorGreen.png",
		overFile = "images/BaylorGreen.png",
		onRelease = handleWebEvent,
		x = display.contentCenterX / 2,
		width = display.contentCenterX,
		y = gH - (gH * 0.086 * 0.5),
		height = gH * 0.086,
	})
baylorButtonGroup:insert(baylorButton)

--outline
local baylorButtonOutline = display.newRect(gW * 0.25, gH * 0.957, gW * 0.5 - 4, gH * .086 - 4)
baylorButtonOutline.strokeWidth = 3
baylorButtonOutline:setStrokeColor(0,0,1)
baylorButtonOutline:setFillColor(1,1,1,0)
baylorButtonGroup:insert(baylorButtonOutline)

-----------------
-- BRIC BUTTON --
-----------------

bricButtonGroup = display.newGroup()
mainMenuButtons:insert(bricButtonGroup)

--image
local bricButton = widget.newButton(
	{
		id = "BRICLogo",
		defaultFile = "images/BRICWhite.png",
		overFile = "images/BRICWhite.png",
		onRelease = handleWebEvent,
		x = display.contentCenterX * 1.5,
		width = display.contentCenterX,
		y = gH - (gH * 0.086 * 0.5),
		height = gH * 0.086
	})
bricButtonGroup:insert(bricButton)

--outline
local bricButtonOutline = display.newRect(gW * 0.75, gH * 0.957, gW * 0.5 - 4, gH * .086 - 4)
bricButtonOutline.strokeWidth = 3
bricButtonOutline:setStrokeColor(0,0,1)
bricButtonOutline:setFillColor(1,1,1,0)
bricButtonGroup:insert(bricButtonOutline)

-----------------------
-- EXPERIMENT BUTTON --
-----------------------
--make group
experimentButtonGroup = display.newGroup()
mainMenuButtons:insert(experimentButtonGroup)

--actual button
local experimentButtonOutline = widget.newButton(
	{
		id = "ExperimentButton",
		onRelease = sectionButtonHandler,
		x = gW * 0.849,
		width = gW * 0.3,
		y = gH * 0.825,
		height = gH * 0.17,
		shape = "rectangle",
		fillColor = { default={ 1,1,1,1}, over={1,1,1,1} },
		strokeColor = { default={ 0,0,1 }, over={ 0,0,1 } },
		strokeWidth = 3,
	})
experimentButtonGroup:insert(experimentButtonOutline)

--image
local experimentButtonImage = display.newImageRect("images/DropCapsule2.jpg", gH * 0.10, gH * 0.10)
experimentButtonImage.x = gW * 0.85
experimentButtonImage.y = gH * 0.80
experimentButtonGroup:insert(experimentButtonImage)

-- options for text below experiment button
local experimentTextOptions = 
	{
		text = "Start your own experiment!",
		x = gW * 0.85,
		y = gH * 0.89,
		font = native.systemFont,
		fontSize = textSizeB,
		align = "center",
		width = gH * 0.15,
		height = gH * 0.05
	}

--create and insert the text into the group
local experimentText = display.newText(experimentTextOptions)
experimentText:setFillColor(0,0,0,1)
experimentButtonGroup:insert(experimentText)

-------------------
-- REPAIR BUTTON --
-------------------

repairButtonGroup = display.newGroup()
mainMenuButtons:insert(repairButtonGroup)

-- actual button
local repairButtonOutline = widget.newButton(
	{
		id = "RepairButton",
		onRelease = sectionButtonHandler,
		x = gW * 0.151,
		width = gW * 0.3,
		y = gH * 0.825,
		height = gH * 0.17,
		shape = "rectangle",
		fillColor = { default={ 1,1,1,1}, over={1,1,1,1} },
		strokeColor = { default={ 0,0,1 }, over={ 0,0,1 } },
		strokeWidth = 3,
	})
repairButtonGroup:insert(repairButtonOutline)
	
-- wrench image
local repairButtonImage = display.newImageRect("images/wrench.jpg", gH * 0.1, gH * 0.1)
repairButtonImage.x = gW * 0.15
repairButtonImage.y = gH * 0.80
repairButtonGroup:insert(repairButtonImage)

--main menu repair text options
local repairTextOptions = 
	{
		text = "Think you know enough to repair the drop tower?",
		x = gW * 0.15,
		y = gH * 0.88,
		font = native.systemFont,
		fontSize = textSizeB,
		align = "center",
		width = gH * 0.15,
		height = gH * 0.05
	}

--create repair text
repairText = display.newText(repairTextOptions)
repairText:setFillColor(0,0,0,1)
repairButtonGroup:insert(repairText)

------------------
-- PHYSICS GAME --
------------------

physicsGameButtonGroup = display.newGroup()
mainMenuButtons:insert(physicsGameButtonGroup)

--button
local physicsGameButton = widget.newButton(
	{
		id = "PhysicsGameButton",
		x = gW * 0.90,
		y = gH * 0.525,
		width = gW * 0.20,
		height = gH * 0.1,
		shape = "rectangle",
		fillColor = { default={ 1,1,1,1}, over={1,1,1,1} },
		strokeColor = { default={ 0,0,1 }, over={ 0,0,1 } },
		strokeWidth = 3,
		onRelease = sectionButtonHandler
	})
physicsGameButtonGroup:insert(physicsGameButton)

--text
local physicsGameText = display.newText(
	{
		text = "Play a physics game!",
		x = gW * 0.90,
		y = gH * 0.525,
		width = gW * 0.20,
		font = native.systemFont,
		align = "center",
		fontSize = textSizeA
	})
physicsGameText:setFillColor(0,0,0,1)
physicsGameButtonGroup:insert(physicsGameText)

--------------------
-- COMPANION SITE --
--------------------
companionSiteGroup = display.newGroup()
mainMenuButtons:insert(companionSiteGroup)

--create the button
local companionSiteButton = widget.newButton(
	{
		id = "CompanionSite",
		x = gW * 0.10,
		y = gH * 0.525,
		width = gW * 0.20,
		height = gH * 0.10,
		shape = "rectangle",
		fillColor = { default={ 1,1,1,1}, over={1,1,1,1} },
		strokeColor = { default={ 0,0,1 }, over={ 0,0,1 } },
		strokeWidth = 3,
		onRelease = handleWebEvent
	})
companionSiteGroup:insert(companionSiteButton)

--text
local companionSiteText = display.newText(
	{
		text = "Visit the website!",
		x = gW * 0.10,
		y = gH * 0.525,
		width = gW * 0.20,
		font = native.systemFont,
		align = "center",
		fontSize = textSizeA
	})
companionSiteText:setFillColor(0,0,0,1)
companionSiteGroup:insert(companionSiteText)

companionSiteGroup.isVisible = false
--trigger testing event that will unhide the button if it gets a response from the website
network.request( COMPANIONSITEURL, "GET", netListen, {timeout = COMPANIONTIMEOUTLENGTH})
network.request( "https://www.baylor.edu", "GET", netListen, {timeout = COMPANIONTIMEOUTLENGTH})
network.request( "https://www.baylor.edu/bric/", "GET", netListen, {timeout = COMPANIONTIMEOUTLENGTH})

---------------------
-- SETTINGS BUTTON --
---------------------
local settingsButton = widget.newButton(
	{
		id = "SettingsButton",
		defaultFile = "images/settings.png",
		overFile = "images/settings.png",
		onRelease = sectionButtonHandler,
		x = gW * 0.950,
		width = gW * 0.100,
		y = gH * 0.1 + (gW * 0.050),
		height = gW * 0.100,
	})
mainMenuButtons:insert(settingsButton)

-----------
-- TITLE --
-----------

--top border image
borderRect = display.newRect(display.contentCenterX, display.contentCenterY / 10,  (gW), (gH /10))
borderRect:setFillColor(0,.188,.082, 1)
mainMenuButtons:insert(borderRect)

--function to make text fit inside of respective box
i = 51
repeat
	if(headerText ~= nil) then
		headerText:removeSelf()
	end
	i = i - 1
	headerText = display.newText(
		{
			text = "Learn about Baylor's Drop Tower!",
			x = display.contentCenterX,
			align = "center",
			y = gH / 20,
			font = native.systemFontBold,
			fontSize = i
		})
until headerText.width <= gW * .97 or i == 1
headerText:setFillColor(1,1,1,1)
headerDropShadow = display.newText(
	{
		text = headerText.text,
		x = gW * .51,
		align = "center",
		y = gH * .055,
		font = native.systemFontBold,
		fontSize = i
	})
headerDropShadow:setFillColor(0,0,0,0.5)
mainMenuButtons:insert(headerDropShadow)
mainMenuButtons:insert(headerText)


---------------
-- WEB POPUP --
---------------

--darkener
darkenerRect = display.newRect(display.contentCenterX, display.contentCenterY, gW, gH)
darkenerRect:setFillColor(0,0,0,0.85)
webGroup:insert(darkenerRect)

--make loading text
webLoadText = display.newText(
	{
		text = "Loading...",
		x = display.contentCenterX,
		align = "center",
		y = gH * 0.45,
		font = native.systemFont,
		fontSize = 24
	})
webGroup:insert(webLoadText)

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
	onRelease = handleWebEvent
})
webGroup:insert(backButton)

--------------------------
-- CONFIG UPDATED POPUP --
--------------------------
--create box for text to appear on
configBox = display.newRect(display.contentCenterX, display.contentCenterY, gW * 0.8, gH * 0.25)
configBox:setFillColor(1, 1, 1, 1)
configBox.strokeWidth = 3
configBox:setStrokeColor(0,0,1,1)
--create text and shrink to box
i = 50
repeat
	if(configText ~= nil) then
		configText:removeSelf()
	end
	i = i - 1
	configText = display.newText(
		{
			text="Config\nUpdated",
			x=configBox.x,
			y=configBox.y,
			width=configBox.width - 6, --keep inside the lines
			font=native.systemFontBold,
			fontSize=i,
			align="center"
		})
until configText.height <= configBox.height or i == 1
configText:setFillColor(0,0,1,1)

--insert into group
configPopupGroup:insert(configBox)
configPopupGroup:insert(configText)

--set up fade out animation
configPopupGroup.animFrames = 0

function configPopupGroup:enterFrame(event)
	if (self.animFrames > 0) then
		self.isVisible = true
		self.animFrames = self.animFrames - 1
		if(self.animFrames >= 10) then
			self.alpha = 1
		else
			self.alpha = self.animFrames/10
		end
	else
		self.isVisible = false
	end
end

Runtime:addEventListener( "enterFrame", configPopupGroup )

-----------------
-- CONFIG DATA --
-----------------

local configPath = system.pathForFile("config.txt", system.DocumentsDirectory)
local configExists = false
local configFile, errStr = io.open(configPath, "r")
if (not configFile) then
	--error reading, make new config
	print("File error: " .. errStr)
	
else
	--read the stuff
	configExists = true
	local configData = configFile:read("*a")
	if(7 ~= string.len(configData)) then
		--file of incorrect size, ignore
		print("Invalid or old configuration, ignoring.")
		print("File contents: " .. configData)
		configExists = false
	else
		--file still probably good, go through characters to find out what switches to flip
		
		--drop capsule
		if(string.sub(configData,1,1) == "1") then
			print("Drop Capsule ON")
		elseif (string.sub(configData,1,1) == "0") then
			print("Drop Capsule OFF")
			capsuleButton.isVisible = false
		else
			print("Drop Capsule INVALID")
			configExists = false
		end
		
		--winch
		if(string.sub(configData,2,2) == "1") then
			print("Winch ON")
		elseif (string.sub(configData,2,2) == "0") then
			print("Winch OFF")
			winchButton.isVisible = false
		else
			print("Winch INVALID")
			configExists = false
		end
		
		--netting
		if(string.sub(configData,3,3) == "1") then
			print("Netting ON")
		elseif (string.sub(configData,3,3) == "0") then
			print("Netting OFF")
			netButton.isVisible = false
		else
			print("Netting INVALID")
			configExists = false
		end
		
		--deceleration chamber
		if(string.sub(configData,4,4) == "1") then
			print("Decel Chamber ON")
		elseif (string.sub(configData,4,4) == "0") then
			print("Decel Chamber OFF")
			decelButton.isVisible = false
		else
			print("Decel INVALID")
			configExists = false
		end
		
		--fixit
		if(string.sub(configData,5,5) == "1") then
			print("Fix It ON")
		elseif (string.sub(configData,5,5) == "0") then
			print("Fix It OFF")
			repairButtonGroup.isVisible = false
		else
			print("Fix It INVALID")
			configExists = false
		end
		
		--experiment
		if(string.sub(configData,6,6) == "1") then
			print("Experiment ON")
		elseif (string.sub(configData,6,6) == "0") then
			print("Experiment OFF")
			experimentButtonGroup.isVisible = false
		else
			print("Experiment INVALID")
			configExists = false
		end
		
		--winch
		if(string.sub(configData,7,7) == "1") then
			print("Phys Game ON")
		elseif (string.sub(configData,7,7) == "0") then
			print("Phys Game OFF")
			physicsGameButtonGroup.isVisible = false
		else
			print("Phys Game INVALID")
			configExists = false
		end
		
		if(not configExists) then
			--if there was an error, change everything back to its default state
			capsuleButton.isVisible = true
			winchButton.isVisible = true
			netButton.isVisible = true
			decelButton.isVisible = true
			repairButtonGroup.isVisible = true
			experimentButtonGroup.isVisible = true
			physicsGameButtonGroup.isVisible = true
		end
	end
	--close the file
	io.close(configFile)
end
configFile = nil
----------------------
-- MODULE SELECTION --
----------------------
--screen cover
local moduleScreenButton = widget.newButton(
	{
		id = "ModuleScreenButton",
		x = display.contentCenterX,
		width = gW,
		y = display.contentCenterY,
		height = gH,
		fillColor = { default={0.3,0.5,0.9,1}, over={0.3,0.5,0.9,1} },
		shape = "rectangle"
	})
moduleGroup:insert(moduleScreenButton)

--title text
i = math.ceil(px2pt(gH * 0.08))
repeat
	if(moduleHeaderText ~= nil) then
		moduleHeaderText:removeSelf()
	end
	i = i - 1
	moduleHeaderText = display.newText(
		{
			text = "Enable/Disable Modules",
			x = display.contentCenterX,
			align = "center",
			y = gH * 0.05,
			font = native.systemFont,
			fontSize = i
		})
until moduleHeaderText.width <= gW * 0.97 or i==1
moduleHeaderText:setFillColor(1,1,1,1)
moduleGroup:insert(moduleHeaderText)

--back/done button
doneButton = widget.newButton(
	{
		id = "Done",
		x = display.contentCenterX,
		y = gH * 0.95,
		width = gW * 0.95,
		height = gH * 0.075,
		shape = "rectangle",
		fillColor = {default={.75, .75, .75, 1}, over={1,1,1,1}},
		strokeColor = {default={ .25 , .25, .25, 1}, over={ .50,.50,.50, 1 } },
		strokeWidth = 3,
		label = "Done",
		font = native.systemFont,
		fontSize = textSizeC,
		labelColor = {default = {0,0,0,1}, over = {0,0,0,1}},
		onRelease = moduleBackHandler
	})
moduleGroup:insert(doneButton)

local modRowMaker = require("modulepick")

--row 1: Drop Capsule
modRowMaker:makeRow("Drop Capsule Info", capsuleButton, gH * 0.15, "Provides information about the drop capsule iteslf", moduleGroup)
--row 2: Winch
modRowMaker:makeRow("Winch Info", winchButton, gH * 0.23, "Provides information about the winch that rasies the drop capsule to its starting height", moduleGroup)
--row 3: Netting
modRowMaker:makeRow("Netting Info", netButton, gH * 0.31, "Provides information about the netting that surrounds the drop area", moduleGroup)
--row 4: Deceleration Chamber
modRowMaker:makeRow("Decel. Chamber Info", decelButton, gH * 0.39, "Provides information about the chamber that safely decelerates the drop capsule", moduleGroup)
--row 5: Fixit
modRowMaker:makeRow("Fix It Game", repairButtonGroup, gH * 0.47, "A short quiz-based game in which the user answers questions to try to fix the drop tower", moduleGroup)
--row 6: Experiment
modRowMaker:makeRow("Experiment", experimentButtonGroup, gH * 0.55, "A module in which the user can simulate common drop tower experiments", moduleGroup)
--row 7: Physics game
modRowMaker:makeRow("Physics Game", physicsGameButtonGroup, gH * 0.63, "A game where the user can learn about the physics of gravity", moduleGroup)

--create area for information text
local textBkg = display.newRect(gW * 0.5, gH * 0.785, gW * 0.95, gH * 0.21)
textBkg:setFillColor(.25,.25,.25,.75)
moduleGroup:insert(textBkg)

--create information text box
moduleInfoText = display.newText(
	{
		text = "Tap the title of a row to get more information about the objects in that row.",
		x = gW * 0.5,
		width = gW * 0.92,
		y = gH * 0.785,
		align = "center",
		font = native.systemFont,
		fontSize = textSizeD,
	})
moduleInfoText:setFillColor(1,1,1,1)
moduleGroup:insert(moduleInfoText)


--Module "title" screen
local moduleScreenButton2 = widget.newButton(
	{
		id = "ModuleScreenButton",
		x = display.contentCenterX,
		width = gW,
		y = display.contentCenterY,
		height = gH,
		fillColor = { default={0.3,0.5,0.9,1}, over={0.3,0.5,0.9,1} },
		shape = "rectangle"
	})
moduleTitleGroup:insert(moduleScreenButton2)

--title screen text
i = 121
repeat
	if(moduleTitleText ~= nil) then
		moduleTitleText:removeSelf()
	end
	i = i - 1
	moduleTitleText = display.newText(
		{
			text = "This app can be configured to enable or disable specific features as best suits your classroom. Would you like to proceed with the default settings or customize what is available?",
			x = display.contentCenterX,
			align = "center",
			y = gH * 0.2,
			font = native.systemFont,
			fontSize = i,
			width = gW * 0.97
		})
until moduleTitleText.height <= gH * 0.38 or i==1
moduleTitleText:setFillColor(1,1,1,1)
moduleTitleGroup:insert(moduleTitleText)
--Configure button
local configureButton = widget.newButton(
	{
		id = "ConfigureModules",
		x = display.contentCenterX,
		y = gH * 0.575,
		width = gW * 0.666,
		height = gH * 0.175,
		shape = "rectangle",
		fillColor = { default={ .75,.75,.75,1 }, over={ 1,1,1,1 } },
		font = native.systemFont,
		fontSize = textSizeD,
		label = "Configure Options",
		labelColor = { default={ 0,0,0,1 }, over={ 0,0,0,1 } },
		strokeColor = { default={ .25,.25,.25 }, over={ 0.5,0.5,0.5 } },
		strokeWidth = 3,
		onRelease = configHandler
	})
moduleTitleGroup:insert(configureButton)
--default button
local defaultButton = widget.newButton(
	{
		id = "DefaultModules",
		x = display.contentCenterX,
		y = gH * 0.825,
		width = gW * 0.666,
		height = gH * 0.170,
		shape = "rectangle",
		fillColor = { default={ .75,.75,.75,1 }, over={ 1,1,1,1 } },
		font = native.systemFont,
		fontSize = textSizeD,
		label = "Default Settings",
		labelColor = { default={ 0,0,0,1 }, over={ 0,0,0,1 } },
		strokeColor = { default={ .25,.25,.25 }, over={ 0.5,0.5,0.5 } },
		strokeWidth = 3,
		onRelease = moduleBackHandler
	})
moduleTitleGroup:insert(defaultButton)

moduleGroup:insert(moduleTitleGroup)

if (configExists) then
	moduleGroup.isVisible = false
end