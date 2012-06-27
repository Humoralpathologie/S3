package engine {

  import flash.net.*;
   

  public class SaveGame {
    private static var _sharedObject:SharedObject = null;
    
    public static function load():void {
      _sharedObject = SharedObject.getLocal('snakeSaveData');
      if(!_sharedObject.data.initialized) {
        initializeData(); 
      }
    } 
    
    public static function get controlType():int {
      return _sharedObject.data.controlType || 1;
    }
    
    public static function set controlType(value:int):void {
      _sharedObject.data.controlType = value;
    }
  
    public static function initializeData():void {
      _sharedObject.data.levels = {};
      for(var i:int = 1; i <= 100; i++) {
        _sharedObject.data.levels[i] = {};
        _sharedObject.data.levels[i].score = 0;
        _sharedObject.data.levels[i].unlocked = (i == 1 ? true : false);
      } 
      _sharedObject.data.initialized = true;
      _sharedObject.flush();
    }

    public static function unlockLevels():void {
      for(var i:int = 1; i <= 100; i++) {
        _sharedObject.data.levels[i].unlocked = true;
      }
      _sharedObject.flush();
    }

    public static function get unlockedLevels():Array{
      var unlocked:Array = [];
      for(var i:int = 1; i <= 100; i++) {
        if(_sharedObject.data.levels[i].unlocked == true){
          unlocked.push(i);
        }
      }
      return unlocked;
    }

    public static function levelUnlocked(n:Number):Boolean {
      return _sharedObject.data.levels[n].unlocked;
    }

    public static function unlockLevel(n:Number):void {
      trace("Unlocking " + n);
      _sharedObject.data.levels[n].unlocked = true;
      _sharedObject.flush();
    } 

    public static function saveScore(n:Number, score:Number):void {
      _sharedObject.data.levels[n].score = score;
      _sharedObject.flush();
      publishScore(n);
    }
    
    public static function saveSpecial(special:Array):void {
      _sharedObject.data.special = special;
      _sharedObject.flush();
    }
    
    public static function getSpecial():Array {
      if (_sharedObject.data.special != null) {
        return _sharedObject.data.special;
      } else {
        return [];
      }
    }

    public static function fullScore():Number {
      var n:Number = 0;
      for(var i:int = 1; i <= 100; i++) {
        if(_sharedObject.data.levels[i].unlocked == true){
          n += _sharedObject.data.levels[i].score;
        }
      }
      return n; 
    }
    
    public static function get userName():String {
      return _sharedObject.data.user ? _sharedObject.data.user : "anonymous"; 
    }
    
    public static function set userName(value:String):void {
      _sharedObject.data.user = value;
    }

    private static function publishScore(level:int = 1):void {
      var user:String = userName;
      var url:String = "https://www.scoreoid.com/api/createScore";
      var request:URLRequest = new URLRequest(url);
      var requestVars:URLVariables = new URLVariables();
      request.data = requestVars;
      requestVars.api_key = "7bb1d7f5ac027ae81b6c42649fddc490b3eef755";
      requestVars.game_id = "5UIVQJJ3X";
      requestVars.response = "XML"
      requestVars.difficulty = level;
      requestVars.username = user;
      requestVars.score = _sharedObject.data.levels[level].score //fullScore();
       
      request.method = URLRequestMethod.POST;
   
      var urlLoader:URLLoader = new URLLoader();
      urlLoader = new URLLoader();
      urlLoader.dataFormat = URLLoaderDataFormat.TEXT;

      urlLoader.load(request);
    }
  }
}
