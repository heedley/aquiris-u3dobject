package com.aquiris.unity
{
	import com.aquiris.events.UnityEvent;
	import com.aquiris.unity.mcUnityProfiler;
	import fl.controls.ScrollPolicy;
	import fl.controls.TextArea;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class UnityProfiler extends mcUnityProfiler
	{
		
		public function UnityProfiler(p_x:Number=0,p_y:Number=0) 
		{
			x = p_x;
			y = p_y;
			UnityInterface.addEventListener(on_unity);
			addEventListener(Event.ADDED_TO_STAGE, on_added);
		}
		public function set console(v:String):void
		{			
			$console.text += v + "\n";
			$console.verticalScrollPosition = $console.maxVerticalScrollPosition;
		}
		public function show():void
		{
			visible = true;
		}
		public function hide():void
		{
			visible = false;
		}
		
		private function on_added(p_ev:Event):void
		{
			initialize();
		}
		
		private function initialize(p_ev:TimerEvent=null):void
		{
			$console.text = "Unity Profiler . Aquiris . v1.0 . Created by eduardo.costa\n";
			
			$input.text = "function_name(parameter1,parameter2,...)";
			
			var md:Function =  function(p_ev:MouseEvent):void
			{
				$input.text = "";
				$input.removeEventListener(MouseEvent.MOUSE_DOWN, md);
			};
			$input.addEventListener(MouseEvent.MOUSE_DOWN, md);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, on_enter);
			
			$target.text = UnityInterface.JS_DEFAULT_DIV_NAME;
			$object.text = UnityInterface.JS_DEFAULT_UNITY_OBJECT;
			$filename.text = "unity/game.unity3d";
			
			$visible.addEventListener(MouseEvent.CLICK, on_visible_check);
			
			$embbed.addEventListener(MouseEvent.CLICK, on_embbed);
			
			$send.addEventListener(MouseEvent.CLICK, on_send_event);
			
			$clear.addEventListener(MouseEvent.CLICK, function(p_ev:MouseEvent):void
			{
				$console.text = "Unity Profiler . Aquiris . v1.0 . Created by eduardo.costa\n";
			});
			
			$logo.buttonMode = true;
			$logo.addEventListener(MouseEvent.CLICK, function(p_ev:MouseEvent):void
			{
				var req:URLRequest = new URLRequest("http://www.aquiris.com.br");
				navigateToURL(req);				
			});
			
			
		}
		
		private function on_enter(p_ev:KeyboardEvent):void
		{
			if (p_ev.charCode == 13)
			{
				var cmd:String = $input.text;
				if (cmd == "") return;
				$input.text = "";
				cmd = cmd.slice(0, cmd.length - 1);
				console = "Flash> Called Unity Method [ " + cmd + " ] @ " + $target.text + " :: " + $object.text;
				UnityInterface.call(cmd, $object.text, $target.text);
			}
			
			
		}
		private function on_send_event(p_ev:MouseEvent):void
		{
			if ($event.text == "") return;
			console = "Flash> Sending UnityEvent [" + $event.text + "] with parameter [" + $parameter.text + "] @ " + $target.text;
			UnityInterface.dispatchUnityEvent($event.text, $parameter.text, $target.text);
		}
		private function on_embbed(p_ev:MouseEvent):void
		{
			console = "Flash> Embbeding [" + $filename.text + "] @ " + $target.text + " ("+$width.value + "," + $height.value + ")"; 
			UnityInterface.embed($width.value, $height.value, $filename.text, $target.text);
		}
		
		
		private function on_visible_check(p_ev:MouseEvent):void
		{
			var v:Boolean = $visible.selected;
			if (v) 
					UnityInterface.showUnity($target.text);
			else 
					UnityInterface.hideUnity($target.text);
					
			console = "Flash> Setting Unity Visibility to [" + v + "]";			
		}
		
		private function on_unity(p_ev:UnityEvent):void
		{
			switch(p_ev.type)
			{
				case UnityEvent.UNITY_READY:
				{
					console = "Flash> Plugin Detected!";
					$embbed.alpha = 1;
					$embbed.enabled = true;
					break;
				}
				case UnityEvent.PLUGIN_TIMEOUT:
				{
					console = "Flash> Detect Timeout!";
					break;
				}	
				case UnityEvent.PLUGIN_ERROR:
				{
					console = "Flash> Plugin Not Found!";
					break;
				}	
				case UnityEvent.ERROR:
				{
					
					console = "Flash> Error: " + p_ev.parameter;
					
					if (p_ev.parameter == UnityEvent.ERROR_JS_NOT_AVAILABLE)
					{
						$embbed.alpha = 0.5;
						$embbed.enabled = false;
					}
					break;
				}
				case UnityEvent.COMPLETE:
				{
					console = "Unity> Load Complete!";
					break;
				}
				case UnityEvent.PROGRESS:
				{
					console = "Unity> Load Progress: " + Number(p_ev.parameter);
					break;
				}
				case UnityEvent.UNITY_CALL:
				{
					console = "Unity> " + p_ev.parameter.method + " [" + p_ev.parameter.argument + "]";
					break;
				}


				
			}
		}
	}
	
}