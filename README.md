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

# Lua Basics

Lua is like a cross between Python and Java. The syntax will feel a little weird at first, but for the most part it’s actually usually simpler than most languages you’re probably familiar with.
Notable unique syntax and quirks:
  * Lines do not necessarily end with a semicolon. Usually a semicolon will be ignored, but sometimes it may cause problems, so I recommend using line breaks instead.
  * Instead of null, Lua uses the keyword nil, which otherwise functions as Java’s “null”.
  * Variables do not have fixed types, so there is no type safety in Lua. The language simply does its best to work with what is given, and if a value doesn’t make sense, the function will usually return nil.
  * If statements do not use curly braces. Instead, they use keywords then and end. In fact, end is usually used where C++ or Java would have a closing curly brace, such as to terminate functions.
  * The keyword elseif is only one word. 
  * What in other languages would be a do/while loop is a repeat/until loop in Lua.
  * When accessing an object’s member variables, use a period as normal; however, when calling member functions, use a colon instead (e.g. object.value versus object:function() )
  * Most Boolean logic operators are spelled out instead of using symbols; specifically and, not, and or.
  * The comparator for “not equals” is ~= instead of !=
  * Single line comments are denoted with a double hyphen (“--“). Block comments are begun with a double hyphen followed by a double open square bracket (“--[[“) and ended by a double close square bracket followed by another double hyphen (“]]--“).
  * When defining a table, use curly braces.
  * All variables are assumed to be global unless declared with the keyword local. It is recommended that you make as many variables local variables as possible.
  * Importing files uses the require function, which either returns the object or value created by a previous require, or treats the code in the specified file as a self-contained function and runs and returns as such.
  * Like Java, all variables are passed by reference. Unlike Java, there are no "primitive" variables (only literals can be primitives)


# Developers Manual
This application is split up into 8 states, each with their own file containing buttons, images, and handlers for them accordingly.

__8 States__
  * [Main Menu](#Main-Menu)
  * [Winch Informational Page](#winch-informational-page)
  * [Capsule Informational Page](#capsule-informational-page)
  * [Deceleration Chamber Informational Page](#feceleration-chamber-informational-page)
  * [Netting Informational Page](#netting-information-page)
  * [Drop Tower Informational Page](#drop-tower-informational-page)
  * [Run an Experiment Page](#run-an-experiment-page)
  * [Drop Tower Fix-it Interactive Game](#drop-tower-fix-it-interactive-game)
  
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
  


