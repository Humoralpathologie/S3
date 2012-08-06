package engine
{
    import starling.animation.IAnimatable;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.text.TextField;
    import starling.core.Starling;
    import starling.utils.Color;
    import starling.utils.HAlign;
  
  /**
   * A simple way to scroll notifications around a screen.
   * @author Roger Braun
   */
  public class NotificationScroller extends Sprite implements IAnimatable
  {
    private var _text:TextField;
    private var _speed:int = 40;
    private var _textWidth:int = 0;
    private var _bg:Quad;
    
    public function NotificationScroller()
    {
      super();
      
      _bg = new Quad(Starling.current.stage.stageWidth, 80, Color.BLACK);
      _bg.alpha = 0.3;
      addChild(_bg);
      
      _text = new TextField(4000, 80, "", "kroeger 06_65", 50, Color.WHITE);
      _text.hAlign = HAlign.LEFT;
      addChild(_text);
      setText("Just a test");
    }
    
    private function setText(text:String):void {
      _text.text = text;
      _textWidth = _text.textBounds.width;
      _text.x = Starling.current.stage.stageWidth;
    }
    
    /* INTERFACE starling.animation.IAnimatable */
    
    public function advanceTime(time:Number):void 
    {
      _text.x -= _speed * time;
      if (_text.x <= -_textWidth) {
        _text.x = Starling.current.stage.stageWidth;
      }
    }
    
    override public function dispose():void {
      removeChild(_text);
      removeChild(_bg);
      _bg.dispose();
      _text.dispose();
      _text = null;
      super.dispose();
    }
  
  }

}