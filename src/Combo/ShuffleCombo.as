package Combo
{
  import Level.LevelState;
  import Eggs.Egg;
  import engine.AssetRegistry;
  
  public class ShuffleCombo extends Combo
  {
    public function ShuffleCombo(trigger:String)
    {
      super();
      repeat = false;
      this.triggerString = trigger;

    }
    
    override public function effect(state:LevelState):void
    {
      state.placeEgg(state.eggs.recycleEgg(0,0, AssetRegistry.EGGSHUFFLE));
      state.showMessage(AssetRegistry.Strings.SHUFFLEMESSAGE);
    }
  }
}