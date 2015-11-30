# Introduction #

Adding a Unity3d application following the Unity Forums is simple. But when the webpage grows in layout complexity it's necessary a way to fit the content of the application into the site structure. Besides, many sites use Flash/AS3 content, like menus, forms, animations and others. These elements sometimes guide the navigation to the Unity3d content and need to pass or retrieve some information.
The most pratical way to do these operations is by Javascript in the browser and ExternalInterface in the Flash/AS3, so the Unity3dObject set of tools will aim to simplify these operations to the end user.


## What is u3dobject? ##

  * Set of tools that simplify the integration of Unity3d content into HTML pages using or not Flash/AS3 elements.
  * User can embbed a clip with any size in any part of the webpage.
  * It's possible to show/hide the Unity content if it's needed.
  * Call events/functions of Unity3d content from within Flash/AS3 content.
  * Call events/functions of Flash/AS3 content from within Unity3d content.
  * Provide JS tools to easily detect the need of plugin install.
    * Also provides the correct download URL for the download.
  * Can be used together with the most common Flash-Embbeding technology like [SWFObject2.0](http://code.google.com/p/swfobject).
  * Offers a Flash/AS3 and Unity3d profilers that can be used to test the communication between applications.

## Profiler? ##

  * A simple application to debug communication between Flash and a Unity3d application. It can call the visibility functions used in order to show and hide the unity content and call functions and events inside it too.
  * Users can choose the div where the Unity3d is placed and the object inside it that will be called.
  * It was develop on top of the UnityInterface AS3 class, so most of it's functionality is present in the class source.
![http://www.thelaborat.org/img/flash_unity_profiler.jpg](http://www.thelaborat.org/img/flash_unity_profiler.jpg)
  * 'Console' shows the reports from Flash and Unity side, if a method is called from inside the Unity3d content it's reported in the console it's name and parameters.
  * 'Clear' .. well.. it clears the console :)
  * 'Command' is the place where the user will call methods inside the unity application. The format of function call is the classic one 'function\_name(... parameters)' as one String only.
  * 'Target' is the HTML element where the unity content is placed (e.g. the Div id). The default name choosed is 'div\_unity' if you don't specify any.
  * 'Object' is the name of the Object inside your Unity application that has the methods being called. The default used is "ExternalInterface" used in order to match AS3 code.
  * 'Visible' tests if your application is being hidden or shown correctly when the JS command for show/hide is called.
  * 'Width'/'Height' pass the size of the div for the unity application being embbeded.
  * 'Filename' is just the name of your content's file that will be embbeded.
  * 'Embbed' button that will embbed your unity application with the passed parameters.
  * 'Event/Parameter' Name of the event that will be passed to the Unity class 'ExternalEvent' this class name is default. If you want to listen to events passed you need to implement this class. A String parameter can be passed to the event called.
  * 'Send' button sends the event written in the fields.