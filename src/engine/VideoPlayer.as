package engine
{
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.events.NetStatusEvent;
  import flash.events.TouchEvent;
  import flash.geom.Rectangle;
  import flash.media.StageVideo;
  import flash.media.Video;
  import flash.net.NetConnection;
  import flash.net.NetStream;
  import starling.core.Starling;
  import Menu.MainMenu;
  
  /**
   * This plays Videos.
   * @author Roger Braun
   */
  public class VideoPlayer extends ManagedStage
  {
    private var sv:StageVideo;
    private var video:Video;
    private var nc:NetConnection;
    private var ns:NetStream;
    private var ending:Boolean = false;
    private var nextStage:Class;
    private var args:Object;
    
    public function VideoPlayer(args:Object)
    {
      var videoURI:String = args.videoURI;
      
      nextStage = args.stage;
      this.args = args.args;
      
      video = new Video(Starling.current.viewPort.width, Starling.current.viewPort.height);
      
      nc = new NetConnection();
      nc.connect(null);
      
      ns = new NetStream(nc);
      
      Starling.current.nativeStage.addEventListener(TouchEvent.TOUCH_TAP, stopVideo);
      Starling.current.nativeStage.addEventListener(MouseEvent.CLICK, stopVideo);
      
      if (Starling.current.nativeStage.stageVideos.length >= 1)
      {
        sv = Starling.current.nativeStage.stageVideos[0];
        sv.viewPort = new Rectangle(0, 0, Starling.current.viewPort.width, Starling.current.viewPort.height);
        sv.attachNetStream(ns);
        Starling.current.stage3D.x = Starling.current.viewPort.width;
      }
      else
      {
        video.attachNetStream(ns);
        Starling.current.nativeStage.addChild(video);
      }
      
      var client = {OnXMPData: function(obj:Object):void
        {
        }, onMetaData: function(obj:Object):void
        {
        }, onCuePoint: function(obj:Object):void
        {
        }, onPlayStatus: function(obj:Object):void
        {
          trace(obj.code);
          if (obj.code == "NetStream.Play.Complete")
          {
            stopVideoHelper();
          }
        }};
      ns.client = client;
      
      ns.play(videoURI);
    }
    
    private function stopVideo(evt:Event):void
    {
      trace("Touched");
      stopVideoHelper();
    }
    
    private function stopVideoHelper():void
    {
      if (ending) {
        return;
      }
      ending = true;
      dispatchEventWith(SWITCHING, true, {stage: nextStage, args:args});
    }
    
    override public function dispose():void {
      super.dispose();
      Starling.current.stage3D.x = 0;
      //Starling.current.stage3D.visible = true;
      ns.dispose();
      if (video.stage)
      {
        Starling.current.nativeStage.removeChild(video);
      }
      video = null;
      nc = null;
      ns = null;
      sv = null;      
      Starling.current.nativeStage.removeEventListener(TouchEvent.TOUCH_TAP, stopVideo);
      Starling.current.nativeStage.removeEventListener(MouseEvent.CLICK, stopVideo);
    }
  
  }

}