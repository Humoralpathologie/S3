package Menu.ComboMenuScreens
{
  import org.josht.starling.display.Image;
  import org.josht.starling.foxhole.controls.Screen;
  import Menu.ComboMenuScreens.*;
  import org.osflash.signals.Signal;
  import org.osflash.signals.ISignal;
  import starling.display.Quad;
  import starling.events.Event;
  import starling.utils.Color;
  import engine.AssetRegistry;
  import starling.display.Button;
  import starling.display.DisplayObject;
  import engine.SaveGame;
  import starling.display.Sprite;
  
  /**
   * ...
   * @author
   */
  public class ComboSelectTwo extends Screen
  {
    protected var _onMainComboMenu:Signal = new Signal(ComboSelectTwo);
    protected var _onComboSelect:Signal = new Signal(ComboSelectTwo);
    
    private var _sharedData:Object = {};
    
    public function ComboSelectTwo()
    {
      super();
    }
    
    override protected function initialize():void
    {
      var greybox:Quad = new Quad(710, 450, Color.BLACK);
      greybox.alpha = 0.3;
      greybox.x = 65 + 60;
      greybox.y = 40 + 30;
      
      addChild(greybox);
      
      var that:ComboSelectTwo = this;
      
      var chaintime:Button = new Button(AssetRegistry.MenuAtlas.getTexture("combo-chaintime"));
      chaintime.x = 156;
      chaintime.y = 152;
      addChild(chaintime);
      
      var chaintimeText:Image = new Image(AssetRegistry.MenuAtlas.getTexture("Text-ChainTimePlus"));
      chaintimeText.x = 264;
      chaintimeText.y = 165;
      addChild(chaintimeText);
      
      var xtraspawn:Button = new Button(AssetRegistry.MenuAtlas.getTexture("combo-xtraspawn"));
      xtraspawn.x = 156;
      xtraspawn.y = 280;
      addChild(xtraspawn);
      
      var xtraspawnText:Image = new Image(AssetRegistry.MenuAtlas.getTexture("Text-ExtraEgg"));
      xtraspawnText.x = 264;
      xtraspawnText.y = 280;
      addChild(xtraspawnText);
      
      chaintime.addEventListener(Event.TRIGGERED, function(event:Event):void {
        sharedData.effect = "combo-chaintime";
        showComboOptions(chaintimeText);
      });
      
      xtraspawn.addEventListener(Event.TRIGGERED, function(event:Event):void {
        sharedData.effect = "combo-xtraspawn";
        showComboOptions(xtraspawnText);
      });
      
      var prev:Button = new Button(AssetRegistry.MenuAtlas.getTexture("right-arrow"));
      prev.x = greybox.x + greybox.width - 100;
      prev.x += prev.width * 2;
      prev.y = greybox.y + greybox.height - 100;
      prev.scaleX = -2;
      prev.scaleY = 2;
      addChild(prev);
      
      prev.addEventListener(Event.TRIGGERED, function(event:Event):void
        {
          onComboSelect.dispatch(that);
        });
    }
    
    private function showComboOptions(reference:DisplayObject):void
    {
      var combos:Array = ["combo_abbca", "combo_bcaac", "combo_ccbba"];
      
      var sprite:Sprite = new Sprite();
      
      for (var i:int = 0; i < combos.length; i++)
      {
        var comboButton:Button = new Button(AssetRegistry.MenuAtlas.getTexture(combos[i]));
        comboButton.y = reference.y;
        comboButton.x = reference.x + 50 + i * 150;
        sprite.addChild(comboButton);
        
        var that:ComboSelectTwo = this;
        
        var f:Function = function(combo:String):void
        {
          comboButton.addEventListener(Event.TRIGGERED, function():void
            {
              sharedData.combo = combo.substr(6);
              SaveGame.saveSpecial(sharedData.selected, {effect: sharedData.effect, combo: sharedData.combo});
              onMainComboMenu.dispatch(that);
            });
        }
        f(combos[i]);
        
      }
      
      addChild(sprite);
    }
    
    public function get sharedData():Object
    {
      return _sharedData;
    }
    
    public function set sharedData(value:Object):void
    {
      _sharedData = value;
    }
    
    public function get onMainComboMenu():ISignal
    {
      return _onMainComboMenu;
    }
    
    public function get onComboSelect():ISignal
    {
      return _onComboSelect;
    }
  
  }

}
