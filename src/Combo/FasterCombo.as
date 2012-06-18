package Combo 
{
  import engine.AssetRegistry;
  import Level.LevelState;
  
  public class FasterCombo extends Combo {
    public function FasterCombo() {
      super();
      repeat = true;
      trigger = [AssetRegistry.EGGA, AssetRegistry.EGGA, AssetRegistry.EGGA];
    }
    
    override public function effect(state:LevelState):void {
      state.snake.faster();
      //state.showMessage("Faster!");
    }
  }
}