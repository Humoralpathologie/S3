package Level 
{
	/**
     * ...
     * @author 
     */
  import engine.AssetRegistry
  import starling.display.Image;
  import starling.display.BlendMode;
  
  public class Level1 extends LevelState 
  {
    public function Level1() 
    {
      super();
    }
    
    override protected function addBackground():void {
      _bgTexture = AssetRegistry.Level1Background;
      _bg = new Image(_bgTexture);
      _bg.blendMode = BlendMode.NONE;
      _levelStage.addChild(_bg);
    }
        
  }

}