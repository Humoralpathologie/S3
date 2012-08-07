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
    
    public function ExtraLifeCombo(trigger:String)
    {
      super();
      repeat = false;
      triggerString = trigger;
    }
    
    override public function effect(state:LevelState):void
    {
      state.snake.lives += 1;
      state.showMessage("Bonus Life!");
    }
  
  }

}