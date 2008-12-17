/*
	<aquiris-u3dobject> aka Unity Integration API
    Copyright (C) 2008 Raphael Lopes Baldi, Eduardo Pons Dias da Costa, Aquiris Realidade Virtual

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

browser = (navigator.appVersion.indexOf("MSIE") >=0) && 
		  (navigator.appVersion.toLowerCase().indexOf('win')>=0)     ?  "MSIE_win"  : 
		  (navigator.appVersion.toLowerCase().indexOf('safari') >=0) ?  "safari"    : 
		  (navigator.appVersion.toLowerCase().indexOf('firefox') >=0) ? "firefox"   : "other";

var div_width = new Array();
var div_height = new Array();
var unity_objects = new Array();
var iframe_objects = new Array();
var div_objects = new Array();

var counter = 0;

//Embbed function, responsible for embeding the unity content into the website.
//p_file -> The unity's filename (can be a relative path, like unity/myFile.unity3d);
//p_div_name -> The div where you want the content to be placed. You must pass in the div name of a div that have not been used before to hold any unity file (the function will not embed if the div is holding another unity file);
//p_width -> The width of the unity;
//p_height -> The height of the unity;
function embbed(p_file, p_div_name, p_width, p_height)
{	
	if(isUnityInstalled && div_objects[p_div_name] == null)
	{
		var div_unity = document.getElementById(p_div_name);
		
		div_objects[p_div_name] = div_unity;
		
		var write_iframe = '<iframe id="iframe_unity' + counter + '" frameborder="0" width="100%" height="' + p_height + '" scrolling="no" src="blank.html"></iframe>';
		
		div_unity.innerHTML = write_iframe;
		
		var iframe = document.getElementById("iframe_unity" + counter);
		
		iframe_objects[p_div_name] = iframe;
		
		div_unity.appendChild(iframe);
		
		doc = null;
		
		if(iframe.contentDocument)
		{
			doc = iframe.contentDocument;
		}
		else if(iframe.contendWindow)
		{
			doc = iframe.contentWindow;
		}
		else if(iframe.document)
		{
			doc = iframe.document;
		}
		
		if(doc == null)
		{
			throw "An error ocurred while trying to access the created element. The content div was not processed!";
		}
		else
		{
			doc.open();
			doc.write('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">');
			doc.write('<html>');
			doc.write('<head>');
			doc.write('<style>');
			doc.write('*');
			doc.write('{');
			doc.write('	margin:0;');
			doc.write('	padding:0;');
			doc.write('}');
			doc.write('</style>');
			doc.write('<script type="text/javascript">');
		
			doc.write('function callFlashFunction(p_swf, p_function)');
			doc.write('{');
			doc.write('	parent.callFlashFunction(p_swf, p_function);');
			doc.write('}');
			
			doc.write('function hide(p_div)');
			doc.write('{');
			doc.write('	parent.hide(p_div);');
			doc.write('}');
			
			doc.write('function show(p_div)');
			doc.write('{');
			doc.write('	parent.show(p_div);');
			doc.write('}');
			
			doc.write('function callLoadProgress(p_swf, p_progress)');
			doc.write('{');
			doc.write('	parent.callLoadProgress(p_swf, p_progress);');
			doc.write('}');
			
			doc.write('function callCompleted(p_swf)');
			doc.write('{');
			doc.write('	parent.callCompleted(p_swf);');
			doc.write('}');
			
			doc.write('</script>');
			doc.write('</head>');
			doc.write('<body>');
			doc.write('<object classid="clsid:444785F1-DE89-4295-863A-D46C3A781394" codebase="http://webplayer.unity3d.com/download_webplayer/UnityWebPlayer.cab#version=2,0,0,0" id="UnityObject' + counter + '" width="'+p_width+'" height="'+p_height+'">');
			doc.write('<param name="src" value="'+p_file+'"/>');
			doc.write('<param name="disableContextMenu" value="true"/>');
			doc.write('<param name="allowScriptAccess" value="always" />');
			doc.write('<embed type="application/vnd.unity" pluginspage="http://www.unity3d.com/unity-web-player-2.x" id="UnityEmbed' + counter + '" width="'+p_width+'" height="'+p_height+'" src="'+p_file+'" disableContextMenu="true" allowScriptAccess="always" /></object>');
			doc.write('</body>');
			doc.write('</html>');
			doc.close();
			
			div_width[p_div_name] = p_width;
			div_height[p_div_name] = p_height;
			
			var reference = iframe.contentWindow.document;
		
			try
			{
				switch(browser)
				{
					case "MSIE_win":
					case "safari":
					
					id = "UnityObject" + counter;
					
					break;
					
					default:
					
					id = "UnityEmbed" + counter;
					
					break;
				}
				unity_objects[p_div_name] = reference.getElementById(id);
				
				counter += 1;
			}
			catch (e) 
			{
				unity_objects[p_div_name] = null;
			}
		}
	}
}

//Hide function, responsible for hide the unity content.
//If you want to place the unity div on top of some flash content, you must place the unity div in a higher z-index trough CSS
//p_div_name -> The name of the div that contains the content you want to hide
function hide(p_div_name)
{
	var div_unity = div_objects[p_div_name];
	var iframe_unity = iframe_objects[p_div_name]
	var div_style = div_unity.style;
	
	var ua = navigator.userAgent.toLowerCase();
		
	if(ua.indexOf('firefox') != -1)
	{
		if(navigator.platform.toLowerCase().indexOf('mac') != -1)
		{
			div_unity.style.visibility = 'visible';
			div_unity.style.width = '1px';
			div_unity.style.height = '1px';
			iframe_unity.visibility = 'visible';
			iframe_unity.width = '1px';
			iframe_unity.height = '1px';

		}
		else
		{
			div_unity.style.visibility = 'hidden';
		}
	}
	else
	{
		div_unity.style.visibility = 'visible';
		div_unity.style.width = '1px';
		div_unity.style.height = '1px';
		iframe_unity.visibility = 'visible';
		iframe_unity.width = '1px';
		iframe_unity.height = '1px';
	}
}

function show(p_div_name)
{
	var divUnity = div_objects[p_div_name];
	var iFrameUnity = iframe_objects[p_div_name];
	var div_style = divUnity.style;
	
	var ua = navigator.userAgent.toLowerCase();
		
		if(ua.indexOf('firefox') != -1)
		{
			if(navigator.platform.toLowerCase().indexOf('mac') != -1)
			{
				divUnity.style.visibility = 'visible';
				divUnity.style.width = div_width[p_div_name] + 'px';
				divUnity.style.height = div_height[p_div_name] + 'px';
				iFrameUnity.visibility = 'visible';
				iFrameUnity.width = div_width[p_div_name] + 'px';
				iFrameUnity.height = div_height[p_div_name] + 'px';
			}
			else
			{
				divUnity.style.visibility = 'visible';
			}
		}
		else
		{
			divUnity.style.visibility = 'visible';
			divUnity.style.width = div_width[p_div_name] + 'px';
			divUnity.style.height = div_height[p_div_name] + 'px';
			iFrameUnity.visibility = 'visible';
			iFrameUnity.width = div_width[p_div_name] + 'px';
			iFrameUnity.height = div_height[p_div_name] + 'px';
		}
}

function getPluginPath()
{
	var platform = (navigator.platform == "MacIntel")     ? "mac_intel" :
				    (navigator.platform == "MacPPC")       ? "mac_ppc"   :
					(navigator.platform.indexOf("Mac")>=0) ? "mac"       :
					(navigator.platform.indexOf("Win")>=0) ? "win"       : "other";
				
	switch(platform)
	{
		case "mac_intel": { return "http://webplayer.unity3d.com/download_webplayer-2.x/webplayer-i386.dmg"; break; }
		case "mac"  	: { return "http://webplayer.unity3d.com/download_webplayer-2.x/webplayer-ppc.dmg"; break; }
		case "mac_ppc"  : { return "http://webplayer.unity3d.com/download_webplayer-2.x/webplayer-ppc.dmg"; break; }
		case "win"      : { return "http://webplayer.unity3d.com/download_webplayer-2.x/UnityWebPlayer.exe"; break; }
	}	
	return "http://unity3d.com/unity-web-player-2.x";
}

function autoReload()
{
	navigator.plugins.refresh();
	if(isUnityInstalled()) 
	{
		window.location.reload();
	}
	else
	{
		setTimeout('autoReload();', 1000);
	}
}

function isUnityInstalled()
{
	navigator.plugins.refresh();
	
	var tInstalled = false;
	if(this.browser == "MSIE_win")	
	{
		tInstalled = DetectUnityWebPlayerActiveX();
	}
	else
	{
		if(navigator.mimeTypes && navigator.mimeTypes['application/vnd.unity'])
		{
			if(navigator.mimeTypes['application/vnd.unity'].enabledPlugin && navigator.plugins && navigator.plugins['Unity Player'])
			{
				tInstalled = true; 
			}
		}
	}
	
	if(tInstalled == 1)
	{
		tInstalled = true;
	}
	else if(tInstalled == 0)
	{
		tInstalled = false;
	}
	
	return tInstalled;
}

function dispatchUnityEvent(p_div_name, p_evt_name, p_data)
{
	unity_objects[p_div_name].SendMessage("ExternalInterface", "OnExternalEvent", p_evt_name + '(' + p_data + ')');
}

function callUnityFunction(p_div_name, p_target, p_function)
{
	var function_name = p_function.split("(")[0];
	var params = p_function.substring(p_function.indexOf("(") + 1, p_function.indexOf(")"));
	unity_objects[p_div_name].SendMessage(p_target, function_name, params);
}

function callFlashFunction(p_swf, p_function)
{
	var swf_obj = (navigator.appName.indexOf('Microsoft') >=0) ? window[p_swf] : document[p_swf];
	
	swf_obj.callFlashInterface(p_function);
}

function callLoadProgress(p_swf, p_progress)
{
	var swf_obj = (navigator.appName.indexOf('Microsoft') >=0) ? window[p_swf] : document[p_swf];
	
	swf_obj.callProgressEvent(p_progress);
}

function callCompleted(p_swf)
{
	var swf_obj = (navigator.appName.indexOf('Microsoft') >=0) ? window[p_swf] : document[p_swf];
	
	swf_obj.callCompleteEvent();
}

if(!isUnityInstalled)
{
	autoReload();
}