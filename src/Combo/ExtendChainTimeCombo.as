package Combo
{
    import Level.LevelState;
    import engine.AssetRegistry;
  
  /**
   * ...
   * @author
   */
  public class ExtendChainTimeCombo extends Combo
  {
    
    public function ExtendChainTimeCombo(trigger:String)
    {
      super();
      this.triggerString = trigger;
    }
    
    override public function effect(state:LevelState):void {
      state.showMessage(AssetRegistry.Strings.CHAINTIMEEXTMESSAGE);
      state.chainTime = 3.5;
	    state.adjustBonusBack(37);
	    state.extensionTime = state.overallTimer + 60;
      state.showSpecialParticles(state.snake.head, "ChainTimePlus");
    }
  
  }

}