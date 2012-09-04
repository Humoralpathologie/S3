package engine
{
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import starling.animation.IAnimatable;
  import starling.core.Starling;
  import starling.display.Quad;
  import starling.display.Sprite;
  import starling.text.TextField;
  import starling.utils.Color;
  import starling.utils.HAlign;
  import flash.net.*;
  import JSON;  
  
  /**
   * A simple way to scroll notifications around a screen.
   * @author Roger Braun
   */
  
  public class NotificationScroller extends Sprite implements IAnimatable
  {
    private var _text:TextField;
    private var _speed:int = 180;
    private var _textWidth:Number = 0;
    private var _bg:Quad;
    

    public function NotificationScroller()
    {
      super();
      
      _bg = new Quad(Starling.current.stage.stageWidth, 80, Color.BLACK);
      _bg.alpha = 0.3;
      addChild(_bg);
      
      _text = new TextField(4000, 80, "", "kroeger 06_65", 64, Color.WHITE);
      _text.hAlign = HAlign.LEFT;
      addChild(_text);
      AssetRegistry.mogade.getBroadcasts(notificationReceivedHandler);
    }
    
    private function notificationReceivedHandler(maybeArr:Object):void
    {
      var arr:Array;
      if (maybeArr is Array) {
        arr = maybeArr as Array;
      } else {
        arr = [];
      }
      
      if (arr.length > 0) {
        setText(arr[0].meta);
      } else {
        setRandomHint();
      }
 
      Starling.juggler.add(this);

    }
    
    private function setRandomHint():void
    {
      setText(AssetRegistry.Strings.HINTS[Math.floor(Math.random() * AssetRegistry.Strings.HINTS.length)]);
    }
    
    private function setText(text:String):void
    {
      _text.text = text;
      _textWidth = _text.textBounds.width;
      _text.x = Starling.current.stage.stageWidth;
    }
    
    /* INTERFACE starling.animation.IAnimatable */
    
    public function advanceTime(time:Number):void
    {
      _text.x -= _speed * time;
      if (_text.x <= -_textWidth)
      {
        Starling.juggler.remove(this);
        setRandomHint();
        Starling.juggler.add(this);
      }
    }
    
    override public function dispose():void
    {
      removeChild(_text, true);
      removeChild(_bg, true);
      super.dispose();
      Starling.juggler.remove(this);
    }
  
  }

}