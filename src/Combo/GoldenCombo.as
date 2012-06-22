package Combo
{
  import Level.LevelState;
  import engine.AssetRegistry;
  import Eggs.Egg;
  
  public class GoldenCombo extends Combo {
    public function GoldenCombo() {
      super();
      repeat = false;
      trigger = [AssetRegistry.EGGB, AssetRegistry.EGGA, AssetRegistry.EGGC, AssetRegistry.EGGA, AssetRegistry.EGGC];
    }
    
    override public function effect(state:LevelState):void {
      state.placeEgg(new Egg(0,0, AssetRegistry.EGGGOLDEN));
      state.showMessage("Golden Egg!");
    }
  }
}