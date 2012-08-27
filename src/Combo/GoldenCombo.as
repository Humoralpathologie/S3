package Combo
{
  import Level.LevelState;
  import engine.AssetRegistry;
  import Eggs.Egg;
  import starling.core.Starling;
  
  public class GoldenCombo extends Combo {
    
    public function GoldenCombo(trigger:String) {
      super();
      repeat = false;
      triggerString = trigger;
    }
    
    override public function effect(state:LevelState):void {
      var goldEgg:Egg = state.eggs.recycleEgg(0, 0, AssetRegistry.EGGGOLDEN);
      state.placeEgg(goldEgg);
      Starling.juggler.delayCall(function():void {
        if (state.eggs.eggPool.indexOf(goldEgg) != -1) {
          state.eggs.removeEgg(goldEgg);
        }
      }, 6);
      state.showMessage(AssetRegistry.Strings.GOLDENMESSAGE);
    }
  }
}