package Combo
{
  
  /**
   * ...
   * @author
   */
  import Level.LevelState;
  import engine.AssetRegistry;
  import starling.extensions.PDParticleSystem;
  
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
      state.showMessage(AssetRegistry.Strings.EXTRALIFEMESSAGE);
      state.showParticles(state.snake.head, 5);
    }
  
  }

}