package engine
{
  import flash.display.Bitmap;
  import flash.events.Event;
  import flash.events.NetStatusEvent;
  import flash.media.Video;
  import starling.display.Sprite;
  import Menu.MainMenu;
  import starling.core.Starling;
  import starling.events.EnterFrameEvent;
  import Level.Level1;
  import flash.system.System;
  import flash.net.NetStream;
  import flash.net.NetConnection;
  import flash.media.Video;
  
  /**
   * ...
   * @author
   */
  public class StageManager extends Sprite
  {
    
    private static var _currentSprite:Sprite;
    private static var _manager:StageManager;
    private static var _loadingScreen:Bitmap;
    private static var _frame:int = 0;
    private static var _nextStage:Class;
    private static var _argument:*;
    private static var _video:Video;
    
    public function StageManager()
    {
      _manager = this;
      AssetRegistry.init();
      _loadingScreen = new AssetRegistry.LoadingScreenPNG;
      
      switchStage(MainMenu);
    }
    
    public static function switchStage(newStage:Class, argument:* = null, video:String = null):void
    {
      _argument = argument;
      _loadingScreen.y = Starling.current.viewPort.y;
      _loadingScreen.x = Starling.current.viewPort.x;
      _loadingScreen.scaleX = _loadingScreen.scaleY = AssetRegistry.SCALE;
      Starling.current.nativeStage.addChild(_loadingScreen);
      
      if (video)
      {
        var nc:NetConnection;
        var ns:NetStream;
        nc = new NetConnection();
        nc.connect(null);
        ns = new NetStream(nc);
        ns.client = {onMetaData: function():void
          {
          }};
        _video = new Video();
        Starling.current.nativeStage.addChild(_video);
        _video.attachNetStream(ns);
        //addChild(video);
        _video.width = Starling.current.stage.stageWidth;
        _video.height = Starling.current.stage.stageHeight;
        ns.play(video);
        Starling.current.stop();
        
        ns.addEventListener(NetStatusEvent.NET_STATUS, function(event:NetStatusEvent):void {
          if (event.info.code == "NetStream.Play.Stop") {
            Starling.current.nativeStage.removeChild(_video);
            Starling.current.start();
          }
        });
      }
      
      _nextStage = newStage;
      
      _manager.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
    }
    
    private static function onEnterFrame(event:EnterFrameEvent):void
    {
      _frame++;
      if (_frame == 2)
      {
        if (_currentSprite != null)
        {
          _manager.removeChild(_currentSprite);
          Starling.juggler.purge();
          _currentSprite.dispose();
          _currentSprite = null;
          System.gc(); // clean up;
          System.gc(); // clean up;
          
        }
        _currentSprite = _argument ? new _nextStage(_argument) : new _nextStage();
        Starling.juggler.paused = false;
        _manager.addChild(_currentSprite);
      }
      if (_frame == 3)
      {
        Starling.current.nativeStage.removeChild(_loadingScreen);
        _manager.removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
        _frame = 0;
      }
    }
  
  }

}