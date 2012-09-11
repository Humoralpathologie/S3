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
  import starling.events.TouchEvent;
  import starling.events.Touch;
  import starling.events.TouchPhase;
  import starling.text.TextField;
  import starling.utils.Color;
  import org.osflash.signals.ISignal;
  import org.osflash.signals.Signal;
  import engine.SaveGame;
  import org.josht.starling.foxhole.controls.Scroller;
  import starling.utils.HAlign;
  import starling.utils.VAlign;
  import org.josht.starling.foxhole.controls.ScrollBar;
  import starling.core.Starling;
  
  
  /**
   * ...
   * @author
   */
  public class NormalCombos extends Screen
  {
    protected var _onNormalCombos:Signal = new Signal(NormalCombos);
    protected var _sharedData:Object = { };
    protected var _scroller:Scroller;
    protected var _scrollable:Sprite;
	  protected var _normalComboHeading:TextField;
    
    public function NormalCombos()
    {
      super();
    }
    
    override protected function initialize():void {

      _scrollable = new Sprite();
	  
      var greybox:Quad = new Quad(710, 450, Color.BLACK);
      greybox.alpha = 0.3;
      greybox.x = 65 + 60;
      greybox.y = 40 + 30;
      
      addChild(greybox); 
	  
	    _normalComboHeading = new TextField(greybox.width, 60, AssetRegistry.Strings.NORMALCOMBO, "kroeger 06_65", 60, Color.WHITE);
      _normalComboHeading.x = (Starling.current.stage.stageWidth - _normalComboHeading.width) / 2;
      _normalComboHeading.y = 10;
      addChild(_normalComboHeading);
	  
	    var that:NormalCombos = this;
	    var xButton:Image = new Image(AssetRegistry.Alpha_1_Atlas.getTexture("x"));

      xButton.x = 860;
      xButton.y = 30;

      var exit:Quad = new Quad(140, 250, 0xffffff);
      exit.alpha = 0;
      exit.x = Starling.current.stage.stageWidth - exit.width;
      exit.y = 30;
      exit.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void {
         var touch:Touch = event.getTouch(exit, TouchPhase.ENDED);
          if (touch)
          {
            onNormalCombos.dispatch(that);
          }
      });
    
      addChild(xButton);
      addChild(exit);
      
      _scroller = new Scroller();
      _scroller.setSize(greybox.width, greybox.height);
      _scroller.x = greybox.x;
      _scroller.y = greybox.y;
      _scroller.viewPort = _scrollable;
      
      addChild(_scroller);
	  
	     
      var speed:Image = new Image(AssetRegistry.Alpha_1_Atlas.getTexture("combo-speed"));
      speed.x = 40;
      speed.y = 40;
      _scrollable.addChild(speed);
      
      
      var speedText:TextField = new TextField(greybox.width - 120 - speed.width, speed.height * 1.5, AssetRegistry.Strings.SPEEDDESC, "kroeger 06_65", 30, Color.WHITE);
      speedText.hAlign = HAlign.LEFT;
      speedText.vAlign = VAlign.TOP;
      speedText.x = speed.x + speed.width + 40;
      speedText.y = speed.y;
      _scrollable.addChild(speedText);
      
      var secondCombo:Image;
      var secondComboText:TextField;
      if (SaveGame.endless){
        secondCombo = new Image(AssetRegistry.Alpha_1_Atlas.getTexture("combo-time"));
        secondComboText = new TextField(speedText.width, speedText.height, AssetRegistry.Strings.TIMEDESC, "kroeger 06_65", 30, Color.WHITE);
      } else {
        secondCombo = new Image(AssetRegistry.Alpha_1_Atlas.getTexture("combo-slower"));
        secondComboText = new TextField(speedText.width, speedText.height, AssetRegistry.Strings.SLOWERDESC, "kroeger 06_65", 30, Color.WHITE);
      }
      secondCombo.x = speed.x;
      secondCombo.y = speedText.y + speedText.height + 20;

      _scrollable.addChild(secondCombo); 
   
  
      secondComboText.hAlign = HAlign.LEFT;
      secondComboText.vAlign = VAlign.TOP;
      secondComboText.x = speedText.x;
      secondComboText.y = secondCombo.y;
      
      _scrollable.addChild(secondComboText);
      
      var norotten:Image = new Image(AssetRegistry.Alpha_1_Atlas.getTexture("combo-rotteneggs"));
      norotten.x = speed.x;
      norotten.y = secondComboText.y + secondComboText.height + 20;
     
      _scrollable.addChild(norotten);      
      
      var norottenText:TextField = new TextField(speedText.width, speedText.height, AssetRegistry.Strings.NOROTTENDESC, "kroeger 06_65", 30, Color.WHITE);
      norottenText.hAlign = HAlign.LEFT;
      norottenText.vAlign = VAlign.TOP;
      norottenText.x = speedText.x;
      norottenText.y = norotten.y;
      _scrollable.addChild(norottenText);
      
      
      _scroller.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
      
    }
	

    public function get onNormalCombos():Signal 
    {
        return _onNormalCombos;
    }
    
    public function get sharedData():Object 
    {
        return _sharedData;
    }
    
    public function set sharedData(value:Object):void 
    {
        _sharedData = value;
    }
    
  }

}
