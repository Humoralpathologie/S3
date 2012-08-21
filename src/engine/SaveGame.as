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
      if (_sharedObject.data.controlType && (_sharedObject.data.controlType == 3 || _sharedObject.data.controlType == 4)) {
        controlType = 2;
      } 
      return _sharedObject.data.controlType || 2;
    }
    
    public static function get loggedIn():Boolean {
      return userName != "anonymous";
    }
    
    public static function set controlType(value:int):void {
      _sharedObject.data.controlType = value;
    }
    
	public static function set difficulty(value:int):void {
	  _sharedObject.data.difficulty = value;
	}
	
	public static function get difficulty():int {
	  if (!_sharedObject.data.difficulty) {
		_sharedObject.data.difficulty = 1;
	  }
	  return _sharedObject.data.difficulty;
	}
	
	public static function set arcadeModi(value:Boolean):void {
	  _sharedObject.data.arcadeModi = value;
	}
	
	public static function get arcadeModi():Boolean {
	  if (!_sharedObject.data.arcadeModi) {
		_sharedObject.data.arcadeModi = false;
	  }
	  return _sharedObject.data.arcadeModi;
	}
	
	public static function set language(value:int):void {
	  _sharedObject.data.language = value;
	}
	
	public static function get language():int {
	  if (!_sharedObject.data.language) {
		_sharedObject.data.language = 1;
	  }
	  return _sharedObject.data.language;
	}
	
	public static function set secondArcade(value:Boolean):void {
	  _sharedObject.data.secondArcade = value;
	}
	
	public static function get secondArcade():Boolean {
	  if (!_sharedObject.data.secondArcade) {
		_sharedObject.data.secondArcade = false;
	  }
	  return _sharedObject.data.secondArcade;
	}
    public static function get startSpeed():int {
      return _sharedObject.data.startSpeed;
    }
    
    public static function get noGreenArcade():Boolean {
      return _sharedObject.data.noGreenArcade || false ;
    }
    
    public static function set noGreenArcade(value:Boolean):void {
      _sharedObject.data.noGreenArcade = value;
    }
    
    public static function set startSpeed(value:int):void {
	    _sharedObject.data.startSpeed = value;
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
    
    public static function saveSpecial(slot:int, special:Object):void {
      var i:String;
      for (i in specials) {
        if (specials[i] && (specials[i].effect == special.effect)) {
          specials[i] = null;
        }
      }
      specials[slot] = special;
    }
    
    public static function get specials():Object {
      if (!_sharedObject.data.specials) {
        specials = {}
      }
      return _sharedObject.data.specials;
    }
    
    public static function set specials(val:Object):void {
      _sharedObject.data.specials = val;
      _sharedObject.flush();
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
      requestVars.score = _sharedObject.data.levels[level].score; //fullScore();
       
      request.method = URLRequestMethod.POST;
   
      var urlLoader:URLLoader = new URLLoader();
      urlLoader = new URLLoader();
      urlLoader.dataFormat = URLLoaderDataFormat.TEXT;

      urlLoader.load(request);
    }
  }
}
