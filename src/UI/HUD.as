package UI
{
  import Level.LevelState;
  import starling.display.Image;
  import starling.display.Sprite;
  import engine.AssetRegistry;
  
  /**
   * ...
   * @author Roger Braun
   */
  public class HUD extends Sprite
  {
    private var _controls:Sprite;
    private var _top:Image;
    
    public function HUD(levelState:LevelState)
    {
      createTop();
      createControls();
      
      addChild(_top);
      addChild(_controls);
    }
    
    private function createTop():void {
      _top = new Image(AssetRegistry.UIAtlas.getTexture("ui-top"));
    }
    
    private function createControls():void {
      _controls = new Sprite();
    }
  
  }

}