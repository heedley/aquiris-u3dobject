package 
{
	
	import com.aquiris.unity.UnityInterface;
	import com.aquiris.unity.UnityProfiler;
	import core.Global;
	import core.CoreMovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	/**
	 * Class that will contain all application main instances.
	 */
	public class Application extends CoreMovieClip 
	{
		
		private var profiler:UnityProfiler;
		/**
		 * Application constructor.
		 */
		public function Application():void 
		{	
			super("Application");
		}
		/**
		 * After the stage being created, initializes all assets
		 * @param	e Event called upon initialization.
		 */
		override public function initialize():void 
		{	
			super.initialize();
			debug("Initialize");
			//*******************		
			profiler = new UnityProfiler(5, 5);
			addChild(profiler);
			//Start Here
			//*******************			
			
			
			UnityInterface.initialize();
			
			
		}	
		
	
		
	}
	
}