package Menu
{
    import engine.ManagedStage;
    import org.josht.starling.foxhole.controls.Radio;
    import org.josht.starling.foxhole.core.ToggleGroup;
    import org.josht.starling.foxhole.text.BitmapFontTextFormat;
    import org.josht.starling.foxhole.themes.IFoxholeTheme;
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
    
  
  /**
   * ...
   * @author
   */
  public class MainMenu extends ManagedStage
  {
    private var _bg:Image;
    private var _possibleSwipe:Boolean = false;
    private var _swipeY:int = 0;
    private var _swipeMenu:Sprite;
    private var _swipeMessage:Image;    
    private var _theme:IFoxholeTheme;
    
    public function MainMenu()
    {
      AssetRegistry.loadMenuGraphics();
      
      _theme = new MinimalTheme(Starling.current.stage, false);
      this.addEventListener(TouchEvent.TOUCH, onTouch);
      
      _bg = new Image(AssetRegistry.MenuAtlas.getTexture("loading"));
      addChild(_bg);
      
      _swipeMenu = new Sprite();
      
      var menuBG:Quad = new Quad(Starling.current.stage.stageWidth, 100, 0x000000);
      menuBG.alpha = 0.3;
      _swipeMenu.addChild(menuBG);
      
      _swipeMenu.y = Starling.current.stage.stageHeight - _swipeMenu.height;
      
      var arcadeButton:starling.display.Button = new starling.display.Button(AssetRegistry.MenuAtlas.getTexture("text-arcade"));
      arcadeButton.x = 22;
      arcadeButton.y = (_swipeMenu.height - arcadeButton.height) / 2;
      
      arcadeButton.addEventListener(Event.TRIGGERED, startArcade);
      _swipeMenu.addChild(arcadeButton);

      
      var levelSelectButton:starling.display.Button = new starling.display.Button(AssetRegistry.MenuAtlas.getTexture("text-story"));
      levelSelectButton.x = 389;
      levelSelectButton.y = arcadeButton.y;
      
      levelSelectButton.addEventListener(Event.TRIGGERED, startLevelSelect);
      _swipeMenu.addChild(levelSelectButton);
      
      var settingsButton:starling.display.Button = new starling.display.Button(AssetRegistry.MenuAtlas.getTexture("text-settings"));
      
      settingsButton.x = 701;
      settingsButton.y = arcadeButton.y;
      //settingsButton.onRelease.add(showSettingsMenu);
      settingsButton.addEventListener(Event.TRIGGERED, showSettingsMenu);
      _swipeMenu.addChild(settingsButton);
    
      addChild(_swipeMenu);
    }
    
    private function showSettingsMenu(event:Event):void {
      var settingsMenu:Sprite;
      settingsMenu = new Sprite();
      
      var bg:Image = new Image(AssetRegistry.MenuAtlas.getTexture("settings menu"));
      settingsMenu.addChild(bg);
      bg.x = (Starling.current.stage.stageWidth - bg.width) / 2;
      bg.y = (Starling.current.stage.stageHeight - bg.height) / 2;
      
      var controlGroup:ToggleGroup = new ToggleGroup;
      var boyStyle:Radio = new Radio();
      boyStyle.label = "Type 1";
      boyStyle.toggleGroup = controlGroup;
      boyStyle.onPress.add(function(radio:Radio):void {
        SaveGame.controlType = 1;
      });
      var girlStyle:Radio = new Radio();
      girlStyle.label = "Type 2";
      girlStyle.toggleGroup = controlGroup;
      girlStyle.onPress.add(function(radio:Radio):void {
        SaveGame.controlType = 2;
      });
      
      controlGroup.selectedIndex = SaveGame.controlType - 1;
      boyStyle.x = girlStyle.x = 200;
      
      //boyStyle.scaleX = boyStyle.scaleY = girlStyle.scaleX = girlStyle.scaleY = 3;
      
      //boyStyle.validate();
      
      boyStyle.y = 250;
      girlStyle.y = boyStyle.y + 50;
      
      settingsMenu.addChild(boyStyle);
      settingsMenu.addChild(girlStyle);
      
      
      // Name for leaderboards.
       
      var input:TextInput = new TextInput();
      input.text = SaveGame.userName;
      
      input.x = 200;
      input.y = 400;
      
      input.onChange.add(function(input:TextInput):void {
        SaveGame.userName = input.text;
      });
      
      settingsMenu.addChild(input);
      
      
      addChild(settingsMenu);
      
      var close:starling.display.Button = new starling.display.Button(AssetRegistry.MenuAtlas.getTexture("x"));
      settingsMenu.addChild(close);
      close.x = 787;
      close.y = 115;
      
      close.addEventListener(Event.TRIGGERED, function(event:Event):void {
        removeChild(settingsMenu);
      });
      
    }
    
    private function startArcade(event:Event):void {
//      var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
//      if (touch && _swipeMenu.y == Starling.current.stage.stageHeight - _swipeMenu.height) {
        StageManager.switchStage(ArcadeState);
//      }
    }
    
    private function startLevelSelect(event:Event):void {
//    var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
//      if (touch && _swipeMenu.y == Starling.current.stage.stageHeight - _swipeMenu.height) {
        StageManager.switchStage(LevelSelect);
//      }     
    }
     
    private function onTouch(event:TouchEvent):void
    {
      var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
      if (touch)
      {
        if (touch.getLocation(this).y > 400)
        {
          trace("Possible swipe!");
          _possibleSwipe = true;
          _swipeY = touch.getLocation(this).y;
        }
        else
        {
          _possibleSwipe = false;          
        }
      }
      else
      {
        touch = event.getTouch(this, TouchPhase.ENDED);
        if (touch)
        {
          if (_possibleSwipe && Math.abs((_swipeY - touch.getLocation(this).y)) > 50)
          {
            trace("Swipe!");
            if (_swipeMenu.y == Starling.current.stage.stageHeight && _swipeY > touch.getLocation(this).y)
            {
              new GTween(_swipeMenu, 0.2, {"y": Starling.current.stage.stageHeight - _swipeMenu.height});
            }
            else if (_swipeMenu.y == Starling.current.stage.stageHeight - _swipeMenu.height && _swipeY < touch.getLocation(this).y)
            {
              new GTween(_swipeMenu, 0.2, {"y": Starling.current.stage.stageHeight});
            }
          }
        }
      }
    }
    
    override public function dispose():void {
      super.dispose();
      AssetRegistry.disposeMenuGraphics();
    }
  }

}
