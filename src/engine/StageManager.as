package engine
{
  import flash.display.Bitmap;
  import starling.display.Sprite;
  import Menu.MainMenu;
  import starling.core.Starling;
  import starling.events.EnterFrameEvent;
  
  /**
   * ...
   * @author
   */
  public class StageManager extends Sprite
  {
    
    private static var _currentSprite:Sprite;
    private static var _manager:StageManager;
    private static var _loadingScreen:Bitmap;
    private static var _frame:int = 0;
    private static var _nextStage:Class;
    
    public function StageManager()
    {
      _manager = this;
      AssetRegistry.init();
      _loadingScreen = new AssetRegistry.LoadingPNG;
      switchStage(MainMenu);
    }
    
    public static function switchStage(newStage:Class):void
    {
      Starling.current.nativeStage.addChild(_loadingScreen);
      
      _nextStage = newStage;
      
      _manager.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
    }
    
    private static function onEnterFrame(event:EnterFrameEvent):void
    {
      _frame++;
      if (_frame == 2)
      {
        if (_currentSprite != null)
        {
          _manager.removeChild(_currentSprite);
          Starling.juggler.purge();
          _currentSprite.dispose();
        }
        _currentSprite = new _nextStage;
        Starling.juggler.paused = false;
        _manager.addChild(_currentSprite);
      }
      if (_frame == 3)
      {
        Starling.current.nativeStage.removeChild(_loadingScreen);
        _manager.removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
        _frame = 0;
      }
    }
  
  }

}