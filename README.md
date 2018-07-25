# BRIC_DropTowerApp
Informational application to be used at the Baylor University BRIC Drop Tower

# Corona/Corona Simulator Installation Instructions

* Go to [Corona's Website](https://coronalabs.com/ "Corona Download Site")
* Create a developers account using your Baylor email
* Sign in to your developers account, and click the download link in the top right of the website.
* Select "Corona SDK" for either Mac or Windows depending on your machine. This will install the corona simulator.
* Run Corona Simulator
* Select "New Project" from the main menu, and navigate to the BRIC_DropTowerApp local repo on your machine. 
* Select the trunk folder as your project and then run it. The simulator should pop up showing a phone display of the app.

# Lua Notes

Lua is like a cross between Python and Java. The syntax will feel a little weird at first, but for the most part it’s actually usually simpler than most languages you’re probably familiar with.

Notable unique syntax and quirks:
  * Lines do not necessarily end with a semicolon. Usually a semicolon will be ignored, but sometimes it may cause problems, so I recommend using only line breaks instead.
  * Instead of null, Lua uses the keyword ```nil```, which otherwise functions as Java’s “null”.
  * Variables do not have fixed types, so there is no type safety in Lua. The language simply does its best to work with what is given, and if a value doesn’t make sense, the function will usually return ```nil```.
  * ```if``` statements do not use curly braces. Instead, they use keywords ```then``` and ```end```. In fact, ```end``` is usually used where C++ or Java would have a closing curly brace, such as to terminate functions.
  * The keyword ```elseif``` is only one word. 
  * What in other languages would be a do/while loop is a ```repeat```/```until``` loop in Lua.
  * When accessing an object’s member variables, use a period as normal; however, when calling member functions, use a colon instead (e.g. ```object.value``` versus ```object:function()``` )
  * Most Boolean logic operators are spelled out instead of using symbols; specifically ```and```, ```not```, and ```or```.
  * The comparator for “not equals” is ```~=``` instead of ```!=```
  * Single line comments are denoted with a double hyphen (```--```). Block comments are begun with a double hyphen followed by a double open square bracket (```--[[```) and ended by a double close square bracket followed by another double hyphen (```]]--```).
  * When defining a table, use curly braces.
  * All variables are assumed to be global unless declared with the keyword ```local```. It is recommended that you make as many variables local variables as possible, as local variables are significantly faster to access, in addition to reducing the chance of accidentally changing a variable you did not intend to change.
  * Importing files uses the ```require``` function, which either returns the object or value created by a previous calling of ```require```, or treats the code in the specified file as a self-contained function and runs and returns as such.
  * Like Java, all variables are passed by reference. Unlike Java, there are no "primitive" variables (only literals can be primitives)
  * Strings start at index 1 instead of 0. Arrays still start at index 0. I don't know why.
  * Instead of Java's ```this```, Lua uses the effectively identical keyword ```self```.

For more information and a detailed guide of Lua syntax, consult the [Lua Reference Guide](https://www.lua.org/manual/5.3/).
  
# Corona Basics

Most of what you'll be doing in Corona is specifying what you want to put on the screen and where you want to put it. If you've had experience with 2D engines before, many things should feel familiar to you. Notably, while coordinates in the positive X direction lie to the screen's right as one would expect in a Euclidean system, the Y axis increases as one travels further *down* the screen. Thus the origin (0,0) is in the top left hand corner of the screen. When placing objects, you will provide an x and y coordinate for the object. These coordinates usually refer to the center of the object to be placed (with a few sparse but seemingly random exceptions, such as web popups).

Almost everything that shows up on the screen is a [DisplayObject](https://docs.coronalabs.com/api/type/DisplayObject/index.html). The three objects we ended up using the most were [image rectangles](https://docs.coronalabs.com/api/library/display/newImageRect.html), [buttons](https://docs.coronalabs.com/api/type/ButtonWidget/index.html), and [display groups](https://docs.coronalabs.com/api/type/GroupObject/index.html).  Other notable objects include [text objects](https://docs.coronalabs.com/api/type/TextObject/index.html), [regular rectangles](https://docs.coronalabs.com/api/library/display/newRect.html), [videos](https://docs.coronalabs.com/api/type/Video/index.html), and [WebViews](https://docs.coronalabs.com/api/type/WebView/index.html) (which are not the same as the semi-depricated [web popups](https://docs.coronalabs.com/api/library/native/showWebPopup.html)). Notably, videos and webviews are *not* part of the DisplayObject heirarchy and will both display over any existing DisplayObjects.  Below are some short summaries of these frequently used objects. You can also check the [Corona API Reference](https://docs.coronalabs.com/api/index.html) for specific questions. The API is searchable using the search bar at the top.

### Image Rectangles
Image rectangles are the simplest way to get an image onto the screen. To create one, call [display.newImageRect()](https://docs.coronalabs.com/api/library/display/newImageRect.html). The simplest call to the function contains (in order) the relative path to the filename and the width and height of the image, as it should be displayed on the screen. The image Since X and Y are not defined for the image, you will need to set them on the following lines. As an example:
~~~
local bkg = display.newImageRect( "images/DropTowerDiagram.png", gW, gH )
bkg.x = display.contentCenterX
bkg.y = display.contentCenterY
~~~
By default, the path to the image is in the ```system.ResourceDirectory```, which is the directory where main.lua is. You can also specify that you wish to use ```system.DocumentsDirectory``` after the filename but before the width and height. The documents directory is where saved data for the app is stored, so it is unlikely that you will want to load an image here unless you have something like a screenshot taken with ```display.save()``` or some other dynamically created image.

Corona supports both JPG and PNG formats. Transparency is preserved for PNG images.

### Buttons
Buttons are the fundamental interactive element of Corona. They are set up to call a function when interacted with, and can be visually designed in a number of ways. They are both DisplayObjects and Widgets, the latter of which is a library that must be included with the ```require``` command before being used, like so:
~~~
local widget = require( "widget" )
~~~
It is recommended that you include this line at the beginning of any file that contains buttons, for ease of use.  Once you have included widgets, you can create a button with the ```widget.newButton()``` function.  This function, like many of Corona's functions, takes a table of options that can be used to define the button's properties. These properties are explained in detail on [```widget.newButton()```'s API page](https://docs.coronalabs.com/api/library/widget/newButton.html), but the basic things to set are the button's ```x``` and ```y```, the ```onPress```, ```onRelease``` and/or ```onEvent``` function callbacks, and the ```height``` and ```width``` of the button. There are other properties that should be set depending on whether you want an image button or just a drawn object button, as detailed in the previously linked API page. An example button is presented below:
~~~
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
~~~ 
The button described here is comprised of a rectangle object. Drawn buttons such as these tend to require more parameters to be defined than with image-based buttons, but can be easier to modify. An example of an image-based button can be found below:
~~~
local baylorButton = widget.newButton(
	{
		id = "BaylorLogo",
		defaultFile = "images/BaylorGreen.png",
		overFile = "images/BaylorGreen.png",
		onRelease = handleWebEvent,
		x = display.contentCenterX / 2,
		width = display.contentCenterX,
		y = gH - (gH * 0.086 * 0.5),
		height = gH * 0.086
	})
~~~

A few non-intuitive things are important to know about buttons. First, if two buttons are overlapping, only the topmost button's event will fire. Second, if a button is invisible (whether by setting ```isVisible``` to ```false``` or setting the button's alpha to 0), it cannot be interacted with in any way. If an invisible button is overlapping a visible button and the invisible button would be on top if it were visible, the visible button would still fire instead of the invisible one. Finally, buttons will still fire if covered by a non-button object. That is, only buttons can cover up functional areas of other buttons.

### Display Groups
Normally, objects in Corona are displayed in the order they are created, with the most recently created object on top. However, if an object is part of a DisplayGroup, it is rendered alongside the other objects in the group, with the most recently added object displayed on top. DisplayGroups are also helpful for grouping several DisplayObjects together in order to, for example, turn them all invisible at the same time.  To add a DisplayObject to a DisplayGroup, simply call the group's ```insert()``` method after creation the object, like so:
~~~
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
~~~

As mentioned earlier, objects inserted into DisplayGroups are displayed in the order they are inserted into the group. Thus, in the following code, ```dropShadowTitle``` is the at the "bottom" of the display and will render below everything, while ```backButtonL``` will render on top of any other object it overlaps with, regardless of what order the objects were created in.
~~~
titleGroup:insert(dropShadowTitle)
titleGroup:insert(titleText)
titleGroup:insert(descText)
titleGroup:insert(playGameButton)
titleGroup:insert(backButtonL)
~~~

It is also important to note that a group can be a member of another group. If a group contains a subgroup, all of the subgroup's members will be rendered in the order they were inserted into the subgroup at the point the subgroup was inserted into the main group.

### Text Objects
Text objects are more or less exactly what they sound like: ```DisplayObjects``` designed to display text. They are created with the ```display.newText()``` function which, like buttons, takes a table of options as its argument, as shown below:
~~~
learnText = display.newText(
	{
		text = "Click on a section to learn more!",
		x = display.contentCenterX * .20,
		y = display.contentCenterY * .92,
		font = native.systemFont,
		fontSize = 7,
		align = "center",
		width = display.contentCenterX * .30,
		height = gH / 11
	})
learnText:setFillColor(0,0,0,1)
~~~
The preceding code illustrates a number of the key elements of the table, such as the expected ```height```, ```width```, ```x```, ```y```, and ```text``` fields, but it also shows some that may have been less obvious, such as ```font``` and ```fontsize```. Text objects will print the string they are given as well as they can in the height and width they're given, breaking into multiple lines if possible. If there is not enough room, the text will not all appear. If you are not sure how large you need the box to be, you can simply leave ```height``` and/or ```width``` out of the table. If a ```TextObject``` is given a ```width``` without a ```height```, it will be fixed at that width and take up as many lines as necessary to display all of the text provided, centered on the ```y``` given.  If there is no fixed ```height``` or ```width```, you can get how wide or tall the ```TextObject``` ended up after rendering by using ```TextObject.height``` or ```TextObject.width```. Unfortunately, some devices have a higher resolution available than others, so a font size that looks fine on one device may appear too large or small on another. To correct this, we've written an algorithm that can resize text to fit a given area. There were too many possible constraints to effectively make it its own function, but the general form is illustrated by the following code:
~~~
local i = 31
repeat
	if(nettingText ~= nil) then
		nettingText:removeSelf()
	end
	i = i - 1
	nettingText = display.newText(
		{
			text="This is test text.",
			x=nettingTextBkg.x,
			y=nettingTextBkg.y,
			width=nettingTextBkg.width,
			font=native.systemFont,
			fontSize=i,
			align="center"
		})
until nettingText.height <= nettingTextBkg.height or i == 1
nettingText:setFillColor(0,0,0,1)
~~~
In short, this segment of code creates a text box, detects if it exceeds the size of the box it is supposed to be in, and, if it is too large, deletes the ```TextObject``` and creates one with a font size smaller.  This results in the text taking up as much of the given area as possible without exceeding the alotted space.
Both of these examples also illustrate that the fill color for a text object is not a property that can be set in the options table, and must be set with the [```setFillColor()``` function](https://docs.coronalabs.com/api/type/ShapeObject/setFillColor.html). If you do not use this function, the text defaults to white.

### Rectangles
In addition to image rectangles, it is possible in Corona to create rectangles of a solid color, with or without a secondary outlining color. The process is fairly simple: call ```display.newRect()``` with the desired ```x```, ```y```, ```width```, and ```height``` (in that order). After creating the rectangle, you can change its color with the ```setFillColor()``` command, which takes up to 4 values ranging from 0 to 1: ```red```, ```green```, ```blue```, and ```alpha```. The first three function as you would expect, representing the intensity of one of the primary colors in the overall color. An object's ```alpha``` can be changed to set its transparency; that is, a lower ```alpha``` means an object will appear less visible. If you do not provide an ```alpha```, the current one will remain (1, or completely opaque, is the default).  Rectangles are commonly used to create solid background colors in the app, as demonstrated below:
~~~
local bkg = display.newRect(display.contentCenterX, display.contentCenterY, gW, gH)
bkg:setFillColor(0.3, 0.5, 0.9, 1)
~~~
You can also give the rectangle an outline using the ```strokeWidth``` property and the ```setStrokeColor``` function. A rectangle's ```strokeWidth``` is the number of pixels wide its outline should be. After setting this to a non-zero value and setting the stroke color with ```setStrokeColor()``` (which functions identically to ```setFillColor()``` as described above), an outline should appear around the rectangle.  If you like, you can even set the fill color's ```alpha``` to 0 and have only the outline, as demonstrated by the following code:
~~~
learnRect = display.newRect(display.contentCenterX * .20, display.contentCenterY * .85, display.contentCenterX * .40, gH / 10)
learnRect:setFillColor(0,0,0,0)
learnRect:setStrokeColor(1,1,0)
learnRect.strokeWidth = 3
~~~
As it was frequently more helpful to use image rectangles, "normal" rectangles are used only sparsely throughout the app, however they are used enough to be familiar with them.

### Videos
Videos are expected to be one of the highlights of the app, so despite the fact that they may be used infrequently, it is important to know how they work. First, videos to be displayed should be types that can be played by the desired device. In general, iOS devices have tighter restrictions on which videos can be played. These restrictions are described in [the API entry for ```media.playVideo()```](https://docs.coronalabs.com/api/library/media/playVideo.html). Assuming the video files are supposed to be local instead of remote (highly recommended since one of the stated goals for the project was to have a working version even without the internet), they should be saved in the project folder where main.lua can be found, or in a subfolder of that folder.

There are two ways to play a video in Corona: in-app or in the device's native standalone player. In the app so far, we have exclusively used the former, as the standalone player does not provide the same amount of control, nor does it allow for additional content to be displayed while the video is playing. If you wish to use the standalone player, read the API entry for ```media.playVideo()``` linked above.  For embedded video, you'll use the ```native.newVideo()``` command.  It should be noted that neither way of displaying videos works in the Corona simulator, so to test you'll need to install the app on a testing device.

To play an embedded video, first you must create the video by calling ```native.newVideo()```. This function takes ```x```, ```y```, ```width```, and ```height```. You must then call the ```load()``` function on the video object, which takes a path to the video as a string. Finally, you must either play the video, or set up a video listener to play the video once it has been loaded (the latter is preferred). For example, see the code below:
~~~
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

video = native.newVideo(display.contentCenterX * 1.45, display.contentCenterY * .975, display.contentCenterX * .6, display.contentCenterY * .5)
video:load("videos/ExperimentPageVid.mp4")
video:addEventListener("video", videoListener)
~~~
One final note: unlike DisplayObjects, videos are not part of the display heirarchy and are rendered on top of everything else. In short, they are automatically at the "top" of the display stack.

### WebViews
WebView objects are a way to display web pages inside the app without requiring the user to switch to their native browser. In the app, it is used to bring up the Baylor and BRIC home pages, as well as the companion website.  Bringing up a WebView is a fairly simple two-step process. First, call ```native.newWebView()```, which takes parameters for ```x```, ```y```, ```width```, and ```height``` of the new WebView, in that order. Next, simply call ```request()``` on the WebView object, which takes a string to the desired webpage, as seen below:
~~~
webDisplay = native.newWebView(display.contentCenterX, gH * 0.45, gW, gH * 0.9)
webDisplay:request("https://www.baylor.edu")
~~~
To dismiss the WebView, you must call ```removeSelf()``` on it. This will erase the webpage from the screen and stop any loading it was doing.  Like videos, WebView objects are not part of the display heirarchy and are rendered on top of everything else on the screen.

# Developers Manual
This application is split up into 9 states, each with their own file containing buttons, images, and handlers for them accordingly.

__9 States__
  * [Main Menu](#Main-Menu)
  * [Winch Informational Page](#winch-informational-page)
  * [Capsule Informational Page](#capsule-informational-page)
  * [Deceleration Chamber Informational Page](#feceleration-chamber-informational-page)
  * [Netting Informational Page](#netting-information-page)
  * [Drop Tower Informational Page](#drop-tower-informational-page)
  * [Run an Experiment Page](#run-an-experiment-page)
  * [Drop Tower Fix-it Interactive Game](#drop-tower-fix-it-interactive-game)
  * [Physics Game](#physics-game)

  ### Main Menu
  All of the code for the main menu can be found in trunk/main.lua.
  From the main menu state you can go to each of the other 7 states directly.

  ![Main Menu](https://github.com/saulf95/BRIC_DropTowerApp/blob/master/images/mainmenu.PNG "Main Menu")


  There are 7 navigational buttons on this page, as well as 2 additional buttons to access Baylor's official website and BRIC's official website. The group name for these buttons is mainMenuButtons.

  The first navigational buttons are placed on top of the drop tower image and are the four colored boxes. These lead to the informational pages for each respective drop tower component. There is also an informational page for the entire drop tower located on the right side.
  * decelButton
  * netButton
  * capsuleButton
  * winchButton
  * dropTowerButton

  There are two more navigational buttons blow the drop tower that lead to the experiment menu and the fix-it interactive game.
  * experimentButton
  * repairButton

  Each of the buttons in mainMenuButton group are handled by sectionButtonHandler which determines what state the app changes to depending on which main menu button is clicked. 


  ## Winch Informational Page

  ## Capsule Informational Page

  ## Deceleration Chamber Informational Page

  ## Netting Informational Page

  ## Drop Tower Informational Page
  ![Drop Tower Info Page](https://github.com/saulf95/BRIC_DropTowerApp/blob/master/images/droptowerinfo.PNG "Drop Tower Info Page")

  ## Run an Experiment Page
  ![Experiment Page 1](https://github.com/saulf95/BRIC_DropTowerApp/blob/master/images/experimentpage1.PNG "Experiment Home Page")
  ![Experiment Page 2](https://github.com/saulf95/BRIC_DropTowerApp/blob/master/images/experimentpage2.PNG "Run Experiment Page")
  Experiment Menu Page -----------------------------------------------  Run Experiment Page --------------------------------------

  The experiment state contains two states within it, the experiment menu page and the run experiment page. Both can be found in trunk/experiment.lua.

  Both states contain the same back bar named **backButton** handled by **buttonHandler**

  In State 0 (Experiment Main Menu) there are two buttons aside from the back bar. 
  * expPageButtonTop

     This top button is handled by handleMicroGravEvent which changes the text in the button to give a definition of microgravity.

  * expPageButtonBottom

     The bottom button is handled by buttonHandler and changes the experiment state from menu to Run Experiment Page.

  In State 1 (Run Experiment Page)

  **Under construction**

  

  ## Drop Tower Fix-it Interactive Game
  ![Fix-it](https://github.com/saulf95/BRIC_DropTowerApp/blob/master/images/fixitmenu.PNG "Fix-it Menu")
  
  ## Physics Game
  ![Physics Game](https://github.com/saulf95/BRIC_DropTowerApp/blob/master/images/physicsgame.PNG "Physics Game")


