package core 
{
	import core.Global;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	dynamic public class CoreMovieClip extends MovieClip
	{	
		protected var level:int;
		protected var _tabbing:String;
		protected var _name:String;
		
		public function CoreMovieClip(p_name:String="") 
		{
			_name = p_name;
			if (stage) initialize(); 
			else
			{				
				addEventListener(Event.ADDED_TO_STAGE, function(p_ev:Event = null):void { initialize(); } );
			}
		}
		public function initialize():void
		{
			Global.initialize(this);
			removeEventListener(Event.ADDED_TO_STAGE, 	initialize);						
			level = -2;
			_tabbing = "";
			var ref:DisplayObject=this;
			do
			{
				ref = ref.parent;
				level++;
				if(level>=1) _tabbing += "  ";
			}while (ref != null);			
		}
		
		public function debug(p_msg:String, p_ctx:String = "CTX_GLOBAL"):void
		{
			Global.debug(_name,"Initialize",_tabbing,p_ctx);
		}
		
	}
	
}