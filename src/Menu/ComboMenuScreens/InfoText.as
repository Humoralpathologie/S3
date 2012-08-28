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
  public class InfoText extends Screen
  {
    protected var _onInfoText:Signal = new Signal(InfoText);
    protected var _sharedData:Object = { };
    protected var _scroller:Scroller;
    protected var _scrollable:Sprite;
	  protected var _infoHeading:TextField;
    protected var _text:TextField;
    
    public function InfoText()
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
	  
	    _infoHeading = new TextField(greybox.width, 60, AssetRegistry.Strings.ARCADEINFOHEADING, "kroeger 06_65", 60, Color.WHITE);
      _infoHeading.x = (Starling.current.stage.stageWidth - _infoHeading.width) / 2;
      _infoHeading.y = 10;
      addChild(_infoHeading);
      
      _text = new TextField(greybox.width - 40, greybox.height + 340, AssetRegistry.Strings.ARCADEINFO, "kroeger 06_65", 40, Color.WHITE);
			_text.x = 20;
      
	  
	    var that:InfoText = this;
	    var xButton:Image = new Image(AssetRegistry.MenuAtlasAlpha.getTexture("x"));

      //xButton.scaleX = xButton.scaleY = 1.5;
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
            onInfoText.dispatch(that);
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
	    _scrollable.addChild(_text);
	  
      
     
      
      
      _scroller.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
      
    }
	

    public function get onInfoText():Signal 
    {
        return _onInfoText;
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
