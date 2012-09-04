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
	public class Extras extends Screen
	{
		
		protected var _onExtras:Signal = new Signal(Extras);
		protected var _sharedData:Object = {};
		private var _greyBox:Quad;
		
		public function Extras()
		{
			super();
			var _greyBox:Quad = new Quad(710, 480, Color.BLACK);
			_greyBox.alpha = 0.7;
			_greyBox.x = 65 + 60;
			_greyBox.y = 40 + 40;
			
			addChild(_greyBox);
			
			var _extrasHeading:TextField = new TextField(_greyBox.width, 50, AssetRegistry.Strings.EXTRAS, "kroeger 06_65", 50, Color.WHITE);
			_extrasHeading.x = (Starling.current.stage.stageWidth - _extrasHeading.width) / 2;
			_extrasHeading.y = _greyBox.y + 10;
			addChild(_extrasHeading);
			
			var video1:Button = new Button();
			video1.label = AssetRegistry.Strings.VIDEO1;
			video1.width = 240;
			video1.height = 80;
			video1.x = Starling.current.stage.stageWidth / 2 - video1.width - 50;
			video1.y = _extrasHeading.y + _extrasHeading.height + 50;
			
			video1.onRelease.add(function(btn:Button):void
				{
					dispatchEventWith(ManagedStage.SWITCHING, true, {stage: VideoPlayer, args: {videoURI: "Intro.mp4", stage: MainMenu}});
				});
			
			var video2:Button = new Button();
			video2.label = AssetRegistry.Strings.VIDEO2;
			video2.width = 240;
			video2.height = 80;
			video2.x = AssetRegistry.STAGE_WIDTH / 2 + 50;
			video2.y = video1.y;
			
			var video3:Button = new Button();
			video3.label = AssetRegistry.Strings.VIDEO3;
			video3.width = 240;
			video3.height = 80;
			
			var video4:Button = new Button();
			video4.label = AssetRegistry.Strings.VIDEO4;
			video4.width = 240;
			video4.height = 80;
			
			video3.y = video2.y + video2.height + 100;
			video4.y = video3.y;
			
			if (SaveGame.hasFinishedGame)
			{
				video3.x = video1.x;
				video4.x = video2.x;
				addChild(video3);
			}
			else
			{
				video4.x = (Starling.current.stage.stageWidth - video4.width) / 2;
			}
			addChild(video1);
			addChild(video2);
			addChild(video4);
			
			var extrasxButton:Image = new Image(AssetRegistry.MenuAtlasAlpha.getTexture("x"));
			
			//xButton.scaleX = xButton.scaleY = 1.5;
			extrasxButton.x = Starling.current.stage.stageWidth - extrasxButton.width - 10;
			
			extrasxButton.y = 90;
			var exit:Quad = new Quad(140, 250, 0xffffff);
			exit.alpha = 0;
			exit.x = Starling.current.stage.stageWidth - exit.width;
			exit.y = 80;
			var that:Extras = this;
			exit.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void
				{
					var touch:Touch = event.getTouch(exit, TouchPhase.ENDED);
					if (touch)
					{
						_onExtras.dispatch(that);
					}
				});
			addChild(extrasxButton);
			addChild(exit);
		
		}
		
		override protected function initialize():void
		{
		
			//addSwitchers();
			//addButtons();
			//addNormalCombos();
			//addInfo();
		}
		
		public function get onExtras():Signal
		{
			return _onExtras;
		}
	
	}

}