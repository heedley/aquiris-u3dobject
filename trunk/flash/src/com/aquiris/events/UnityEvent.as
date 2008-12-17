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
package com.aquiris.events
{
	import flash.events.Event;
		
	/**
	 * Implements the UnityInterface event data container.
	 */
	public class UnityEvent extends Event 
	{
		/**
		 * Called when the plugin is successfully detected.
		 */
		public static const UNITY_READY		:String = "unity_ready";
		/**
		 * Called when a flash method is called from within the unity application.
		 */
		public static const UNITY_CALL		:String = "unity_call";		
		/**
		 * Called every time a timout occurs when trying to detect the unity webplayer.
		 */
		public static const PLUGIN_TIMEOUT	:String = "plugin_timeout";
		/**
		 * Called when the plugin is not detected in the user's browser.
		 */
		public static const PLUGIN_ERROR	:String = "plugin_error";			
		/**
		 * Called when the unity application has progressed in the loading.
		 */
		public static const PROGRESS		:String = "progress";	
		/**
		 * Called when the unity application finished loading.
		 */
		public static const COMPLETE		:String = "complete";	
		
		/**
		 * Called when any kind of error occurs.
		 */
		public static const ERROR			:String = "error";
		
		
		/**
		 * Error Message passed when the ExternalInterface is not available.
		 */
		public static const ERROR_JS_NOT_AVAILABLE	:String = "error_js_not_available";
			
		/**
		 * Parameter passed by the event being called. If the event is an error the parameter is the error message.
		 */
		public var parameter:*;		
		
		public function UnityEvent(p_type:String,p_parameter:*=null,bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(p_type, bubbles, cancelable);
			parameter = p_parameter;			
		} 
		/**
		 * Makes a exact copy of the event object.
		 * @return Event The copy of the event.
		 */
		public override function clone():Event 
		{ 
			return new UnityEvent(type, parameter, bubbles, cancelable);
		} 
		
	}
	
}