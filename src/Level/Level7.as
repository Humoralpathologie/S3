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
  import UI.HUD;
  import UI.Radar;
  
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
 
    override protected function showObjective():void
    {     
      showObjectiveBox("Addiction\n\nObjective:\nEat two chains of at least ten eggs & don't stop eating for longer than 5 seconds.");
    }            
    
    override public function dispose():void {
      AssetRegistry.disposeLevel7Graphics();
      super.dispose();
    }
     
    override protected function addHud():void {
      _hud = new HUD(new Radar(_eggs, _snake), ["lifes", "time", "speed", "poison"]);
      addChild(_hud);
      
    }
    override protected function updateHud():void {
      super.updateHud();
      _hud.comboText = String(_combos);
      _hud.speedText = "0";   
    }
    override protected function addObstacles():void {
      var pos:Array = [];
      for (var i:int = 0; i < pos.length; i++) {
        _obstacles[pos[i]] = true;
      }
    }
  }

}
