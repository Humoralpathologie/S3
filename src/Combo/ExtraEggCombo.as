package Combo
{
    import Level.LevelState;
    import engine.AssetRegistry;
  
  /**
   * ...
   * @author
   */
  public class ExtraEggCombo extends Combo
  {
    
    public function ExtraEggCombo(trigger:String)
    {
      super();
      this.triggerString = trigger;
    }
    
    override public function effect(state:LevelState):void {
      state.showMessage(AssetRegistry.Strings.EXTRAEGGSMESSAGE);
      for (var i:int = 0; i < 5; i++) {
        state.spawnRandomEgg();
      }
    }
  
  }

}