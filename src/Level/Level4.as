package Level 
{
	/**
     * ...
     * @author 
     */
  import com.gskinner.motion.GTween;
  import engine.AssetRegistry
  import flash.geom.Rectangle;
  import flash.system.ImageDecodingPolicy;
  import starling.display.Image;
  import starling.display.BlendMode;
  import starling.textures.TextureSmoothing;
  import UI.HUD;
  import UI.Radar;
  
  public class Level4 extends LevelState 
  {
    public function Level4() 
    {
      AssetRegistry.loadLevel4Graphics();
      _levelNr = 4;
      super();
      _startPos.x = 20;
      _startPos.y = 20;
      startAt(_startPos.x, _startPos.y);
      
      updateCamera();
    }
    
    override protected function setBoundaries():void {
      _levelBoundaries = new Rectangle(10, 7, 42, 32);
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
    
    override protected function addHud():void {
      _hud = new HUD(new Radar(_eggs, _snake), ["lifes", "time", "speed", "poison"]);
      addChild(_hud);
      
    }
    override protected function updateHud():void {
      super.updateHud();
      _hud.speedText = String(_snake.mps);
      _hud.poisonText = String(_poisonEggs);   
    }
    override protected function addObstacles():void
    {
      var pos:Array = [1552, 1489, 1488, 1551, 2415, 2480, 2370, 2371, 2372, 2373, 2494, 2431, 2369, 2378, 2379, 2380, 2381, 2382, 2383, 2376, 2368, 2374, 2375, 2366, 2377, 2354, 2341, 2342, 2343, 2344, 2345, 2346, 2347, 2348, 2349, 2350, 2479, 2352, 2481, 2482, 2483, 2484, 2485, 2478, 2351, 2488, 2489, 2490, 2491, 2492, 2493, 2486, 2487];
      
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
