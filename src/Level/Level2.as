package Level
{
  /**
   * ...
   * @author
   */
  import engine.AssetRegistry
  import starling.display.Image;
  import starling.display.BlendMode;
  import Eggs.Egg;
  import UI.HUD;
  import UI.Radar;
  
  public class Level2 extends LevelState
  {
    public function Level2()
    {
      AssetRegistry.loadGraphics([AssetRegistry.SNAKE, AssetRegistry.LEVEL2]);
      
      _levelNr = 2;
      super();
    }
    
    override protected function addBackground():void
    {
      _bgTexture = AssetRegistry.Level2Background;
      _bg = new Image(_bgTexture);
      _bg.blendMode = BlendMode.NONE;
      _levelStage.addChild(_bg);
    }
    
    override public function spawnRandomEgg():void {
      var egg:Egg;
      var rand:int = Math.floor(Math.random() * 100);
      
      if (rand < 50) {
        egg = new Egg(0, 0, AssetRegistry.EGGA);
      } else if (rand < 70) {
        egg = new Egg(0, 0, AssetRegistry.EGGROTTEN);
      } else {
        egg = new Egg(0, 0, AssetRegistry.EGGZERO);
      }      
      placeEgg(egg);
    }    
    
    override protected function showObjective():void
    {     
      showObjectiveBox("Little Snake could squeeze oodles of eggs in his expansible guts, but he found the blue ones to be especially digestible when eaten in succession & greater quantities.\n\nObjective:\nDevour 10 Blue Egg Combos!!");
    }
    
    override public function dispose():void
    {
      super.dispose();
    }
    
    override protected function checkWin():void
    {
      if (_combos == 10)
      {
        win();
      }
    }
    
    override protected function addHud():void {
      _hud = new HUD(new Radar(_eggs, _snake), ["lifes", "time", "combo", "speed"], this);
      addChild(_hud);
      
    }
    override protected function updateHud():void {
      super.updateHud();

      _hud.comboText = String(_combos);
      _hud.speedText = String(_snake.mps);   
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
