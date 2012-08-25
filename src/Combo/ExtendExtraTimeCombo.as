package Combo
{
    import Level.LevelState;
    import engine.AssetRegistry;
  
  /**
   * ...
   * @author
   */
  public class ExtendExtraTimeCombo extends Combo
  {
    
    public function ExtendExtraTimeCombo(trigger:String)
    {
      super();
      this.triggerString = trigger;
    }
    
    override public function effect(state:LevelState):void {
      state.showMessage(AssetRegistry.Strings.EXTRATIMEEXTMESSAGE);
      state.timeExtension = 4;
      state.showSpecialParticles(state.snake.head, "BonusTime");
    }
  
  }

}