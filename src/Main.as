package 
{
  import engine.AssetRegistry;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
  import Level.Arcade;
  import starling.core.Starling;
  import fr.kouma.starling.utils.Stats;
	
	/**
	 * ...
	 * @author 
	 */
  [SWF(width="960", height="640", frameRate="60", backgroundColor="#ffffff")] 
	public class Main extends Sprite 
	{
		
    private var starling:Starling;
    private var assets:AssetRegistry;
    
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
            
      starling = new Starling(Arcade, stage);
      starling.start();
		}
		
		private function deactivate(e:Event):void 
		{
			// auto-close
			NativeApplication.nativeApplication.exit();
		}
		
	}
	
}