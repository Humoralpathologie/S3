package engine
{
  import starling.display.Sprite;
  import Menu.MainMenu;
  
  /**
   * ...
   * @author
   */
  public class StageManager extends Sprite
  {
    
    private static var _currentSprite:Sprite;
    private static var _manager:StageManager;
        
    public function StageManager()
    {
      _manager = this;
      AssetRegistry.init();      
      switchStage(new MainMenu);
    }
    
    public static function switchStage(newStage:Sprite):void {
      if (_currentSprite != null) {
        _manager.removeChild(_currentSprite);
      }
      _currentSprite = newStage;
      _manager.addChild(newStage);
    }
  
  }

}