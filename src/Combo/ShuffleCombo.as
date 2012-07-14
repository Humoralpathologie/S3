package Combo
{
  import Level.LevelState;
  import Eggs.Egg;
  import engine.AssetRegistry;
  
  public class ShuffleCombo extends Combo
  {
    public function ShuffleCombo()
    {
      super();
      repeat = false;
      trigger = [AssetRegistry.EGGC, AssetRegistry.EGGB, AssetRegistry.EGGC, AssetRegistry.EGGB, AssetRegistry.EGGA];
    }
    
    override public function effect(state:LevelState):void
    {
      state.placeEgg(state.eggs.recycleEgg(0,0, AssetRegistry.EGGSHUFFLE));
      state.showMessage("Shuffle!");
    }
  }
}