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
  
  public class Level4 extends LevelState 
  {
    public function Level4() 
    {
      AssetRegistry.loadLevel4Graphics();
      _levelNr = 4;
      super();
    }
    
    override protected function addBackground():void {
      _bgTexture = AssetRegistry.Level4Background;
      _bg = new Image(_bgTexture);
      _bg.blendMode = BlendMode.NONE;
      _levelStage.addChild(_bg);
      
    }
    
    override public function dispose():void {
      AssetRegistry.disposeLevel4Graphics();
      super.dispose();
    }
     
    override protected function checkWin():void {
      if (_combos == 20 || _snake.eatenEggs == 100 || _overallTimer == 4 * 60) {
        win();
      }
    }
  }

}