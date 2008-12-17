package 
{
	
	import com.aquiris.unity.mcUnityProfiler;
	import com.aquiris.unity.UnityInterface;
	import com.aquiris.unity.UnityProfiler;
	import core.Global;
	import core.CoreMovieClip;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;
	
	/**
	 * Class that will contain all application main instances.
	 */
	public class Preloader extends CoreMovieClip 
	{
		
		/**
		 * Application constructor.
		 */
		public function Preloader():void 
		{	
			super("Preloader");			
		}
		/**
		 * After the stage being created, initializes all assets
		 * @param	e Event called upon initialization.
		 */
		override public function initialize():void 
		{	
			super.initialize();
			
			//*******************
			
			debug("Initialize");
			
			//Start Here
			var ld:Loader = new Loader();
			var req:URLRequest = new URLRequest(Global.online ? "swf/application.swf" : "application.swf");			
			ld.load(req);						
			addChild(ld);			
			//*******************			
			
		}	
		
	
		
	}
	
}