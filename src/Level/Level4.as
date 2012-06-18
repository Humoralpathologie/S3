package Level 
{
	/**
     * ...
     * @author 
     */
  import com.gskinner.motion.GTween;
  import engine.AssetRegistry
  import flash.system.ImageDecodingPolicy;
  import starling.display.Image;
  import starling.display.BlendMode;
  import starling.textures.TextureSmoothing;
  
  public class Level4 extends LevelState 
  {
    public function Level4() 
    {
      AssetRegistry.loadLevel4Graphics();
      _levelNr = 4;
      super();
      startAt(15, 15);
      updateCamera();
    }
    
    override protected function addBackground():void {
      _bgTexture = AssetRegistry.Level4Atlas.getTexture("Level4mitRahmen");
      _bg = new Image(_bgTexture);
      _bg.blendMode = BlendMode.NONE;
      _levelStage.addChild(_bg);

      var palmtree:Image = new Image(AssetRegistry.Level4Atlas.getTexture("level4_palme_stamm"));
      palmtree.x = 512;
      palmtree.y = 241;
      palmtree.smoothing = TextureSmoothing.NONE;
     _levelStage.addChild(palmtree);      
    }
    
    override protected function addAboveSnake():void {
      var palmleaves:Image = new Image(AssetRegistry.Level4Atlas.getTexture("level4_palme_blätter"));
      palmleaves.x = 510;
      palmleaves.y = 251;
      palmleaves.smoothing = TextureSmoothing.NONE;
      _levelStage.addChild(palmleaves);
    }
    
    override public function dispose():void {
      AssetRegistry.disposeLevel4Graphics();
      super.dispose();
    }
    
    override public function addFrame():void {
      // Not needed here.
    }    
    
    override protected function showObjective():void
    {     
      showObjectiveBox("Seems like the Terror Triceratops either got wind of his murderous stalker or was just a little too chubby for the old bridge...\n\nObjective:\nGet Little Snakes speed up to 11 and jump!");
    }    
    
    override protected function addObstacles():void
    {
      var pos:Array = [1552, 1489, 1488, 1551];
      
      for (var i:int = 0; i < pos.length; i++)
      {
        _obstacles[pos[i]] = true;
      }
    } 
    
    override protected function checkWin():void {
      if (_combos == 20 || _snake.eatenEggs == 100 || _overallTimer == 4 * 60) {
        win();
      }
    }
  }

}