package Level 
{
	/**
     * ...
     * @author 
     */
  import engine.AssetRegistry
  import starling.display.Image;
  import starling.display.BlendMode;
  
  public class Level2 extends LevelState 
  {
    public function Level2() 
    {
      AssetRegistry.loadLevel2Graphics();
      _levelNr = 2;
      super();
    }
    
    override protected function addBackground():void {
      _bgTexture = AssetRegistry.Level2Background;
      _bg = new Image(_bgTexture);
      _bg.blendMode = BlendMode.NONE;
      _levelStage.addChild(_bg);
    }
    
    override public function dispose():void {
      AssetRegistry.disposeLevel2Graphics();
      super.dispose();
    }
     
    override protected function checkWin():void {
      if (_combos == 10) {
        win();
      }
    }
  }

}