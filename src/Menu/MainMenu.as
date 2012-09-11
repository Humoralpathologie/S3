package Menu
{
    import engine.ManagedStage;
    //import org.josht.starling.foxhole.controls.Radio;
    //import org.josht.starling.foxhole.core.ToggleGroup;
        
    import org.josht.starling.foxhole.controls.Screen;
    import org.josht.starling.foxhole.controls.ScreenNavigator;
    import org.josht.starling.foxhole.controls.ScreenNavigatorItem;

    //import org.josht.starling.foxhole.text.BitmapFontTextFormat;
    import org.josht.starling.foxhole.themes.IFoxholeTheme;
    import org.josht.starling.foxhole.transitions.ScreenSlidingStackTransitionManager;
    import org.josht.starling.foxhole.controls.ScreenNavigator;
    import org.josht.starling.foxhole.controls.ScreenNavigatorItem;
    //import starling.events.Event;
    //import flash.events.Event;
    //import flash.media.SoundChannel;
    //import starling.text.TextField;
    import Level.ArcadeState;
    import starling.display.Image;
    //import starling.display.Sprite;
    import engine.AssetRegistry;
    //import starling.events.TouchEvent;
    import starling.core.Starling;
    import starling.display.Quad;
    //import starling.events.TouchPhase;
    //import starling.events.Touch;
    //import com.gskinner.motion.GTween;
    import engine.StageManager;
    import org.josht.starling.foxhole.controls.Button;
    //import org.josht.starling.foxhole.themes.MinimalTheme;
    //import engine.SaveGame;
    //import org.josht.starling.foxhole.controls.TextInput;
    //import starling.utils.HAlign;
    //import starling.utils.VAlign;
    import Menu.SettingsScreens.MainSettingsScreen;
    //import starling.textures.TextureSmoothing;
    import engine.NotificationScroller;
    //import starling.utils.Color;
    import engine.SaveGame;

  
  /**
   * ...
   * @author
   */
  public class MainMenu extends ManagedStage
  {
    private var _bg:Image;
    private var _screenNavi:ScreenNavigator;
    private var _transitions:ScreenSlidingStackTransitionManager;
    
    private var _arcadeButton:Button;
    private var _settingsButton:Button;
    private var _levelSelectButton:Button;
	  private var _extrasButton:Button;
    private var _notificationScroller:NotificationScroller;
    
    private const _SETTINGS:String = "SETTINGS";
    private const _EXTRAS:String = "EXTRAS";
    private const _LEARDERBOARDS:String = "LEADERBOARDS";
    private const _BLANC:String = "BLANC";
    
    public function MainMenu()
    {
      SaveGame.isArcade = false;
      AssetRegistry.loadGraphics([AssetRegistry.MENU, AssetRegistry.SNAKE]);
            
      _bg = new Image(AssetRegistry.Alpha_1_Atlas.getTexture("loading"));
      addChild(_bg);
      
      _notificationScroller = new NotificationScroller();
      addChild(_notificationScroller);
      
      _screenNavi = new ScreenNavigator();
      _transitions = new ScreenSlidingStackTransitionManager(_screenNavi);
      _screenNavi.addScreen(_SETTINGS, new ScreenNavigatorItem(new MainSettingsScreen(), {
        onSetting:_BLANC
      }));
      var lid:String;
			if (SaveGame.difficulty == 1)
			{
				lid = "50421a39563d8a53c20021bb";
			}
			else
			{
				lid = "50421a3f563d8a632f002091";
			}
      var _levelLeaderboardScreen:LevelLeaderboard = new LevelLeaderboard(lid);
      _levelLeaderboardScreen.dispatchEventWith(LevelLeaderboard.REFRESH_LEADERBOARD);
      _screenNavi.addScreen(_LEARDERBOARDS, new ScreenNavigatorItem(_levelLeaderboardScreen, {
        toExtras:_EXTRAS
      }));
       _screenNavi.addScreen(_EXTRAS, new ScreenNavigatorItem(new Extras(), {
        onExtras:_BLANC,
        toLB:_LEARDERBOARDS
      }));
      
    
       _screenNavi.addScreen(_BLANC, new ScreenNavigatorItem(new BlancScreen(), {
        onBlancScreen:_EXTRAS
      }));
      _screenNavi.defaultScreenID = _BLANC;
      addChild(_screenNavi);
      makeButtons();
      _screenNavi.showScreen(_BLANC);
   
    }
    
    private function makeButtons():void {
      var that:MainMenu = this;
      _settingsButton = new Button();
      _settingsButton.label = AssetRegistry.Strings.SETTINGS;
      _settingsButton.width = 240;
      _settingsButton.height = 80;
      _settingsButton.x = Starling.current.stage.stageWidth - _settingsButton.width;
      _settingsButton.y = Starling.current.stage.stageHeight - _settingsButton.height;
      _settingsButton.onRelease.add(function(button:Button):void {
        _screenNavi.showScreen(_SETTINGS);
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
        _screenNavi.showScreen(_EXTRAS);     
    });
	  
    addChild(_settingsButton);
    addChild(_arcadeButton);
    addChild(_levelSelectButton);
	  addChild(_extrasButton);
    }

       
    override public function dispose():void {
      super.dispose();
      _bg.dispose();
      _settingsButton.dispose();
      _arcadeButton.dispose();
      _levelSelectButton.dispose();
	    _extrasButton.dispose();
      _notificationScroller.dispose();
    }
  }

}
