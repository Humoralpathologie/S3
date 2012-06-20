package Combo
{
  
  /**
   * ...
   * @author
   */
  import Level.LevelState;
  import engine.AssetRegistry;
  
  public class ExtraLifeCombo extends Combo
  {
    
    public function ExtraLifeCombo()
    {
      super();
      repeat = false;
      trigger = [AssetRegistry.EGGC, AssetRegistry.EGGA, AssetRegistry.EGGA, AssetRegistry.EGGB];
    }
    
    override public function effect(state:LevelState):void
    {
      state.snake.lives += 1;
      state.showMessage("Bonus Life!");
    }
  
  }

}