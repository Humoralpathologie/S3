package Combo 
{
  import engine.AssetRegistry;
  import Level.LevelState;
  
  public class SlowerCombo extends Combo {
    public function SlowerCombo() {
      super();
      repeat = true;
      trigger = [AssetRegistry.EGGB, AssetRegistry.EGGB, AssetRegistry.EGGB];
    }
    
    override public function effect(state:LevelState):void {
      state.snake.slower();
      state.showMessage(AssetRegistry.Strings.SLOWERMESSAGE);
    }
  }
}