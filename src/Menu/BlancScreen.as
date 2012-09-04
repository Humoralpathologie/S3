package Menu
{
	import starling.display.Image;
	import org.josht.starling.foxhole.controls.Screen;
	//import org.josht.text.StageTextField;
	import org.osflash.signals.Signal;
	import org.josht.starling.foxhole.controls.Button;
	import engine.AssetRegistry;
	import org.osflash.signals.ISignal;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.utils.Color;
	import starling.core.Starling;
	import engine.ManagedStage;
	import engine.SaveGame;
	import starling.text.TextField;
	import Menu.MainMenu;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
	import engine.VideoPlayer;
	
	/**
	 *
	 * @author Roger Braun, Tim Schierbaum, Jiayi Zheng.
	 */
	public class BlancScreen extends Screen
	{
		
		protected var _onBlancScreen:Signal = new Signal(BlancScreen);
		protected var _sharedData:Object = {};
		
		public function BlancScreen()
		{
			super();
		
		}
		
		override protected function initialize():void
		{
		
			//addSwitchers();
			//addButtons();
			//addNormalCombos();
			//addInfo();
		}
		
		public function get onBlancScreen():Signal
		{
			return _onBlancScreen;
		}
	
	}

}