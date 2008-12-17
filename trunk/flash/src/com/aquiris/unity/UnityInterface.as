/**
	<aquiris-u3dobj> aka Unity Integration API. 

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
/**
 * Static class that implements a simple JS/flash interface that allows the user to obtain the maximum of interoperability between the swf movies and any 
 * Unity application running inside the site. 
 */
package com.aquiris.unity 
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;	
	import com.aquiris.events.UnityEvent;
	
	public class UnityInterface
	{		
		
		public static const DEFAULT_PLUGIN_PATH			:String = "http://unity3d.com/unity-web-player-2.x";
		
		public static const JS_DEFAULT_DIV_NAME			:String = "div_unity";
		public static const JS_DEFAULT_UNITY_OBJECT		:String = "ExternalInterface";
		
		private static const JS_FUNC_EMBED					:String = "embbed";		
		private static const JS_FUNC_SHOW					:String = "show";
		private static const JS_FUNC_HIDE					:String = "hide";
		private static const JS_FUNC_PLUGIN_PATH			:String = "getPluginPath";
		private static const JS_FUNC_IS_UNITY_INSTALLED		:String = "isUnityInstalled";
		private static const JS_FUNC_FLASH_LISTENER			:String = "callFlashInterface";
		private static const JS_FUNC_CALL_PROGRESS_EVENT	:String = "callProgressEvent";
		private static const JS_FUNC_CALL_COMPLETE_EVENT	:String = "callCompleteEvent";
		private static const JS_FUNC_CALL_UNITY				:String = "callUnityFunction";		
		private static const JS_FUNC_DISPATCH_UNITY_EVENT	:String = "dispatchUnityEvent";
		
		/**
		 * Flag that indicates if the External JS interface is available.
		 */
		public  static var	 JS_AVAILABLE		 			:Boolean = false;		
		
		/**
		 * Max Timeout for Plugin detection.
		 */
		public  static var 	MAX_TIMEOUT		:Number  = 5;
		/**
		 * Timeout delay interval.
		 */
		public  static var  TIMEOUT_DELAY	:Number = 1000;
		/**
		 * Timer used for the timeout events.
		 */
		private static var timer		:Timer;
		/**
		 * Event dispatcher
		 */
		private static var dispatcher	:EventDispatcher;
		/**
		 * Flag that indicates if the internal static data is initialized.
		 */
		private static var hasInit		:Boolean = false;
		/**
		 * Flag that indicates if the internal static data is initialized.
		 */
		private static var is_loaded	:Boolean = false;
		/**
		 * Flag that indicates the status initialization returned true or false
		 */
		private static var status	:Boolean = false;
		/**
		 * Timeout counter.
		 */
		public  static var timeout_count:Number  = MAX_TIMEOUT;
		
		/**
		 * Link to the Unity webplayer installer for the platform running the swf.
		 */
		public static function get pluginDownloadPath():String
		{
			init();
			var res:* = js_call(JS_FUNC_PLUGIN_PATH);			
			return (res == null) || (res == "") ? DEFAULT_PLUGIN_PATH : res;
		}
		/**
		 * Flag that indicates the presence or absence of the Unity webplayer.
		 */
		public static function get hasUnity():Boolean
		{
			init();
			var res:* = js_call(JS_FUNC_IS_UNITY_INSTALLED);			
			return (res == null) ? false : res;
		}
				/**
		 * Initializes the interface checking if Unity and ExternalInterface is available in the page.
		 * @return Boolean - Flag that indicates if the intergace is available
		 */
		public static function initialize(p_max_timeout:int=5):Boolean
		{
			
			init();		
			if (is_loaded) return status;
			is_loaded = true;
			if (!JS_AVAILABLE)
			{
				ev_error(UnityEvent.ERROR_JS_NOT_AVAILABLE);
				return  status = false;
			}
			
				
			MAX_TIMEOUT = p_max_timeout;
			try 
			{
				ExternalInterface.addCallback(JS_FUNC_FLASH_LISTENER, 	   on_unity_call);
				ExternalInterface.addCallback(JS_FUNC_CALL_PROGRESS_EVENT, on_unity_progress);
				ExternalInterface.addCallback(JS_FUNC_CALL_COMPLETE_EVENT, on_unity_complete);
				if (hasUnity) { dispatchEvent(UnityEvent.UNITY_READY); return status = true; }
				else 
				{
					(timer = new Timer(TIMEOUT_DELAY)).addEventListener(TimerEvent.TIMER, on_plugin_timeout);
					timer.start();
				}							
			}
			catch (error:SecurityError){ ev_error(error.message);}
			catch (error:Error)        { ev_error(error.message);}
			return status = false;
		}
		/**
		 * Adds a listener for UnityInterface events.
		 * @param	p_callback Function that will receive.
		 */
		public static function addEventListener(p_callback:Function):void
		{	
			init();
			
			dispatcher.addEventListener(UnityEvent.UNITY_READY, 	 p_callback);			
			dispatcher.addEventListener(UnityEvent.PROGRESS,     	 p_callback);
			dispatcher.addEventListener(UnityEvent.COMPLETE,     	 p_callback);
			dispatcher.addEventListener(UnityEvent.UNITY_CALL,		 p_callback);			
			dispatcher.addEventListener(UnityEvent.ERROR, 			 p_callback);
			dispatcher.addEventListener(UnityEvent.PLUGIN_TIMEOUT,	 p_callback);
			dispatcher.addEventListener(UnityEvent.PLUGIN_ERROR, 	 p_callback);
			
			
		}
		/**
		 * Removes the listener assigned to the UnityInterface events.
		 * @param	p_callback Function to be removed.
		 */
		public static function removeEventListener(p_callback:Function):void
		{
			init();
			dispatcher.removeEventListener(UnityEvent.UNITY_READY, 		p_callback);			
			dispatcher.removeEventListener(UnityEvent.UNITY_CALL, 		p_callback);	
			dispatcher.removeEventListener(UnityEvent.PROGRESS,     	 p_callback);
			dispatcher.removeEventListener(UnityEvent.COMPLETE,     	 p_callback);
			dispatcher.removeEventListener(UnityEvent.ERROR, 			p_callback);
			dispatcher.removeEventListener(UnityEvent.PLUGIN_TIMEOUT,	p_callback);
			dispatcher.removeEventListener(UnityEvent.PLUGIN_ERROR, 	p_callback);
		}
		/**
		 * Dispatches an event relative to the UniyInterface
		 * @param	p_type Event type.
		 * @param	p_parameter Parameter passed tothe listener.
		 */
		public static function dispatchEvent(p_type:String,p_parameter:*=null):void
		{
			init();
			var ev:UnityEvent = new UnityEvent(p_type, p_parameter);			
			dispatcher.dispatchEvent(ev);
		}
		/**
		 * Embeds the unity in the div and starts its download.
		 * @return
		 */
		public static function embed(p_width:Number,p_height:Number,p_file_name:String,p_div_name:String=JS_DEFAULT_DIV_NAME):Boolean
		{
			init();
			var res:* = js_call(JS_FUNC_EMBED, p_file_name, p_div_name, p_width, p_height);			
			return res == null ? false : res;
		}	
		/**
		 * Calls an Unity method within the application with the format 'function_name(params ...)'
		 * @param	p_command Function command in the format 'function_name(params ...)'
		 * @param	p_target_object Unity object in the application that have the method being called.
		 * @param	p_div_unity Div inside the HTML that contains the Unity application.
		 */
		public static function call(p_command:String,p_target_object:String=JS_DEFAULT_UNITY_OBJECT, p_div_unity:String=JS_DEFAULT_DIV_NAME):void
		{
			//callUnity(p_unity_object,p_target,p_method,p_param)
			init();
			js_call(JS_FUNC_CALL_UNITY, p_div_unity, p_target_object, p_command);			
		}
		/**
		 * Shows the Unity application in the page.
		 * @param	p_div_unity Div that the Unity is inserted
		 */
		public static function showUnity(p_div_unity:String = JS_DEFAULT_DIV_NAME):void
		{
			init();
			js_call(JS_FUNC_SHOW, p_div_unity);
		}
		/**
		 * Hides the Unity application in the page.
		 * @param	p_div_unity Div that the Unity is inserted.
		 */
		public static function hideUnity(p_div_unity:String = JS_DEFAULT_DIV_NAME):void
		{
			init();
			js_call(JS_FUNC_HIDE, p_div_unity);
		}
		
		/**
		 * Dispatches an event inside the unity 'ExternalInterface' object, calling the function 'OnExternalEvent'.
		 * @param	p_event Event name.
		 * @param	p_parameter Parameter passed to the event.
		 * @param	p_div_unity Name of the div that contains the unity application.
		 */
		public static function dispatchUnityEvent(p_event:String,p_parameter:String="",p_div_unity:String=JS_DEFAULT_DIV_NAME):void
		{
			//callUnity(p_unity_object,p_target,p_method,p_param)
			init();
			js_call(JS_FUNC_DISPATCH_UNITY_EVENT, p_div_unity,p_event,p_parameter);
		}
		
		/**
		 * Initialize the static vars.
		 */
		private static function init():void
		{
			if (hasInit) return;
			hasInit 		= true;			
			dispatcher 		= new EventDispatcher();
			JS_AVAILABLE 	= ExternalInterface.available;
			
		}
		/**
		 * Shortcut for the ExternalInterface.call
		 * @param	... args Arguments for the ExternalInterface.call
		 * @return Object the data returned.
		 */
		private static function js_call(... args):*
		{
			init();
			try	
			{ 
				return ExternalInterface.call.apply(null, args);				
			} 
			catch (p_e:Error) 
			{ 
				ev_error(p_e.toString());
			}				
			return null;
			
		}
		/**
		 * Shortcut for an error event.
		 * @param	p_error String with the error.
		 */
		private static function ev_error(p_error:String):void
		{
			init();
			dispatchEvent(UnityEvent.ERROR, p_error);			
		}
		/**
		 * Receives incoming JS calls after the method "callFlashInterface" is called in JS.
		 * @param	p_param Received paramter
		 * @return Object - Flag indicating the result of the operation.
		 */
		private static function on_unity_call(p_param:String):*
		{
			init();			
			dispatchEvent(UnityEvent.UNITY_CALL, getMethodData(p_param));			
			return true;
		}
		private static function on_unity_progress(p_param:String):void
		{
			var r:Number = Number(p_param);
			r = isNaN(r) ? 0 : r;
			r = (r<0) ? 0 : (r>1 ? 1 : r);
			dispatchEvent(UnityEvent.PROGRESS, r);
		}
		private static function on_unity_complete():void
		{
			dispatchEvent(UnityEvent.COMPLETE);
		}
		/**
		 * Timeout after trying to test if javascript and unity are ready.
		 * @param	p_ev
		 */
		private static function on_plugin_timeout(p_ev:TimerEvent):void
		{		
			if (hasUnity)
			{                
                Timer(p_ev.target).stop();				
				dispatchEvent(UnityEvent.UNITY_READY);
            }
			else
			{
				timeout_count--;
				if (timeout_count > 0) { dispatchEvent(UnityEvent.PLUGIN_TIMEOUT); return; }				
				dispatchEvent(UnityEvent.PLUGIN_ERROR);
				Timer(p_ev.target).stop();				
			}
		}	
		/**
		 * Remove white spaces.
		 * @param	p_string
		 * @return
		 */
		private static function trimm(p_string:String):String
		{
			var trimmed:String = "";
			var ch0:String;
			var ch1:String = "";
			
			var len:Number = p_string.length;
			var is_string:Boolean = false;			
			for (var i:int = 0; i < len; i++)
			{
				ch0 = p_string.charAt(i);
				if (i > 0) ch1 = p_string.charAt(i - 1);
				if (ch0 == "\"")
					if (ch1 != "\\") is_string = !is_string;
				if (ch0 == " ") if (!is_string) ch0 = "";
				trimmed += ch0;
			}
			return trimmed;
		}
		/**
		 * Extracts method data and returns an Object with "method" and "argument" that contains the method name and Array of parameters.
		 * @param	p_param String that represents the method call.
		 * @return Object Container of all method information.
		 */
		private static function getMethodData(p_param:String):Object
		{			
			//    function    (    p0, p1, "lalallala            123",12         ) 
			//function(p0,p1,"lalallala            123",12) 
			//var p_param:String = "met____hod(12.   3  ,\"abcd e ee e e     \", 12 )";
			var trimmed:String = "";
			var ch0:String;
			var ch1:String = "";
			var temp:String = "";
			var params:String;
			var list:Array = [];
			var len:Number = p_param.length;
			var is_string:Boolean = false;
			var data:Object = { };
			for (var i:int = 0; i < len; i++)
			{
				ch0 = p_param.charAt(i);
				if (i > 0) ch1 = p_param.charAt(i - 1);
				if (ch0 == "\"")
					if (ch1 != "\\") is_string = !is_string;
				if (ch0 == " ") if (!is_string) ch0 = "";
				trimmed += ch0;
			}
			
			data.method = trimmed.split("(")[0];
			
			params = trimmed.slice(data.method.length + 1, trimmed.length - 1);
			len = params.length;
		
			is_string = false;
			ch1 = "";
			for (i = 0; i < len; i++)
			{
				ch0 = params.charAt(i);	
				if (i > 0) ch1 = p_param.charAt(i - 1);
				if (ch0 == "\"") if (ch1 != "\\") { is_string = !is_string; ch0 = ""; }
				
				if (is_string)
				{
					temp += ch0;
				}
				else
				if ((ch0 == ",")||(i>=(len-1)))
				{
					if (i >= (len - 1)) temp += ch0;
					list.push(temp);
					temp = "";
				}
				else
				{
					temp += ch0;
				}
				
			}
			data.argument = list;			
			return data;
		}
	}
	
}