package 
{
	
	import com.aquiris.unity.UnityInterface;
	import com.aquiris.unity.UnityProfiler;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	public class Application extends MovieClip 
	{
		
		private var profiler:UnityProfiler;
		
		public function Application():void 
		{	
			initialize();
		}
		public function initialize():void 
		{	
			profiler = new UnityProfiler(5, 5);
			addChild(profiler);			
			UnityInterface.initialize();
		}	
		
	
		
	}
	
}