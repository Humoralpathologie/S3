package engine
{
  
  /**
   * A Class for working with the Mogade Leaderboard API.
   * https://mogade.com
   * @author Roger Braun
   */
  import com.hurlant.crypto.hash.SHA1;
  import flash.events.Event;
  import flash.net.URLLoader;
  import flash.net.URLLoaderDataFormat;
  import flash.net.URLRequest;
  import flash.net.URLVariables;
  import flash.net.URLRequestMethod;
  import flash.utils.ByteArray;
  import com.hurlant.util.Hex;
  
  public class Mogade
  {
    
    private var _key:String;
    private var _secret:String;
    private static const BASE_URI:String = "http://api2.mogade.com/api/gamma/";
    
    public function Mogade(key:String, secret:String)
    {
      _key = key;
      _secret = secret;
    }
    
    // Signs a request and returns the same request object, just signed.
    public function signRequest(request:Object):Object {
      var sortArray:Array = [];
      var hashedStringArray:Array = [];
      var hashedString:String;
      var hashedByteArray:ByteArray = new ByteArray();
      var signature:String;
      var sha1:SHA1 = new SHA1();
            
      for (var key:String in request) {
        sortArray.push( { key:key, value: request[key] } );
      }
      
      sortArray.sortOn("key");
      
      for each(var obj:Object in sortArray) {
        hashedStringArray.push(obj.key);
        hashedStringArray.push(obj.value);
      }
      
      hashedStringArray.push(_secret);
      
      hashedString = hashedStringArray.join("|");
      hashedByteArray.writeUTFBytes(hashedString);
      signature = Hex.fromArray(sha1.hash(hashedByteArray));
      
      request.sig = signature;

      return request;
    }
    
    private function tracer(obj:Object):void {
      trace(obj);
    }
    
    public function submitScore(userName:String, userKey:String, leaderboard:String, points:Number, callback:Function = null) {
      var request:Object = {};
      request.username = userName;
      request.userkey = userKey;
      request.lid = leaderboard;
      request.points = points;
      request.key = _key;
      
      callback ||= tracer;

      
      doRequest("scores", request, callback, "POST");
    }
    
    public function getScores(leaderboard:String, scope:int, callback:Function = null, additionalParameters:Object = null) {
      var request:Object = { };
      request.key = _key;
      request.lid = leaderboard;
      request.scope = scope;
      
      callback ||= tracer;
      
      doRequest("scores", request, callback);
    }
    
    private function doRequest(endpoint:String, request:Object, callback:Function, method:String = "GET"):void {
      var urlRequest:URLRequest;
      var urlRequestVars:URLVariables;
      var urlLoader:URLLoader;
      var onComplete:Function;
      
      onComplete = function(evt:Event) {
        trace(evt.target.data);
        callback(JSON.parse(evt.target.data));
      }
      
      urlRequest = new URLRequest(BASE_URI + endpoint);
      urlRequestVars = new URLVariables();
      urlRequest.data = urlRequestVars;
      urlRequest.method = method;
      
      urlLoader = new URLLoader();
      urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
      urlLoader.addEventListener(Event.COMPLETE, onComplete);
      
      signRequest(request);
      
      for (var key:String in request) {
        urlRequestVars[key] = request[key];
      }
       
      urlLoader.load(urlRequest);
      
    }
  
  }

}