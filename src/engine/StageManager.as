package engine
{
    import flash.display.Bitmap;
    import org.josht.starling.foxhole.core.AddedWatcher;
    import org.josht.starling.foxhole.themes.MinimalTheme;
    import starling.display.Sprite;
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
    
    public function StageManager()
    {
      
      AssetRegistry.init();
      
      // For Foxhole theming
      _watcher = new MinimalTheme(Starling.current.stage, false);
      
      _loadingScreen = new AssetRegistry.LoadingScreenPNG;
      
      addEventListener(ManagedStage.CLOSING, onStageClosing);
      addEventListener(ManagedStage.SWITCHING, onStageSwitching);
      
      showStage(MainMenu);
    }
    
    private function onStageClosing(event:Event) {
      _currentStage.removeFromParent(true);
      _currentStage = null;
    }
    
    private function onStageSwitching(event:Event) {
      onStageClosing(event);
      showStage(event.data.stage, event.data.args);
    }
    
    private function showStage(newStage:Class, args:Object = null):void
    {
      if (_currentStage) { return; }
      
      if (args) {
        _currentStage = new newStage(args);
      } else {
        _currentStage = new newStage();
      }
      addChild(_currentStage);
    }
  }
}