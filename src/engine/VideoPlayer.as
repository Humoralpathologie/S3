package engine
{
  import flash.events.NetStatusEvent;
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
    
    public function VideoPlayer(args:Object)
    {
      var videoURI:String = args.videoURI;
      var video:Video = new Video(Starling.current.viewPort.width, Starling.current.viewPort.height);
      
      var nc:NetConnection = new NetConnection();
      nc.connect(null);
      
      var ns:NetStream = new NetStream(nc);
     
      var sv:StageVideo;
      
      if(Starling.current.nativeStage.stageVideos.length >= 1) {
        sv = Starling.current.nativeStage.stageVideos[0];
        sv.viewPort = new Rectangle(0, 0, Starling.current.viewPort.width, Starling.current.viewPort.height);
        sv.attachNetStream(ns);        
        Starling.current.stage3D.x = Starling.current.viewPort.width;      
      } else {
        video.attachNetStream(ns);
        Starling.current.nativeStage.addChild(video);
      }

      var client = { OnXMPData: function(obj:Object):void { },
      onMetaData: function(obj:Object):void { },
      onCuePoint: function(obj:Object):void { },
      onPlayStatus: function(obj:Object):void { trace(obj.code);
        if (obj.code == "NetStream.Play.Complete") {
          Starling.current.stage3D.x = 0;
          //Starling.current.stage3D.visible = true;
          ns.dispose();
          Starling.current.nativeStage.removeChild(video);
          video = null;
          nc = null;
          ns = null;
          sv = null;
          
          dispatchEventWith(SWITCHING, true, { stage: MainMenu } );
        }
      }};
      ns.client = client;
      
      ns.play(videoURI);
    }
  
  }

}