package engine
{
  import flash.geom.*;
  import flash.net.*;
  import flash.events.Event;
  import starling.utils.HAlign;
  
  /**
   * Utilities.
   * @author Roger Braun
   */
  public class Utils
  {
    
    static public function createOrEditPlayer(id:String, name:String) {
      editPlayer(id, name, createPlayer);
    }
    
    static public function createPlayer(id:String, name:String) {
      
    }
    
    static public function editPlayer(id:String, name:String, alternate:Function) {
      var url:String = "https://www.scoreoid.com/api/editPlayer";
      var request:URLRequest = new URLRequest(url);
      var requestVars:URLVariables = new URLVariables();
      request.data = requestVars;      
      requestVars.api_key = AssetRegistry.API_KEY;
      requestVars.game_id = AssetRegistry.GAME_ID;     
      
      
    }
    
    public static function scoreoidRequest(url:String, data:Object, onSuccess:Function, onError:Function = null) {
      var request:URLRequest = new URLRequest(url);
      var requestVars:URLVariables = new URLVariables();
      request.data = requestVars;
      requestVars.api_key = AssetRegistry.API_KEY;
      requestVars.game_id = AssetRegistry.GAME_ID;
      requestVars.response = "JSON"      
      
      for (var attr:String in data) {
       requestVars[attr] = data[attr];
      }

      request.method = URLRequestMethod.POST;
      
      var loaderCompleteHandler:Function = function(event:flash.events.Event):void
      {

        var result:Object = JSON.parse(event.target.data);
        if (result.error)
        {
          if (onError) {
            onError(null);
          } else {
            onSuccess(null);
          }
          return;
        }
        
        onSuccess(result);
      }      

      var urlLoader:URLLoader = new URLLoader();
      urlLoader = new URLLoader();
      urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
      urlLoader.addEventListener(flash.events.Event.COMPLETE, loaderCompleteHandler);
      
      urlLoader.load(request);      
    }
    
    static public function getLeaderboard(level:int, callback:Function) {
      
      var requestVars:Object = { };
      requestVars.order_by = "score";
      requestVars.order = "desc";
      requestVars.limit = 10;
      requestVars.difficulty = level;
      
      var successHandler:Function = function(result:*) {
        var data:Array = result as Array;
        callback(data);
      }
      
      var errorHandler:Function = function(result:*) {
        callback([]);
      }
      
      scoreoidRequest("https://www.scoreoid.com/api/getBestScores", requestVars, successHandler, errorHandler);
    }
    
    // Straight port from http://lassieadventurestudio.wordpress.com/2012/03/20/polygon-hit-test/
    static public function polygonHitTest(p:Point, poly:Array):Boolean
    {
      var sides = poly.length, origin = new Point(0, p.y), hits = 0, s1, s2, i;
      
      // Test intersection of an external ray against each polygon side.
      for (i = 0; i < sides; i++)
      {
        s1 = poly[i];
        s2 = poly[(i + 1) % sides];
        origin.x = Math.min(origin.x, Math.min(s1.x, s2.x) - 1);
        hits += (intersection(origin, p, s1, s2) ? 1 : 0);
      }
      
      // Return true if an odd number of hits were found.
      return hits % 2 > 0;
    }
    
// Tests for counter-clockwise winding among three points.
// Specifically written for an intersection test:
// Uses ">=" (rather than ">") to cast equal points as valid CCW components.
    private static function ccw(x:Point, y:Point, z:Point):Boolean
    {
      return (z.y - x.y) * (y.x - x.x) >= (y.y - x.y) * (z.x - x.x);
    }
    
// Tests for intersection between line segments AB and CD.
    private static function intersection(a:Point, b:Point, c:Point, d:Point):Boolean
    {
      return ccw(a, c, d) !== ccw(b, c, d) && ccw(a, b, c) !== ccw(a, b, d);
    }
    
    public function Utils()
    {
    
    }
  
  }

}