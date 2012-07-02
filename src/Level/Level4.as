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
  import Eggs.Egg;
  
  
  public class Level4 extends LevelState 
  {
    private var _winningPositions:Array;
    
    public function Level4() 
    {
      AssetRegistry.loadLevel4Graphics();
      _levelNr = 4;
      _rottenEnabled = true;
      _winningPositions = [2419, 2420, 2421, 2422, 2423, 2424, 2425, 2426, 2427, 2428];
      
      super();
      _startPos.x = 20;
      _startPos.y = 20;
      startAt(_startPos.x, _startPos.y);
      
      updateCamera();
    }
    
    override protected function setBoundaries():void {
      _levelBoundaries = new Rectangle(10, 7, 42, 33);
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
      showObjectiveBox("Seems like the Terror Triceratops either got wind of his murderous stalker or was just a little too chubby for the old bridge...\n\nObjective:\nGet Little Snakes speed up to 7 and jump!");
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
      var pos:Array = [1552, 1489, 1488, 1551, 2432, 2433, 2434, 2435, 2436, 2437, 2438, 2439, 2440, 2441, 2442, 2443, 2381, 2445, 2446, 2444, 2354, 2467, 2468, 2469, 2470, 2471, 2344, 2345, 2346, 2347, 2348, 2477, 2478, 2479, 2352, 2481, 2482, 2483, 2484, 2485, 2486, 2487, 2480, 2489, 2490, 2491, 2492, 2493, 2349, 2350, 2488, 2342, 2343, 2472, 2473, 2474, 2475, 2476, 2368, 2369, 2351, 2341, 2372, 2509, 2502, 2494, 2504, 2505, 2506, 2370, 2371, 2500, 2501, 2383, 2503, 2376, 2495, 2496, 2507, 2508, 2499, 2382, 2373, 2374, 2375, 2404, 2405, 2406, 2407, 2408, 2409, 2410, 2411, 2412, 2413, 2414, 2415, 2378, 2379, 2380, 2497, 2498, 2377, 2366, 2431];
      
      for (var i:int = 0; i < pos.length; i++)
      {
        _obstacles[pos[i]] = true;
      }
    } 
    
    override protected function checkLost():void {
      if (_poisonEggs > 4) {
        lose();
      }
      super.checkLost();
    }
    
    override public function spawnRandomEgg():void {
      var egg:Egg;
      var type:int;
      var types:Array = [AssetRegistry.EGGA, AssetRegistry.EGGZERO];
      type = types[Math.floor(Math.random() * types.length)];
      
      egg = new Egg(0, 0, type);
      
      placeEgg(egg);
    } 
    
    override protected function checkWin():void {
      if (_winningPositions.indexOf(_snake.head.tileY * _tileWidth + _snake.head.tileX) != -1 && _snake.mps >= 16) {
        win();
      }
    }
  }

}
