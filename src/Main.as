package
{
  //import com.sociodox.theminer.TheMiner;
  import engine.AssetRegistry;
  import flash.desktop.NativeApplication;
  import flash.display.Bitmap;
  import flash.events.Event;
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.geom.Rectangle;
  import flash.media.StageVideo;
  import flash.net.NetConnection;
  import flash.net.NetStream;
  import flash.ui.Multitouch;
  import flash.ui.MultitouchInputMode;
  import Level.LevelState;
  import org.josht.starling.foxhole.themes.IFoxholeTheme;
  import starling.core.Starling;
  import Level.*;
  import engine.StageManager;
  import engine.SaveGame;
  //import com.demonsters.debugger.MonsterDebugger;
  import flash.system.Capabilities;
  import engine.Mogade;
  import flash.desktop.SystemIdleMode;
  
  /**
   * ...
   * @author
   */
  [SWF(width="960",height="640",frameRate="60",backgroundColor="#000000")]
  
  public class Main extends Sprite
  {
    
    private var starling:Starling;
    private var assets:AssetRegistry;
    
    public function Main():void
    {
      // Deactivate sleep.
      NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
      
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      
      stage.addEventListener(Event.DEACTIVATE, deactivate);
      //Starling.handleLostContext = true;
      
      //MonsterDebugger.initialize(this);
      //MonsterDebugger.trace(this, "Hello World");
      //stage.addChild(new TheMiner());
      
      // touch or gesture?
      Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
      
      // entry point  
      SaveGame.load();
      
      // It seems anything can be returned here. Just use the larger value as width.
      var screenWidth:int = Math.max(stage.fullScreenWidth, stage.fullScreenHeight);
      var screenHeight:int = Math.min(stage.fullScreenHeight, stage.fullScreenWidth);
      
      var wwidth:int;
      var hheight:int;
      
      if (AssetRegistry.ASPECT_RATIO < screenWidth / screenHeight)
      {
        wwidth = int(screenHeight * (960 / 640));
        hheight = screenHeight;
      }
      else
      {
        wwidth = screenWidth;
        hheight = int(screenWidth / (960 / 640));
      }
      
      AssetRegistry.SCALE = wwidth / 960;
      
      var yy:int = (screenHeight - hheight) / 2;
      var xx:int = (screenWidth - wwidth) / 2;
      starling = new Starling(StageManager, stage, new Rectangle(xx, yy, wwidth, hheight), null, "auto", "baseline");
      starling.stage.stageHeight = 640;
      starling.stage.stageWidth = 960;
      
      var loadingSprite:Sprite = new Sprite()
      var loadingBMP:Bitmap = new AssetRegistry.LoadingPNG();
      loadingBMP.x = Starling.current.viewPort.x;
      loadingBMP.y = Starling.current.viewPort.y;
      loadingBMP.scaleX = loadingBMP.scaleY = AssetRegistry.SCALE;
      loadingSprite.addChild(loadingBMP);
      
      addChild(loadingSprite);
      
      // For debugging. 
      Starling.current.showStats = true;
      
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
      if (!(Capabilities.os.indexOf("Windows") != -1 || Capabilities.os.indexOf("Mac") != -1))
      {
        NativeApplication.nativeApplication.exit();
      }
    }
  }

}
