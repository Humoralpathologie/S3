package Menu
{
    import engine.ManagedStage;
    import org.josht.starling.foxhole.controls.Radio;
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
    
    public function MainMenu()
    {
      AssetRegistry.loadGraphics([AssetRegistry.MENU, AssetRegistry.SNAKE]);
            
      _bg = new Image(AssetRegistry.MenuAtlasOpaque.getTexture("loading"));
      addChild(_bg);    
      
      makeButtons();

      createSettingsNavigator();
    }
    
    private function makeButtons():void {
     
      _settingsButton = new Button();
      _settingsButton.label = AssetRegistry.Strings.SETTINGS;
      _settingsButton.width = 300;
      _settingsButton.height = 80;
      _settingsButton.x = (Starling.current.stage.stageWidth - _settingsButton.width) / 2;
      _settingsButton.y = 640 - _settingsButton.height - 50;
      _settingsButton.onRelease.add(function(button:Button) {
        showSettingsNavigator();
      });
      
      _arcadeButton = new Button();
      _arcadeButton.label = AssetRegistry.Strings.ARCADE;
      _arcadeButton.width = 300;
      _arcadeButton.height = 80;      
      _arcadeButton.x = _settingsButton.x;
      _arcadeButton.y = _settingsButton.y - 100;
      _arcadeButton.onRelease.add(function(button:Button):void {
        StageManager.switchStage(ComboMenu);
      });
      
      _levelSelectButton = new Button();
      _levelSelectButton.label = AssetRegistry.Strings.STORY;
      _levelSelectButton.width = 300;
      _levelSelectButton.height = 80;
      _levelSelectButton.x = _settingsButton.x;
      _levelSelectButton.y = _arcadeButton.y - 100;
      _levelSelectButton.onRelease.add(function(button:Button):void {
        StageManager.switchStage(LevelSelect);
      });
          
      addChild(_settingsButton);
      addChild(_arcadeButton);
      addChild(_levelSelectButton);
    }
    
    private function createSettingsNavigator():void {
      const MAINSETTINGSSCREEN:String = "MAIN";
      const BETASETTINGSSCREEN:String = "BETA";
      
      _settings = new ScreenNavigator();
      _transitions = new ScreenSlidingStackTransitionManager(_settings);
      _settings.addScreen(MAINSETTINGSSCREEN, new ScreenNavigatorItem(MainSettingsScreen, {
        onBetaSelect: BETASETTINGSSCREEN
      }));
      
      _settings.addScreen(BETASETTINGSSCREEN, new ScreenNavigatorItem(BetaSettingsScreen, {
        onMainSelect:MAINSETTINGSSCREEN
      }));
      
      _settings.defaultScreenID = MAINSETTINGSSCREEN;
      
    }
    
    private function showSettingsNavigator():void {
      _settings.showDefaultScreen();
      addChild(_settings);
      var exit:starling.display.Button = new starling.display.Button(AssetRegistry.MenuAtlasAlpha.getTexture("x"));
      exit.scaleX = exit.scaleY = 2;
      exit.x = Starling.current.stage.stageWidth - exit.width - 10;
      exit.y = 10;
      var that = this;
      exit.addEventListener(Event.TRIGGERED, function(event:Event):void {
        that.removeChild(_settings);
      });
      _settings.addChild(exit);
    }
        
    override public function dispose():void {
      super.dispose();
      _bg.dispose();
      _settings.dispose();
      _settingsButton.dispose();
      _arcadeButton.dispose();
      _levelSelectButton.dispose();
    }
  }

}
