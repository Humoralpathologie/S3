package engine
{
    import flash.display.Bitmap;
    import org.josht.starling.foxhole.core.AddedWatcher;
    import org.josht.starling.foxhole.themes.MinimalTheme;
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import Menu.MainMenu;
    import starling.core.Starling;
  
  /**
   * A manager for different stages / scenes.
   * @author Roger Braun
   */
  public class StageManager extends Sprite
  {
    
    private var _currentStage:ManagedStage;
    private var _loadingScreen:Bitmap;
    private var _watcher:AddedWatcher;
    private var _frameCount:int = 0;
    private var _args:Object;
    private var _nextStage:Class;
    
    public function StageManager()
    {
      
      AssetRegistry.init();
      
      // For Foxhole theming
      _watcher = new MinimalTheme(Starling.current.stage, false);
      
      _loadingScreen = new AssetRegistry.LoadingScreenPNG;
      
      addEventListener(ManagedStage.CLOSING, onStageClosing);
      addEventListener(ManagedStage.SWITCHING, onStageSwitching);
      
      showStage(MainMenu);
      //showStage(VideoPlayer, { videoURI: "Outro_1.mp4" } );
    }
    
    private function onStageClosing(event:Event):void {
      _currentStage.removeFromParent(true);
      _currentStage = null;
    }
    
    private function onStageSwitching(event:Event):void {
      onStageClosing(event);
      showStage(event.data.stage, event.data.args);
    }
    
    private function loaderRemover(event:Event):void {
      _frameCount++;
      // Wait 3 frames until everything has settled.
      if (_frameCount == 2) {
        if (_args) {
          _currentStage = new _nextStage(_args);
        } else {
          _currentStage = new _nextStage();
        }
        addChild(_currentStage);
      }
      if (_frameCount > 3) {
        _frameCount = 0;
        Starling.current.nativeStage.removeChild(_loadingScreen);
        this.removeEventListener(EnterFrameEvent.ENTER_FRAME, loaderRemover);
      }
    }
    
    private function showStage(newStage:Class, args:Object = null):void
    {
      if (_currentStage) { return; }
      
      Starling.current.nativeStage.addChild(_loadingScreen);
      _args = args;
      _nextStage = newStage;
      
      this.addEventListener(EnterFrameEvent.ENTER_FRAME, loaderRemover);
    }
  }
}