package 
{
	
	import com.aquiris.unity.mcUnityProfiler;
	import com.aquiris.unity.UnityInterface;
	import com.aquiris.unity.UnityProfiler;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;
	
	public class Preloader extends MovieClip 
	{		
		public function Preloader():void 
		{	
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		public function initialize(p_ev:Event=null):void 
		{	
			var ld:Loader = new Loader();
			var req:URLRequest = new URLRequest(loaderInfo.parameters["root_url"]!=null ? "swf/application.swf" : "application.swf");
			ld.load(req);						
			addChild(ld);
		}	
		
	
		
	}
	
}