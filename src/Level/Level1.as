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
  
  public class Level1 extends LevelState 
  {
    public function Level1() 
    {
      AssetRegistry.loadLevel1Graphics();
      _levelNr = 1;
      super();
    }
    
    override protected function addBackground():void {
      _bgTexture = AssetRegistry.Level1Background;
      _bg = new Image(_bgTexture);
      _bg.blendMode = BlendMode.NONE;
      _bg.smoothing = TextureSmoothing.NONE;
      _levelStage.addChild(_bg);
    }
    
    override public function dispose():void {
      AssetRegistry.disposeLevel1Graphics();
      super.dispose();
    }
     
    override protected function checkWin():void {
      if (_snake.eatenEggs == 50) {
        win();
      }
    }
    
    override protected function addObstacles():void {
      var pos:Array = [96, 97, 98, 99, 100, 10, 11, 12, 13, 14, 52, 53, 54, 55, 56, 57, 140, 141, 95];
      for (var i:int = 0; i < pos.length; i++) {
        _obstacles[pos[i]] = true;
      }
    }
  }

}