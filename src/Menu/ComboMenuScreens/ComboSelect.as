package Menu.ComboMenuScreens
{
  import org.josht.starling.display.Image;
  import org.josht.starling.foxhole.controls.Screen;
  import engine.AssetRegistry;
  import starling.display.Button;
  import starling.display.DisplayObject;
  import starling.display.Quad;
  import starling.display.Sprite;
  import starling.events.Event;
  import starling.text.TextField;
  import starling.utils.Color;
  import org.osflash.signals.ISignal;
  import org.osflash.signals.Signal;
  import engine.SaveGame;
  
  /**
   * ...
   * @author
   */
  public class ComboSelect extends Screen
  {
    protected var _onMainComboMenu:Signal = new Signal(ComboSelect);
    protected var _onComboSelectTwo:Signal = new Signal(ComboSelect);
    protected var _sharedData:Object = {}
    
    public function ComboSelect()
    {
      super();
    }
    
    override protected function initialize():void {

      var greybox:Quad = new Quad(710, 450, Color.BLACK);
      greybox.alpha = 0.3;
      greybox.x = 65 + 60;
      greybox.y = 40 + 30;
      
      addChild(greybox);      
      
      var boost:Button = new Button(AssetRegistry.MenuAtlas.getTexture("combo-boost"));
      boost.x = 156;
      boost.y = 152;
      addChild(boost);
      
      var boostText:Image = new Image(AssetRegistry.MenuAtlas.getTexture("Text-Boost"));
      boostText.x = 263;
      boostText.y = 154;
      addChild(boostText);
      
      var brake:Button = new Button(AssetRegistry.MenuAtlas.getTexture("combo-brake"));
      brake.x = 156;
      brake.y = 285,
      addChild(brake);
      
      var brakeText:Image = new Image(AssetRegistry.MenuAtlas.getTexture("Text-Brake"));
      brakeText.x = 264;
      brakeText.y = 299;
      addChild(brakeText);
      
      var time:Button = new Button(AssetRegistry.MenuAtlas.getTexture("combo-leveluptime"));
      time.x = 156;
      time.y = 389;
      addChild(time);
      
      var timeText:Image = new Image(AssetRegistry.MenuAtlas.getTexture("Text-BonusTimePlus"));
      timeText.x = 263;
      timeText.y = 404;
      addChild(timeText);
      
      var that:ComboSelect = this;
      
      boost.addEventListener(Event.TRIGGERED, function(event:Event):void {
        sharedData.effect = "combo-boost";
        SaveGame.saveSpecial(sharedData.selected, { effect: sharedData.effect, combo: null } );
        onMainComboMenu.dispatch(that);
      });
      
      time.addEventListener(Event.TRIGGERED, function(event:Event):void {
        sharedData.effect = "combo-leveluptime";
        showComboOptions(timeText);
      });
      
      brake.addEventListener(Event.TRIGGERED, function(event:Event):void {
        sharedData.effect = "combo-brake";
        showComboOptions(brakeText);
      });
     
      var next:Button = new Button(AssetRegistry.MenuAtlas.getTexture("right-arrow"));
      next.x = greybox.x + greybox.width - 100;
      next.y = greybox.y + greybox.height - 100;
      next.scaleX = next.scaleY = 2;
      addChild(next);
      
      next.addEventListener(Event.TRIGGERED, function(event:Event):void {
        onComboSelectTwo.dispatch(that);
      });
    }
    
    private function showComboOptions(reference:DisplayObject):void {
      var combos:Array = [
        "combo_abcb",
        "combo_acba",
        "combo_bccb"
      ];
      
      var sprite:Sprite = new Sprite();
      
      for (var i:int = 0; i < combos.length; i++) {
        var comboButton:Button = new Button(AssetRegistry.MenuAtlas.getTexture(combos[i]));
        comboButton.y = reference.y;
        comboButton.x = reference.x + 50 + i * 150;
        sprite.addChild(comboButton);
        
        var that:ComboSelect = this;
        
        var f:Function = function(combo:String):void {
          comboButton.addEventListener(Event.TRIGGERED, function():void {
            sharedData.combo = combo.substr(6);
            SaveGame.saveSpecial(sharedData.selected, { effect:sharedData.effect, combo:sharedData.combo});
            onMainComboMenu.dispatch(that);
          });
        }
        f(combos[i]);
        
      }
      
      addChild(sprite);
    }
    
    public function get onMainComboMenu():Signal 
    {
        return _onMainComboMenu;
    }
    
    public function get sharedData():Object 
    {
        return _sharedData;
    }
    
    public function set sharedData(value:Object):void 
    {
        _sharedData = value;
    }
    
    public function get onComboSelectTwo():Signal 
    {
        return _onComboSelectTwo;
    }
  
  }

}
