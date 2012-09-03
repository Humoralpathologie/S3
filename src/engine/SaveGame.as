package engine
{
  
  import flash.net.*;
  import engine.Utils;
  import com.laiyonghao.Uuid;
  
  public class SaveGame
  {
    private static var _sharedObject:SharedObject = null;
    
    public static function load():void
    {
      _sharedObject = SharedObject.getLocal('snakeSaveData');
      if (!_sharedObject.data.guid) {
        // Should be unique enough.
        var uuid:Uuid = new Uuid();
       _sharedObject.data.guid = uuid.toString();
      }
      if (!_sharedObject.data.personalScores) {
        _sharedObject.data.personalScores = { };
      }
      if (!_sharedObject.data.savedScores) {
        _sharedObject.data.savedScores = [];
      }
      if (!_sharedObject.data.initialized)
      {
        initializeData();
      }
    }
    
    public static function get savedScores():Array {
      return _sharedObject.data.savedScores;
    }
    
    public static function get controlType():int
    {
      if (_sharedObject.data.controlType && (_sharedObject.data.controlType == 3 || _sharedObject.data.controlType == 4))
      {
        controlType = 2;
      }
      return _sharedObject.data.controlType || 2;
    }
    
    public static function get loggedIn():Boolean
    {
      return userName != "anonymous";
    }
    
    public static function set controlType(value:int):void
    {
      _sharedObject.data.controlType = value;
    }
    
    public static function set difficulty(value:int):void
    {
      _sharedObject.data.difficulty = value;
    }
    
    public static function get difficulty():int
    {
      if (!_sharedObject.data.difficulty)
      {
        _sharedObject.data.difficulty = 1;
      }
      return _sharedObject.data.difficulty;
    }
    
    public static function set endless(value:Boolean):void
    {
      _sharedObject.data.endless = value;
    }
    
    public static function get endless():Boolean
    {
      if (!_sharedObject.data.endless)
      {
        _sharedObject.data.endless = false;
      }
      return _sharedObject.data.endless;
    }
    
    public static function set hasFinishedGame(value:Boolean):void
    {
      _sharedObject.data.hasFinishedGame = value;
    }
    
    public static function get hasFinishedGame():Boolean
    {
      if (!_sharedObject.data.hasFinishedGame)
      {
        _sharedObject.data.hasFinishedGame = false;
      }
      return _sharedObject.data.hasFinishedGame;
    }
    
    public static function set language(value:int):void
    {
      _sharedObject.data.language = value;
    }
    
    public static function get language():int
    {
      if (!_sharedObject.data.language)
      {
        _sharedObject.data.language = 1;
      }
      return _sharedObject.data.language;
    }
    
    public static function set secondArcade(value:Boolean):void
    {
      _sharedObject.data.secondArcade = value;
    }
    
    public static function get secondArcade():Boolean
    {
      if (!_sharedObject.data.secondArcade)
      {
        _sharedObject.data.secondArcade = false;
      }
      return _sharedObject.data.secondArcade;
    }
    
    public static function set isArcade(value:Boolean):void
    {
      _sharedObject.data.isArcade = value;
    }
    
    public static function get isArcade():Boolean
    {
      if (!_sharedObject.data.isArcade)
      {
        _sharedObject.data.isArcade = false;
      }
      return _sharedObject.data.isArcade;
    }
	
	public static function set isSettingsScreen(value:Boolean):void
    {
      _sharedObject.data.isSettingsScreen = value;
    }
    
    public static function get isSettingsScreen():Boolean
    {
      if (!_sharedObject.data.isSettingsScreen)
      {
        _sharedObject.data.isSettingsScreen = false;
      }
      return _sharedObject.data.isSettingsScreen;
    }
    
    public static function get startSpeed():int
    {
      return _sharedObject.data.startSpeed;
    }
    
    public static function get noGreenArcade():Boolean
    {
      return _sharedObject.data.noGreenArcade || false;
    }
    
    public static function set noGreenArcade(value:Boolean):void
    {
      _sharedObject.data.noGreenArcade = value;
    }
    
    public static function set startSpeed(value:int):void
    {
      _sharedObject.data.startSpeed = value;
    }
    
    public static function get levelName():String
    {
      return _sharedObject.data.levelName;
    }
    
    public static function set levelName(value:String):void
    {
      _sharedObject.data.levelName = value;
    }
    
    public static function initializeData():void
    {
      _sharedObject.data.casualMedals = [];
      _sharedObject.data.competetiveMedals = [];
      _sharedObject.data.levels = {};
      for (var i:int = 1; i <= 100; i++)
      {
        _sharedObject.data.levels[i] = {};
        _sharedObject.data.levels[i].score = 0;
        _sharedObject.data.levels[i].unlocked = (i == 1 ? true : false);
      }
      _sharedObject.data.initialized = true;
      _sharedObject.flush();
    }
    
    public static function unlockLevels():void
    {
      for (var i:int = 1; i <= 100; i++)
      {
        _sharedObject.data.levels[i].unlocked = true;
      }
      _sharedObject.flush();
    }
    
    public static function get unlockedLevels():Array
    {
      var unlocked:Array = [];
      for (var i:int = 1; i <= 100; i++)
      {
        if (_sharedObject.data.levels[i].unlocked == true)
        {
          unlocked.push(i);
        }
      }
      return unlocked;
    }
    
    public static function get medals():Array
    {
      if (difficulty == 1) {
        return _sharedObject.data.casualMedals;
      } else {
        return _sharedObject.data.competetiveMedals;
      }
      
    }
    
    public static function storeMedals(levelNumber:int, medal:int):void {
      if (difficulty == 1) {
        _sharedObject.data.casualMedals[levelNumber - 1] = medal;
      } else {
        _sharedObject.data.competetiveMedals[levelNumber - 1] = medal;
      }
    }
    
    public static function levelUnlocked(n:Number):Boolean
    {
      return _sharedObject.data.levels[n].unlocked;
    }
    
    public static function unlockLevel(n:Number):void
    {
      trace("Unlocking " + n);
      _sharedObject.data.levels[n].unlocked = true;
      _sharedObject.flush();
    }
    
    public static function saveScore(n:Number, score:Number):void
    {
      _sharedObject.data.levels[n].score = score;
      _sharedObject.flush();
    }
    
    public static function saveSpecial(slot:int, special:Object):void
    {
      var i:String;
      for (i in specials)
      {
        if (specials[i] && (specials[i].effect == special.effect))
        {
          specials[i] = null;
        }
      }
      specials[slot] = special;
    }
    
    public static function get specials():Object
    {
      if (!_sharedObject.data.specials)
      {
        specials = {}
      }
      return _sharedObject.data.specials;
    }
    
    public static function set specials(val:Object):void
    {
      _sharedObject.data.specials = val;
      _sharedObject.flush();
    }
    
    public static function set musicMuted(value:Boolean):void {
      _sharedObject.data.musicMuted = value;
    }
    
    public static function get musicMuted():Boolean {
      return !!_sharedObject.data.musicMuted;
    }
    
    public static function set SFXMuted(value:Boolean):void {
      _sharedObject.data.SFXMuted = value;
    }
    
    public static function get SFXMuted():Boolean {
      return ! !_sharedObject.data.SFXMuted;
    }
    
    public static function fullScore():Number
    {
      var n:Number = 0;
      for (var i:int = 1; i <= 100; i++)
      {
        if (_sharedObject.data.levels[i].unlocked == true)
        {
          n += _sharedObject.data.levels[i].score;
        }
      }
      return n;
    }
    
    public static function get userName():String
    {
      if (!_sharedObject.data.user || _sharedObject.data.user == "") {
        _sharedObject.data.user = "anonymous";
      }
      return _sharedObject.data.user;
    }
    
    public static function set userName(value:String):void
    {
      _sharedObject.data.user = value;
    }
    
    public static function get guid():String 
    {
      return _sharedObject.data.guid;
    }
    
    // This is saved reversed so it is true on first start.
    public static function get firstStart():Boolean
    {
      return !_sharedObject.data.notFirstStart; 
    }
    
    public static function set firstStart(value:Boolean):void {
      _sharedObject.data.notFirstStart = !value;
    }
    
    public static function getPersonalScores(lid:String):Array 
    {
      if (!_sharedObject.data.personalScores[lid]) {
        _sharedObject.data.personalScores[lid] = [];
      }
      return  _sharedObject.data.personalScores[lid];
    }
    
    public static function storePersonalScores(lid:String, newScore:int):void 
    {
      if (!_sharedObject.data.personalScores[lid]) {
        _sharedObject.data.personalScores[lid] = [];
      }
      _sharedObject.data.personalScores[lid] = Utils.sortScoreArray(_sharedObject.data.personalScores[lid], newScore);
    }
  }
}
