package Level 
{
	/**
     * ...
     * @author 
     */
  import engine.AssetRegistry
  import starling.display.Image;
  import starling.display.BlendMode;
  import starling.textures.TextureSmoothing;
  
  public class Level7 extends LevelState 
  {
    public function Level7() 
    {
      AssetRegistry.loadLevel7Graphics();
      _levelNr = 7;
      super();
    }
    
    override protected function addBackground():void {
      _bgTexture = AssetRegistry.Level7Atlas.getTexture("level07");
      _bg = new Image(_bgTexture);
      _bg.blendMode = BlendMode.NONE;
      _bg.smoothing = TextureSmoothing.NONE;
      _levelStage.addChild(_bg);
    }
    
    override public function dispose():void {
      AssetRegistry.disposeLevel7Graphics();
      super.dispose();
    }
     
    override protected function addObstacles():void {
      var pos:Array = [];
      for (var i:int = 0; i < pos.length; i++) {
        _obstacles[pos[i]] = true;
      }
    }
  }

}