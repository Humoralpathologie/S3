package Combo
{
  import Level.LevelState;
  import Eggs.Egg;
  import engine.AssetRegistry;
  
  public class NoRottenCombo extends Combo {
    public function NoRottenCombo() {
      super();
      repeat = true;
      trigger = [AssetRegistry.EGGC, AssetRegistry.EGGC, AssetRegistry.EGGC];
    }
    
    override public function effect(state:LevelState):void {
      //state.rottenEggs.clear();
      state.showMessage("No Rotten Eggs!");
    }
  }
}