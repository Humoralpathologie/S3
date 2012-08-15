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
    private var _speed:int = 80;
    private var _textWidth:Number = 0;
    private var _bg:Quad;
    
    private const HINTS:Array = ["Pay attention to the combo scoring. Longer combos score big time!",
      
      "You finished the Story Mode? Excellent - go on then and learn new Combos in the Arcade Mode to earn even higher scores!",
      
      "You think you have seen it all? Try to get all gold medals & be in for a surprise!",
      
      "Use the radar to find the shortest way to the next egg!",
      
      "Beware the rotten eggs. Devour 5 of them for a shortcut to Snakehalla!",
      
      "The controls suck? Try out one of the other options in the settings menu.",
      
      "Feel free to experiment in the arcade mode. Many ways lead to the Highscore.",
      
      "Arcade Bonus Speedster: Perform at least 10 speed combos during a single round.",
      
      "Arcade Bonus The Hard Way: Play the whole round without decimating the rotten eggs.",
      
      "Arcade Bonus Big Chain: Pull off a chain of at least 10 eggs.",
      
      "There is a total of 12 hidden Arcade Bonuses..."
      
      ];
    
    public function NotificationScroller()
    {
      super();
      
      _bg = new Quad(Starling.current.stage.stageWidth, 80, Color.BLACK);
      _bg.alpha = 0.3;
      addChild(_bg);
      
      _text = new TextField(4000, 80, "", "kroeger 06_65", 50, Color.WHITE);
      _text.hAlign = HAlign.LEFT;
      addChild(_text);
      getNotifications();
    }
    
    private function getNotifications():void
    {
      var url:String = "https://www.scoreoid.com/api/getNotification";
      var request:URLRequest = new URLRequest(url);
      var requestVars:URLVariables = new URLVariables();
      request.data = requestVars;
      requestVars.api_key = "7bb1d7f5ac027ae81b6c42649fddc490b3eef755";
      requestVars.game_id = "5UIVQJJ3X";
      requestVars.response = "JSON"
      
      request.method = URLRequestMethod.POST;
      
      var urlLoader:URLLoader = new URLLoader();
      urlLoader = new URLLoader();
      urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
      urlLoader.addEventListener(Event.COMPLETE, notificationReceivedHandler);
      urlLoader.addEventListener(IOErrorEvent.IO_ERROR, notificationReceivedHandler); // Hackish.
      
      urlLoader.load(request);
    }
    
    private function notificationReceivedHandler(event:Event):void
    {
      try {
        var result:Object = JSON.parse(event.target.data);
        var notificationStr:String = result["notifications"]["game_notification"][0]["GameNotification"]["content"];
        setText(notificationStr);
      } catch (err) {
        // If anything goes wrong, just set one of the hints.
        setRandomHint();
      }
            
      Starling.juggler.add(this);

    }
    
    private function setRandomHint():void
    {
      setText(HINTS[Math.floor(Math.random() * HINTS.length)]);
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
        getNotifications();
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