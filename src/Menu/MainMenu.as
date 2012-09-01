package Menu
{
    import engine.ManagedStage;
    import org.josht.starling.foxhole.controls.Radio;
    import org.josht.starling.foxhole.controls.Screen;
    import org.josht.starling.foxhole.controls.ScreenNavigator;
    import org.josht.starling.foxhole.controls.ScreenNavigatorItem;
    import org.josht.starling.foxhole.core.ToggleGroup;
    import org.josht.starling.foxhole.text.BitmapFontTextFormat;
    import org.josht.starling.foxhole.themes.IFoxholeTheme;
    import org.josht.starling.foxhole.transitions.ScreenSlidingStackTransitionManager;
    import starling.events.Event;
    //import flash.events.Event;
    import flash.media.SoundChannel;
    import starling.text.TextField;
    import Level.ArcadeState;
    import starling.display.Image;
    import starling.display.Sprite;
    import engine.AssetRegistry;
    import starling.events.TouchEvent;
    import starling.core.Starling;
    import starling.display.Quad;
    import starling.events.TouchPhase;
    import starling.events.Touch;
    import com.gskinner.motion.GTween;
    import engine.StageManager;
    import org.josht.starling.foxhole.controls.Button;
    import org.josht.starling.foxhole.themes.MinimalTheme;
    import engine.SaveGame;
    import org.josht.starling.foxhole.controls.TextInput;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    import Menu.SettingsScreens.*;
    import starling.textures.TextureSmoothing;
    import engine.NotificationScroller;
    import starling.utils.Color;
    import engine.VideoPlayer;
  
  /**
   * ...
   * @author
   */
  public class MainMenu extends ManagedStage
  {
    private var _bg:Image;
    private var _settings:ScreenNavigator;
    private var _transitions:ScreenSlidingStackTransitionManager;
    private var _arcadeButton:Button;
    private var _settingsButton:Button;
    private var _levelSelectButton:Button;
	  private var _extrasButton:Button;
    private var _notificationScroller:NotificationScroller;
    private var isExtrasScreen:Boolean = false;
    
    public function MainMenu()
    {
      AssetRegistry.loadGraphics([AssetRegistry.MENU, AssetRegistry.SNAKE]);
            
      _bg = new Image(AssetRegistry.MenuAtlasOpaque.getTexture("loading"));
      addChild(_bg);
      
      _notificationScroller = new NotificationScroller();
      addChild(_notificationScroller);
      
      makeButtons();

      createSettingsNavigator();
	  
	  SaveGame.isSettingsScreen = false;
   
    }
    
    private function makeButtons():void {
     
      _settingsButton = new Button();
      _settingsButton.label = AssetRegistry.Strings.SETTINGS;
      _settingsButton.width = 240;
      _settingsButton.height = 80;
      _settingsButton.x = Starling.current.stage.stageWidth - _settingsButton.width;
      _settingsButton.y = Starling.current.stage.stageHeight - _settingsButton.height;
      _settingsButton.onRelease.add(function(button:Button):void {
        if (SaveGame.isSettingsScreen != true) {
		  trace("Save.isSettingsScreen != true")
		  showSettingsNavigator();
        } 
	  });
      
      _arcadeButton = new Button();
      _arcadeButton.label = AssetRegistry.Strings.ARCADE;
      _arcadeButton.width = 240;
      _arcadeButton.height = 80;      
      _arcadeButton.x = (Starling.current.stage.stageWidth - _settingsButton.width) / 3;
      _arcadeButton.y = Starling.current.stage.stageHeight - _arcadeButton.height;
      _arcadeButton.onRelease.add(function(button:Button):void {
        dispatchEventWith(SWITCHING, true, { stage: ComboMenu } );
      });
      
      _levelSelectButton = new Button();
      _levelSelectButton.label = AssetRegistry.Strings.STORY;
      _levelSelectButton.width = 240;
      _levelSelectButton.height = 80;
      _levelSelectButton.x = 0;
      _levelSelectButton.y = Starling.current.stage.stageHeight - _levelSelectButton.height;
      _levelSelectButton.onRelease.add(function(button:Button):void {
        dispatchEventWith(SWITCHING, true, { stage: LevelSelect } );       
      });
	  
	  _extrasButton = new Button();
	  _extrasButton.label = AssetRegistry.Strings.EXTRAS;
	  _extrasButton.width = 240;
	  _extrasButton.height = 80;
	  _extrasButton.x = Starling.current.stage.stageWidth / 2;
	  _extrasButton.y = Starling.current.stage.stageHeight - _extrasButton.height;
    _extrasButton.onRelease.add(function(button:Button):void {
      if(!isExtrasScreen){ 
        showExtrasScreen(); 
        }      
      });
	  
      addChild(_settingsButton);
      addChild(_arcadeButton);
      addChild(_levelSelectButton);
	  addChild(_extrasButton);
    }
    
    private function createSettingsNavigator():void {
      const MAINSETTINGSSCREEN:String = "MAIN";
      const BETASETTINGSSCREEN:String = "BETA";
      
      _settings = new ScreenNavigator();
      var settingsscreeen:Screen = new MainSettingsScreen();
      _transitions = new ScreenSlidingStackTransitionManager(_settings);
      _settings.addScreen(MAINSETTINGSSCREEN, new ScreenNavigatorItem(settingsscreeen, {
        onBetaSelect: BETASETTINGSSCREEN
      }));
      
      _settings.addScreen(BETASETTINGSSCREEN, new ScreenNavigatorItem(BetaSettingsScreen, {
        onMainSelect:MAINSETTINGSSCREEN
      }));
      
      _settings.defaultScreenID = MAINSETTINGSSCREEN;
      
    }
    
    private function showSettingsNavigator():void {
      // Leaky.
      _settings.dispose();
	  
      createSettingsNavigator(); 
     
      _settings.showDefaultScreen();
      addChild(_settings);
      var xButton:Image = new Image(AssetRegistry.MenuAtlasAlpha.getTexture("x"));

      //xButton.scaleX = xButton.scaleY = 1.5;
      xButton.x = Starling.current.stage.stageWidth - xButton.width - 10;

      xButton.y = 90;
      var exit:Quad = new Quad(140, 250, 0xffffff);
      exit.alpha = 0;
      exit.x = Starling.current.stage.stageWidth - exit.width;
      exit.y = 80;
      var that:MainMenu = this;
      exit.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void {
         var touch:Touch = event.getTouch(exit, TouchPhase.ENDED);
          if (touch)
          {
			SaveGame.isSettingsScreen = false;
			trace("SaveGame.isSettingsScreen = false");
            that.removeChild(_settings);
          }
      });
      _settings.addChild(xButton);
      _settings.addChild(exit); 
	  
    }
    
    private function showExtrasScreen():void {
      isExtrasScreen = true;
      
      var extras:Sprite = new Sprite;
      addChild(extras);
      
      var _greyBox:Quad = new Quad(710, 480, Color.BLACK);
      _greyBox.alpha = 0.7;
      _greyBox.x = 65 + 60;
      _greyBox.y = 40 + 40;
      
      extras.addChild(_greyBox);
      
      var _extrasHeading:TextField = new TextField(_greyBox.width, 50, AssetRegistry.Strings.EXTRAS, "kroeger 06_65", 50, Color.WHITE);
      _extrasHeading.x = (Starling.current.stage.stageWidth - _extrasHeading.width) / 2;
      _extrasHeading.y = _greyBox.y + 10;
      extras.addChild(_extrasHeading);
      
      var video1:Button = new Button();
      video1.label = AssetRegistry.Strings.VIDEO1;
	    video1.width = 240;
	    video1.height = 80;
	    video1.x = Starling.current.stage.stageWidth / 2 - video1.width - 50;
	    video1.y = _extrasHeading.y + _extrasHeading.height + 50;
      
      video1.onRelease.add(function(btn:Button) {
        dispatchEventWith(SWITCHING, true, { stage: VideoPlayer, args: { videoURI: "Outro_1.mp4" }} );
      });
      
      var video2:Button = new Button();
      video2.label = AssetRegistry.Strings.VIDEO2;
	    video2.width = 240;
	    video2.height = 80;
	    video2.x = Starling.current.stage.stageWidth / 2 + 50;
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
      
      if (SaveGame.hasFinishedGame) {
        video3.x = video1.x;
        video4.x = video2.x;
        extras.addChild(video3);
      } else {
        video4.x = (Starling.current.stage.stageWidth - video4.width) / 2;
      }
      
      extras.addChild(video1);
      extras.addChild(video2);
      extras.addChild(video4);
      
      var xButton:Image = new Image(AssetRegistry.MenuAtlasAlpha.getTexture("x"));

      //xButton.scaleX = xButton.scaleY = 1.5;
      xButton.x = Starling.current.stage.stageWidth - xButton.width - 10;

      xButton.y = 90;
      var exit:Quad = new Quad(140, 250, 0xffffff);
      exit.alpha = 0;
      exit.x = Starling.current.stage.stageWidth - exit.width;
      exit.y = 80;
      var that:MainMenu = this;
      exit.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void {
         var touch:Touch = event.getTouch(exit, TouchPhase.ENDED);
          if (touch)
          {
            that.removeChild(extras);
            that.removeChild(xButton);
            that.removeChild(exit);
            isExtrasScreen = false;
          }
      });
      addChild(xButton);
      addChild(exit); 
    }
        
    override public function dispose():void {
      super.dispose();
      _bg.dispose();
      _settings.dispose();
      _settingsButton.dispose();
      _arcadeButton.dispose();
      _levelSelectButton.dispose();
	    _extrasButton.dispose();
      _notificationScroller.dispose();
    }
  }

}
