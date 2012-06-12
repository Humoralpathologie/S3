package
{
  import com.sociodox.theminer.TheMiner;
  import engine.AssetRegistry;
  import flash.desktop.NativeApplication;
  import flash.display.Bitmap;
  import flash.events.Event;
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.geom.Rectangle;
  import flash.ui.Multitouch;
  import flash.ui.MultitouchInputMode;
  import Level.LevelState;
  import starling.core.Starling;
  import fr.kouma.starling.utils.Stats;
  import Level.*;
  import engine.StageManager;
  import engine.SaveGame;
  import com.demonsters.debugger.MonsterDebugger;
  
  /**
   * ...
   * @author
   */
  [SWF(width="960",height="640",frameRate="60",backgroundColor="#ffffff")]
  
  public class Main extends Sprite
  {
    
    private var starling:Starling;
    private var assets:AssetRegistry;
    
    public function Main():void
    {
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      stage.addEventListener(Event.DEACTIVATE, deactivate);
      
      Starling.handleLostContext = false;
      
      //MonsterDebugger.initialize(this);
      //MonsterDebugger.trace(this, "Hello World");
      //stage.addChild(new TheMiner());
      
      // touch or gesture?
      Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
      
      // entry point  
      SaveGame.load();
      starling = new Starling(StageManager, stage, new Rectangle(0, 0, 960, 640));
      
      var loadingSprite:Sprite = new Sprite()
      var loadingBMP:Bitmap = new AssetRegistry.LoadingPNG();
      loadingSprite.addChild(loadingBMP);
      
      addChild(loadingSprite);
      
      starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, function(e:Event):void
        {
          // Starling is ready! We remove the startup image and start the game.
          removeChild(loadingSprite);
          starling.start();
        });
      
      // When the game becomes inactive, we pause Starling; otherwise, the enter frame event
      // would report a very long 'passedTime' when the app is reactivated. 
      
      NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, function(e:Event):void
        {
          starling.start();
        });
      
      NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, function(e:Event):void
        {
          starling.stop();
        });
    }
    
    private function deactivate(e:Event):void
    {
      // auto-close
      NativeApplication.nativeApplication.exit();
    }
  
  }

}