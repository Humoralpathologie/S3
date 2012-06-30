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
  import Eggs.Egg;
  import UI.HUD;
  import UI.Radar;
  
  public class Level3 extends LevelState 
  {
    public function Level3() 
    {
      AssetRegistry.loadLevel3Graphics();
      _levelNr = 3;
      _rottenEnabled = true;
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

    override protected function spawnRandomEgg():void {
      var egg:Egg;
      var type:int;
      var types:Array = [AssetRegistry.EGGA, AssetRegistry.EGGZERO];
      type = types[Math.floor(Math.random() * types.length)];
      
      egg = new Egg(0, 0, type);
      
      placeEgg(egg);
    } 
    
    override protected function checkLost():void {
      if (_poisonEggs > 4) {
        lose();
      }
      super.checkLost();
    }
    
    override protected function checkWin():void {
      if (_combos == 10 || _overallTimer >= 4 * 60) {
        win();
      }
    }
    
    override protected function showObjective():void
    {     
      showObjectiveBox("On a quest for revenge you often have to act on a whim. So you have to forgive our hero that he didn't know about the high toxicity of the gray eggs and fell into a ferocious delirium.\n\nObjective:\nGet Little Snake sobered up - either by surviving for 4 minutes or by getting 10 combos. And eating more than 4 gray eggs will kill you from now on!!", 40);
    }    

    override protected function addHud():void {
      _hud = new HUD(new Radar(_eggs, _snake), ["lifes", "time", "combo", "poison"]);
      addChild(_hud);
      _hud.poison.x = 108;
      _hud.poison.y = 70;
      _hud.poisonTextField.x = _hud.poison.x + _hud.poison.width + 12;  
    }
    override protected function updateHud():void {
      super.updateHud();
      _hud.comboText = String(_combos);
      _hud.poisonText = String(_poisonEggs);   
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
