package engine
{
  import flash.media.StageVideo;
  import flash.media.Video;
  import flash.net.NetConnection;
  import flash.net.NetStream;
  import starling.core.Starling;
  
  /**
   * This plays Videos.
   * @author Roger Braun
   */
  public class VideoPlayer extends ManagedStage
  {
    
    public function VideoPlayer(args:Object)
    {
      var videoURI:String = args.videoURI;
      var video:Video = new Video(AssetRegistry.STAGE_WIDTH, AssetRegistry.STAGE_HEIGHT);
      var nc:NetConnection = new NetConnection();
      nc.connect(null);
      var ns:NetStream = new NetStream(nc);
      var client:Object = { };
      client.onCuePoint = function(infoObject:Object):void
      {
        trace("cuePoint");
      }
      client.onMetaData = function(infoObject:Object):void
      {
        trace("metaData");
      }
      ns.client = client;

      video.attachNetStream(ns);

      Starling.current.nativeOverlay.addChild(video);
      
      ns.play(videoURI);
    }
  
  }

}