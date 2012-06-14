package Level 
{
	/**
     * ...
     * @author 
     */
  import com.gskinner.motion.GTween;
  import engine.AssetRegistry
  import starling.display.Image;
  import starling.display.BlendMode;
  
  public class Level3 extends LevelState 
  {
    public function Level3() 
    {
      AssetRegistry.loadLevel3Graphics();
      _levelNr = 3;
      super();
    }
    
    override protected function addBackground():void {
      _bgTexture = AssetRegistry.Level3Background;
      _bg = new Image(_bgTexture);
      _bg.blendMode = BlendMode.NONE;
      _levelStage.addChild(_bg);
      
      var glowing:Image = new Image(AssetRegistry.Level3StoneGlow);
      glowing.x = 188;
      glowing.y = 219;
      glowing.blendMode = BlendMode.ADD;
      
      new GTween(glowing, 2, { alpha: 0 }, { reflect:true, repeatCount: 0 } );
      
      _levelStage.addChild(glowing);
    }
    
    override public function dispose():void {
      AssetRegistry.disposeLevel3Graphics();
      super.dispose();
    }
     
    override protected function checkWin():void {
      if (_combos == 20 || _snake.eatenEggs == 100 || _overallTimer == 4 * 60) {
        win();
      }
    }
    
    override protected function addObstacles():void
    {
      var pos:Array = [704, 705, 788, 743, 744, 745, 746, 747, 748, 658, 659, 660, 789, 790, 700, 701, 702, 703];
      
      for (var i:int = 0; i < pos.length; i++)
      {
        _obstacles[pos[i]] = true;
      }
    }    
    
  }

}