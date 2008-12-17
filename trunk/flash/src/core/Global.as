package core  
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Global 
	{
		public static var stage				:Stage;
		public static var width				:Number;
		public static var height			:Number;
		public static var parameters		:Object;
		public static var online			:Boolean;
		public static var debugMode			:Boolean;
		public static var gc				:Function = System.gc;		
		
		public static function get rootURL()			:String  { return parameters["root_url"] || "" };
		public static function set rootURL(v:String)	:void { parameters["root_url"] = v; };
		
		public static function get memoryBytes()	:Number { return System.totalMemory; }
		public static function get memoryKB()	 	:Number { return System.totalMemory / 1024; }
		public static function get memoryMB()	 	:Number { return System.totalMemory/1024*1024; }
		
		public static function get screenDPI()			:Number { return Capabilities.screenDPI; }
		public static function get resolutionWidth()	:Number { return Capabilities.screenResolutionX; }
		public static function get resolutionHeight()	:Number { return Capabilities.screenResolutionY; }
		
		public static function get fullscreen()				:Boolean { return stage.displayState == StageDisplayState.FULL_SCREEN; }
		public static function set fullscreen(v:Boolean)	:void
		{ 
			stage.displayState = v ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL; 
		}
		public static function get align()				:String { return stage.align; }
		public static function set align(v:String)		:void { stage.align 	= v; }
		public static function get scaleMode()			:String { return stage.scaleMode; }
		public static function set scaleMode(v:String)	:void { stage.scaleMode = v; }
		
		private static var debug_context				:Dictionary;
		
		public static function initialize(p_flash:MovieClip,p_align:String="TL",p_scale:String="noScale"):void
		{
			if (stage != null) return;
			trace("Global> Initialize");
			
			debug_context = new Dictionary();			
			debug_context["CTX_GLOBAL"] = "";
			debugMode = true;
			
			stage 		= p_flash.stage;
			align 		= p_align;
			scaleMode 	= p_scale;
			
			stage.addEventListener(Event.RESIZE, 		on_event);			
			stage.addEventListener(Event.ENTER_FRAME,	on_event);		
			
			parameters = p_flash.loaderInfo.parameters;			
			online = parameters["root_url"] != null;
			
			var ld:URLLoader = new URLLoader(new URLRequest(online ? "xml/core.xml" : "../xml/core.xml"));
			ld.addEventListener(Event.COMPLETE, on_core_xml);
		}
		public static function debug(p_name:String,p_msg:String,p_tabbing:String="",p_context:String="CTX_GLOBAL"):void
		{
			if (!debugMode) return;
			if (debug_context[p_context] == null) debug_context[p_context] = "";
			var l:String = debug_context[p_context];
			l += p_tabbing+p_name + ">" + p_msg + "\n";
			debug_context[p_context] = l;
			trace(p_tabbing+p_name + ">" + p_msg);
		}
		public static function log(p_context:String="CTX_GLOBAL"):String
		{
			return debug_context[p_context];
		}
		
		private static function resize():void
		{
			width  = stage.stageWidth;
			height = stage.stageHeight;	
		}
		
		private static function on_core_xml(p_ev:Event):void
		{
			var ld:URLLoader;
			switch(p_ev.type)
			{
				case Event.COMPLETE:
				{
					
					ld = URLLoader(p_ev.target);
					var x:XML = new XML(ld.data);
					rootURL 	= x.root_url[0] == null ? "" 		: x.root_url[0];
					align   	= x.align[0] 	== null ? "TL" 		: x.align[0];
					scaleMode   = x.scaleMode[0]== null ? "noScale" : x.scaleMode[0];					
					break;
				}
			}
		}
		
		private static function on_event(p_ev:Event):void
		{
			switch(p_ev.type)
			{
				case Event.RESIZE:
				{
					resize();		
					break;
				}
				case Event.FULLSCREEN:
				{
					resize();
					break;
				}
			}
		}
	}
	
}