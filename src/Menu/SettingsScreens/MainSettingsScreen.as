package Menu.SettingsScreens
{
	import org.josht.starling.foxhole.controls.TabBar;
	import org.josht.starling.foxhole.controls.ToggleSwitch;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import org.josht.starling.display.Image;
	import org.josht.starling.foxhole.controls.Screen;
	import org.josht.starling.foxhole.controls.ScreenNavigator;
	import org.josht.starling.foxhole.controls.ScreenNavigatorItem;
	import org.josht.starling.foxhole.transitions.ScreenSlidingStackTransitionManager;
	//import org.josht.starling.foxhole.controls.Slider;
	import org.josht.starling.foxhole.controls.TextInput;
	import org.josht.starling.foxhole.controls.Scroller;
	import org.josht.starling.foxhole.controls.ScrollBar;
	import org.josht.text.StageTextField;
	import org.osflash.signals.Signal;
	import starling.display.Button;
	import starling.display.Sprite;
	import engine.AssetRegistry;
	import org.osflash.signals.ISignal;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.utils.Color;
	import starling.core.Starling;
	import engine.ManagedStage;
	import Level.ArcadeState;
	import engine.SaveGame;
	import org.josht.starling.foxhole.controls.Radio;
	import org.josht.starling.foxhole.core.ToggleGroup;
	import starling.text.TextField;
	import Languages.*;
	import Menu.MainMenu;
	import starling.utils.HAlign;
	import engine.Utils;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.events.Touch;
  import org.josht.starling.foxhole.data.ListCollection;
	
	/**
	 *
	 * @author Roger Braun, Tim Schierbaum, Jiayi Zheng.
	 */
	public class MainSettingsScreen extends Screen
	{
		private var _screenNavi:ScreenNavigator;
		private var _transitions:ScreenSlidingStackTransitionManager;
		
		protected var _onSetting:Signal = new Signal(MainSettingsScreen);
		protected var _sharedData:Object = {};
		private var _greyBox:Quad;
		private var _heading:TextField;
		
		/*
			 private var _controlsHeading:TextField;
			 private var _nameHeading:TextField;
			 private var _langHeading:TextField;
			 private var _nameText:TextField;
			 private var _diffHeading:TextField;
			 private var _scroller:Scroller;
			 private var _scrollable:Sprite;
			 private var _nameTextInput:TextInput;
		 */
		private var _controls:Sprite;
		private var _lang:Sprite;
		private var _diff:Sprite;
		private var _name:Sprite;
    private var _previousSprite:Sprite;
		private var _tabBar:TabBar;
		
		public function MainSettingsScreen()
		{
			super();
			
			_greyBox = new Quad(710, 480, Color.BLACK);
			_greyBox.alpha = 0.7;
			_greyBox.x = 65 + 60;
			_greyBox.y = 40 + 40;
			
			addChild(_greyBox);
			
			//add x-button
			var xButton:Image = new Image(AssetRegistry.MenuAtlasAlpha.getTexture("x"));
			xButton.x = Starling.current.stage.stageWidth - xButton.width - 10;
			xButton.y = 90;
			var exit:Quad = new Quad(140, 250, 0xffffff);
			exit.alpha = 0;
			exit.x = Starling.current.stage.stageWidth - exit.width;
			exit.y = 80;
			var that:MainSettingsScreen = this;
			exit.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void
				{
					var touch:Touch = event.getTouch(exit, TouchPhase.ENDED);
					if (touch)
					{
						_onSetting.dispatch(that);
					}
				});
			addChild(xButton);
			addChild(exit);
			
			_heading = new TextField(_greyBox.width, 50, AssetRegistry.Strings.MAINSETTINGS, "kroeger 06_65", 50, Color.WHITE);
			
			_heading.x = _greyBox.x + (_greyBox.width - _heading.width) / 2;
			_heading.y = _greyBox.y;
			
			addTabBar();
			
			/*
				 _scroller = new Scroller();
				 _scroller.x = _greyBox.x - 10;
				 _scroller.y = _heading.y + _heading.height + 20;
				 _scroller.setSize(_greyBox.width + 10, _greyBox.height - (_heading.height + 20));
				 _scroller.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
			
				 addChild(_scroller);
			 */
			
			addChild(_heading);
			
			addControlSwitches();
			addDifficultySwitches();
			addLanguageSwitches();
			addUserName();
      _previousSprite = new Sprite;
      addChild(_previousSprite);
			//_scroller.viewPort = _scrollable;
		/*
			 // Padding
			 var padding:Quad = new Quad(1, 100, 0xffffff);
			 padding.alpha = 0;
			 padding.y = _nameTextInput.y + _nameTextInput.height;
		 _scrollable.addChild(padding);*/
		
		}
		
		override protected function initialize():void
		{
		
			//addSwitchers();
			//addButtons();
			//addNormalCombos();
			//addInfo();
		}
		
		private function addTabBar():void
		{
			_tabBar = new TabBar();
			_tabBar.dataProvider = new ListCollection([{label: AssetRegistry.Strings.DIFFICULTY}, {label: AssetRegistry.Strings.CONTROLTYPE}, {label: AssetRegistry.Strings.LANGUAGE}, {label: AssetRegistry.Strings.USERNAME}]);
			_tabBar.onChange.add(function(bar:TabBar)
				{
					switch (bar.selectedIndex)
					{
						case 0: 
              removeChild(_previousSprite);
							addChild(_diff);
              _previousSprite = _diff;
							break;
						case 1: 
						  removeChild(_previousSprite);
							addChild(_controls);
              _previousSprite = _controls;
							break;
						case 2: 
							removeChild(_previousSprite);
							addChild(_lang);
              _previousSprite = _lang;
							break;
              case 3: 
							removeChild(_previousSprite);
							addChild(_name);
              _previousSprite = _name;
							break;
					}
					
				});
			_tabBar.width = _greyBox.width;
			_tabBar.x = _greyBox.x;
			_tabBar.y = _greyBox.y + 80;
			addChild(_tabBar);
		}
		
		private function addUserName():void
		{
      _name = new Sprite;
      var _nameHeading:TextField;
      var _nameTextInput:TextInput;
      
			_nameHeading = new TextField(_greyBox.width, 50, "User Name: " + SaveGame.userName, "kroeger 06_65", 40, Color.WHITE);
			_nameHeading.x = (_greyBox.width - _nameHeading.width) / 2;
			_nameHeading.y = _tabBar.y + 200;
			_nameHeading.hAlign = HAlign.CENTER;
			
			_nameTextInput = new TextInput();
			_nameTextInput.width = (_greyBox.width - 100);
			_nameTextInput.x = 50;
			_nameTextInput.y = _nameHeading.y + _nameHeading.height + 20;
			_nameTextInput.text = SaveGame.userName;
			
			_nameTextInput.onEnter.add(function(input:TextInput)
				{
					trace("Enter");
					SaveGame.userName = _nameTextInput.text;
					_nameHeading.text = "User Name: " + SaveGame.userName;
					Utils.createOrEditPlayer(SaveGame.guid, SaveGame.userName);
				});
			_nameTextInput;
			
			_name.addChild(_nameHeading);
			_name.addChild(_nameTextInput);
		
		}
		
		private function addControlSwitches():void
		{
      _controls = new Sprite;
			var _controlsHeading:TextField;

			_controlsHeading = new TextField(_greyBox.width / 2, 50, AssetRegistry.Strings.CONTROLTYPE, "kroeger 06_65", 40, Color.WHITE);
			_controlsHeading.x = (_greyBox.width - _controlsHeading.width) / 2;
			_controlsHeading.y = _tabBar.y + 200;
			_controls.addChild(_controlsHeading);
			
			var controlGroup:ToggleGroup = new ToggleGroup;
			var boyStyle:Radio = new Radio();
			boyStyle.label = AssetRegistry.Strings.SNAKEVIEW;
			boyStyle.toggleGroup = controlGroup;
			boyStyle.onPress.add(function(radio:Radio):void
				{
					SaveGame.controlType = 1;
				});
			
			var fourway:Radio = new Radio;
			fourway.label = AssetRegistry.Strings.FOURWAY;
			fourway.toggleGroup = controlGroup;
			fourway.onPress.add(function(radio:Radio):void
				{
					SaveGame.controlType = 2;
				});
			
			controlGroup.selectedIndex = SaveGame.controlType - 1;
			
			boyStyle.x = (_greyBox.width / 2) - 230;
			fourway.x = (_greyBox.width / 2) + 80;
			
			boyStyle.y = _controlsHeading.y + _controlsHeading.height;
			fourway.y = boyStyle.y;
			
			_controls.addChild(boyStyle);
			_controls.addChild(fourway);
		}
		
		private function addDifficultySwitches():void
		{
      _diff = new Sprite;
			var _diffHeading:TextField;
      
			_diffHeading = new TextField(_greyBox.width / 2, 50, AssetRegistry.Strings.DIFFICULTY, "kroeger 06_65", 40, Color.WHITE);
			_diffHeading.x = (_greyBox.width - _diffHeading.width) / 2;
			_diffHeading.y = _tabBar.y + 200;
			_diff.addChild(_diffHeading);
			
			var diffGroup:ToggleGroup = new ToggleGroup;
			var casual:Radio = new Radio();
			casual.label = AssetRegistry.Strings.CASUAL;
			casual.toggleGroup = diffGroup;
			casual.onPress.add(function(radio:Radio):void
				{
					SaveGame.difficulty = 1;
				});
			
			var competetive:Radio = new Radio;
			competetive.label = AssetRegistry.Strings.COMPETETIVE;
			competetive.toggleGroup = diffGroup;
			competetive.onPress.add(function(radio:Radio):void
				{
					SaveGame.difficulty = 2;
				});
			
			diffGroup.selectedIndex = SaveGame.difficulty - 1;
			
			casual.x = (_greyBox.width / 2) - 230;
			competetive.x = (_greyBox.width / 2) + 80;
			
			casual.y = _diffHeading.y + _diffHeading.height;
			competetive.y = casual.y;
			
			_diff.addChild(casual);
			_diff.addChild(competetive);
		}
		
		private function addLanguageSwitches():void
		{
      _lang = new Sprite;
			var _langHeading:TextField;
      
			_langHeading = new TextField(_greyBox.width / 2, 50, AssetRegistry.Strings.LANGUAGE, "kroeger 06_65", 40, Color.WHITE);
			_langHeading.x = (_greyBox.width - _langHeading.width) / 2;
			_langHeading.y = _tabBar.y + 200;
			_lang.addChild(_langHeading);
			
			var langGroup:ToggleGroup = new ToggleGroup;
			var eng:Radio = new Radio();
			eng.label = "English";
			eng.toggleGroup = langGroup;
			eng.onPress.add(function(radio:Radio):void
				{
					SaveGame.language = 1;
					AssetRegistry.Strings = English;
					dispatchEventWith(ManagedStage.SWITCHING, true, {stage: MainMenu});
				});
			
			var ger:Radio = new Radio;
			ger.label = "Deutsch";
			ger.toggleGroup = langGroup;
			ger.onPress.add(function(radio:Radio):void
				{
					SaveGame.language = 2;
					AssetRegistry.Strings = Deutsch;
					dispatchEventWith(ManagedStage.SWITCHING, true, {stage: MainMenu});
				});
			
			langGroup.selectedIndex = SaveGame.language - 1;
			
			eng.x = (_greyBox.width / 2) - 230;
			ger.x = (_greyBox.width / 2) + 80;
			
			eng.y = _langHeading.y + _langHeading.height;
			ger.y = eng.y;
			
			_lang.addChild(eng);
			_lang.addChild(ger);
		}
		
		public function get onSetting():Signal
		{
			return _onSetting;
		}
	
	}

}