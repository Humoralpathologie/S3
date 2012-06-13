package Menu
{
    import engine.ManagedStage;
    import flash.events.Event;
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
    
    public function MainMenu()
    {
      AssetRegistry.loadMenuGraphics();
      this.addEventListener(TouchEvent.TOUCH, onTouch);
      
      _bg = new Image(AssetRegistry.MenuAtlas.getTexture("loading"));
      addChild(_bg);
      
      _swipeMenu = new Sprite();
      
      var menuBG:Quad = new Quad(Starling.current.viewPort.width, 100, 0x000000);
      menuBG.alpha = 0.3;
      _swipeMenu.addChild(menuBG);
      
      _swipeMenu.y = Starling.current.viewPort.height;
      
      var arcadeButton:Image = new Image(AssetRegistry.MenuAtlas.getTexture("text-arcade"));
      arcadeButton.x = 22;
      arcadeButton.y = (_swipeMenu.height - arcadeButton.height) / 2;
      
      arcadeButton.addEventListener(TouchEvent.TOUCH, startArcade);
      _swipeMenu.addChild(arcadeButton);

      
      var levelSelectButton:Image = new Image(AssetRegistry.MenuAtlas.getTexture("text-story"));
      levelSelectButton.x = 389;
      levelSelectButton.y = arcadeButton.y;
      
      levelSelectButton.addEventListener(TouchEvent.TOUCH, startLevelSelect);
      _swipeMenu.addChild(levelSelectButton);
       
      var scoringButton:TextField = new TextField(200, 100, "SCORING", "kroeger 06_65", 40, 0xffffff);
      levelSelectButton.y = arcadeButton.y;
      scoringButton.x = levelSelectButton.x + levelSelectButton.width + 10;
      scoringButton.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void {
        var touch:Touch = event.getTouch(scoringButton, TouchPhase.ENDED);
        if (touch) {
          StageManager.switchStage(LevelScore);
        }
      });
      _swipeMenu.addChild(scoringButton);
         
      _swipeMenu.flatten();
      
      addChild(_swipeMenu);      
      
      _swipeMessage = new Image(AssetRegistry.MenuAtlas.getTexture("pleaseswipeup"));
      _swipeMessage.x = (Starling.current.viewPort.width - _swipeMessage.width) / 2;
      _swipeMessage.y = (Starling.current.viewPort.height - _swipeMessage.height) / 2;
      _swipeMessage.alpha = 0;
      
      addChild(_swipeMessage);
      
      Starling.juggler.delayCall(function():void { new GTween(_swipeMessage, 1, {alpha: 1})}, 2);
      
      /*
      var soundchannel:SoundChannel = AssetRegistry.LevelMusic1Sound.play();
      var loop:Function = function():void {
        soundchannel = AssetRegistry.LevelMusic2Sound.play(50);
        soundchannel.addEventListener(Event.ACTIVATE, loop)
      }
      
      soundchannel.addEventListener(Event.SOUND_COMPLETE, loop);
      */
    }
    
    private function startArcade(event:TouchEvent):void {
      var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
      if (touch && _swipeMenu.y == Starling.current.viewPort.height - _swipeMenu.height) {
        StageManager.switchStage(ArcadeState);
      }
    }
    
    private function startLevelSelect(event:TouchEvent):void {
    var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
      if (touch && _swipeMenu.y == Starling.current.viewPort.height - _swipeMenu.height) {
        StageManager.switchStage(LevelSelect);
      }     
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
            if (_swipeMenu.y == Starling.current.viewPort.height && _swipeY > touch.getLocation(this).y)
            {
              new GTween(_swipeMenu, 0.2, {"y": Starling.current.viewPort.height - _swipeMenu.height});
            }
            else if (_swipeMenu.y == Starling.current.viewPort.height - _swipeMenu.height && _swipeY < touch.getLocation(this).y)
            {
              new GTween(_swipeMenu, 0.2, {"y": Starling.current.viewPort.height});
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