package Level
{
  /**
   * ...
   * @author
   */
  import Eggs.Egg;
  import engine.AssetRegistry
  import starling.display.Image;
  import starling.display.BlendMode;
  import starling.display.Quad;
  import starling.events.Touch;
  import starling.events.TouchEvent;
  import starling.events.TouchPhase;
  import starling.text.TextField;
  import starling.textures.TextureSmoothing;
  import UI.HUD;
  import UI.Radar;
  import starling.utils.Color;
  
  public class Level1 extends LevelState
  {
    public function Level1()
    {
      AssetRegistry.loadLevel1Graphics();
      _levelNr = 1;
      super();
    }
    
    override protected function addBackground():void
    {
      _bgTexture = AssetRegistry.Level1Background;
      _bg = new Image(_bgTexture);
      _bg.blendMode = BlendMode.NONE;
      _bg.smoothing = TextureSmoothing.NONE;
      _levelStage.addChild(_bg);
    }       
    
    override protected function showObjective():void
    {     
      showObjectiveBox("For Little Snake revenge is a dish - literally!\n\nObjective:\n\nDevour 50 eggs & pay attention to the bonus scoring on your performance!!");
    }
    
    override public function spawnRandomEgg():void {
      var egg:Egg;
      var rand:int = Math.floor(Math.random() * 100);
      
      if (rand < 20) {
        egg = new Egg(0, 0, AssetRegistry.EGGA);
      } else if (rand < 50) {
        egg = new Egg(0, 0, AssetRegistry.EGGROTTEN);
      } else {
        egg = new Egg(0, 0, AssetRegistry.EGGZERO);
      }
      
      placeEgg(egg);
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

    override protected function addHud():void {
      _hud = new HUD(new Radar(_eggs, _snake), ["lifes", "time", "eggs"], this);
      addChild(_hud);
      
    }

    override protected function updateHud():void {
      super.updateHud();
      _hud.eggsText = String(_snake.eatenEggs);   
    }

    override protected function addObstacles():void
    {
      var pos:Array = [96, 97, 98, 99, 100, 10, 11, 12, 13, 14, 52, 53, 54, 55, 56, 57, 140, 141, 95];
      for (var i:int = 0; i < pos.length; i++)
      {
        _obstacles[pos[i]] = true;
      }
    }
  }

}
