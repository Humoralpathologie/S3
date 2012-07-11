package Menu
{
  import com.gskinner.motion.easing.Exponential;
  import com.gskinner.motion.easing.Elastic;
  import com.gskinner.motion.GTween;
  import engine.AssetRegistry;
  import engine.ManagedStage;
  import engine.SaveGame;
  import engine.StageManager;
  import starling.events.Event;
  
  import flash.events.Event;
  import starling.display.Button;
  import starling.display.Image;
  import starling.events.EnterFrameEvent;
  import starling.text.TextField;
  import starling.utils.Color;
  import starling.utils.HAlign;
  import starling.textures.Texture;
  import flash.net.*;
  import JSON;
  
  
  /**
   * ...
   * @author
   */
  public class LevelScore extends ManagedStage
  {
    private var _tweens:Vector.<GTween>;    
    private var _bg:Image;
    private var _scoreboard:Image;
    private var _leaderboard:Image;
    private var _replayButton:Button;
    private var _nextLevelButton:Button;
    private var _backToMenuButton:Button;

    private var _scorePic:Image;
    private var _scoreText:TextField;
    public var _scoreCounter:int = 0;

    private var _timeBonusPic:Image;
    private var _timeBonusText:TextField;
    public var _timeBonusCounter:int = 0;
    private var _timeBonus:int = 0;

    private var _lifeBonusPic:Image;
    private var _lifeBonusText:TextField;
    public var _lifeBonusCounter:int = 0;
   
    private var _EXP:int = 0;
    private var _EXPText:TextField;
    public var _EXPCounter:int = 0;

    private var _totalText:TextField;
    public var _totalCounter:int = 0;

    private var _scores:Object = null;
    private var _medal:Image;
    private var _medalTween:GTween;
    private var _medalSmall:Image;
    
    public function LevelScore(scores:Object = null)
    {
      AssetRegistry.loadGraphics([AssetRegistry.SCORING, AssetRegistry.SNAKE, AssetRegistry.MENU]);
      
      _tweens = new Vector.<GTween>;
      _scores = scores;
      if (_scores == null)
      {
        _scores = {score: 1000, lives: 3, time: 200, level: 1}
      }
      _scores["total"] = _scores.score + (_scores.lives * 100);
      calculateTime();
      
      // No negative scores;
      
      _EXP = Math.max(_EXP, 0);
      _timeBonus = Math.max(_timeBonus, 0);
      
      _scores.total += (_timeBonus * 5);
      if(!_scores.lost) {
        SaveGame.saveScore(_scores.level, _scores.total);
      }
      buildMenu();
      startScoring();
      updateLeaderboard();
    }
    private function calculateTime():void
    {
      
      switch(_scores.level) {
        case 1:
            _timeBonus = 3 * 60 - int(_scores.time);
            break;
        case 2:
            _timeBonus = 4 * 60 - int(_scores.time);
            break;
        case 3:
            _timeBonus = 4 * 60 - int(_scores.time);
            break;
        case 4:
            _timeBonus = 5 * 60 - int(_scores.time);
            break;
        default:
            _timeBonus = 3 * 60 - int(_scores.time);  
            break;
      }
      
      if(_scores.snake){
        _EXP = _scores.snake.eatenEggs - (_scores.snake.body.length - 4);
      }
    }

    private function updateLeaderboard():void
    {
      var url:String = "https://www.scoreoid.com/api/getBestScores";
      var request:URLRequest = new URLRequest(url);
      var requestVars:URLVariables = new URLVariables();
      request.data = requestVars;      
      requestVars.api_key = "7bb1d7f5ac027ae81b6c42649fddc490b3eef755";
      requestVars.game_id = "5UIVQJJ3X";      
      requestVars.response = "JSON"
      requestVars.order_by = "score";
      requestVars.order = "desc";
      requestVars.limit = 10;
      requestVars.difficulty = _scores.level;
      
      request.method = URLRequestMethod.POST;
      
      var loading:TextField = new TextField(300, 50, "Loading...", "kroeger 06_65", 30, 0xffffff);
      loading.hAlign = HAlign.LEFT;
      loading.x = _leaderboard.x + 20;
      loading.y = _leaderboard.y + 50;
      addChild(loading);
      
      var loaderCompleteHandler:Function = function(event:flash.events.Event):void {
        trace(event.target.data);
        removeChild(loading);
        var result:Object = JSON.parse(event.target.data);
        if (result.error) {
          return;
        }
        var data:Array = result as Array;
        
        var pos:int = 0;
        for (var i:int = 0; i < data.length; i++) {
          var score:Object = data[i];
          var text:TextField = new TextField(450, 50, "", "kroeger 06_65", 30, 0xffffff);
          text.hAlign = HAlign.LEFT;
          text.text = String(1 + i) + ". " + score.Player.username + ": " + String(score.Score.score);
          text.x = _leaderboard.x + 20;
          text.y = _leaderboard.y + 50 + i * 30;
          addChild(text);
        }
      }
      
      
      
      
      var urlLoader:URLLoader = new URLLoader();
      urlLoader = new URLLoader();
      urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
      urlLoader.addEventListener(flash.events.Event.COMPLETE, loaderCompleteHandler);
      
      urlLoader.load(request);
    }
    
    private function buildMenu():void
    {
      addBackground();
      addBoards();
      addTexts();
      addButtons();
    }
    
    private function medal(tween:GTween):void
    {
      var self:LevelScore = this;
      var func:Function = function(tween:GTween):void {
        _medalTween.setValues( { x: 960 } );
        _medalTween.onComplete = func2;
      }
      
      var func2:Function = function(tween:GTween):void {
          self.removeChild(_medal);
          _medalSmall.x = 960;
          _medalSmall.y = 0;
          self.addChild(_medalSmall);
          _medalTween.target = _medalSmall;
          _medalTween.setValues( { x: 320, y: 370 } );
          _medalTween.onComplete = null;
          //_medalTween.autoPlay = false;   
      }
      
      if (_scores.total >= 400 && _scores.total < 600) {
        _medal = new Image(AssetRegistry.ScoringScalableAtlas.getTexture("medaille_bronze"));
        _medal.x = -800;
        _medal.y = 0;
        _medalSmall = new Image(AssetRegistry.ScoringAtlas.getTexture("bronze_small"));
      } else if (_scores.total >= 600 && _scores.total < 800) {
        _medal = new Image(AssetRegistry.ScoringScalableAtlas.getTexture("medaille_saphir"));
        _medal.x = -800;
        _medal.y = 0;
        _medalSmall = new Image(AssetRegistry.ScoringAtlas.getTexture("saphire_small"));
      } else if (_scores.total >= 800 && _scores.total < 1000) {
        _medal = new Image(AssetRegistry.ScoringScalableAtlas.getTexture("medaille_silber"));
        _medal.x = -800;
        _medal.y = 0;
        _medalSmall = new Image(AssetRegistry.ScoringAtlas.getTexture("silver_small"));
      } else if (_scores.total >= 1000) {
        _medal = new Image(AssetRegistry.ScoringScalableAtlas.getTexture("medaille_gold"));
        _medal.x = -800;
        _medal.y = 0;
        _medalSmall = new Image(AssetRegistry.ScoringAtlas.getTexture("gold_small"));
      }


      if (_medal) {
        _medalTween = new GTween(_medal, 1.5, {x: 105}, {ease: Elastic.easeInOut, onComplete: func});
        _tweens.push(_medalTween);
        addChild(_medal);
      }

    }
    private function startScoring():void
    {
      var self:LevelScore = this;
      addEventListener(EnterFrameEvent.ENTER_FRAME, updateTexts);
      var triggerLife:Function = function(tween:GTween):void{
        _tweens.push(new GTween(self, 2, {_lifeBonusCounter: _scores.lives * 100}, {ease: Exponential.easeOut, onComplete:triggerTotal}));
      }
      var triggerTime:Function = function(tween:GTween):void {
        if(!_scores.lost) {
          _tweens.push(new GTween(self, 2, { _timeBonusCounter: _timeBonus }, { ease: Exponential.easeOut, onComplete:triggerLife } ));
        }
      }
      var triggerTotal:Function = function(tween:GTween):void{
        _tweens.push(new GTween(self, 2, {_totalCounter: _scores.total}, {ease: Exponential.easeOut, onComplete:triggerEXP}));
      }
      var triggerEXP:Function = function(tween:GTween):void{
        _tweens.push(new GTween(self, 2, {_EXPCounter: _EXP}, {ease: Exponential.easeOut, onComplete:medal}));
      }
      
      _tweens.push(new GTween(this, 2, {_scoreCounter: _scores.score}, {ease: Exponential.easeOut, onComplete:triggerTime}));
    /*
       var tweenScore:GTween = new GTween(_scoreCounter, 2, {i: _score}, {ease: Exponential.easeOut});
       var tweenLive:GTween = new GTween(_lifeBonusCounter, 2, {i: _liveBonus}, {ease: Exponential.easeOut});
       var tweenTime:GTween = new GTween(_BCounter, 2, {i: _timeBonus}, {ease: Exponential.easeOut});
     var tweenEXP:GTween = new GTween(_EXPCounter, 2, {i: _EXP}, {ease: Exponential.easeOut});  */
    }
    
    private function updateTexts(event:EnterFrameEvent):void
    {
      _lifeBonusText.text = String(_lifeBonusCounter);
      _timeBonusText.text = String(_timeBonusCounter * 5);
      _scoreText.text = String(_scoreCounter);
      _totalText.text = String(_totalCounter);
      _EXPText.text = String(_EXPCounter);
    }
    
    private function addTexts():void
    {
      _lifeBonusText = new TextField(100, 35, "1", "kroeger 06_65", 35, Color.WHITE);
      _lifeBonusText.hAlign = HAlign.RIGHT;
      _lifeBonusText.x = _lifeBonusPic.x + _lifeBonusPic.width + 10;
      _lifeBonusText.y = _lifeBonusPic.y - 10;
      
      _scoreText = new TextField(100, 35, "1", "kroeger 06_65", 35, Color.WHITE);
      _scoreText.hAlign = HAlign.RIGHT;
      _scoreText.x = _lifeBonusText.x;
      _scoreText.y = _scorePic.y - 10;
      
      _timeBonusText = new TextField(100, 35, "1", "kroeger 06_65", 35, Color.WHITE);
      _timeBonusText.hAlign = HAlign.RIGHT;
      _timeBonusText.x = _lifeBonusText.x;
      _timeBonusText.y = _timeBonusPic.y - 10;
      
      _totalText = new TextField(100, 35, "1", "kroeger 06_65", 35, Color.WHITE);
      _totalText.hAlign = HAlign.LEFT;
      _totalText.x = _lifeBonusPic.x + 120;
      _totalText.y = _lifeBonusText.y + 77;

      _EXPText = new TextField(100, 35, "1", "kroeger 06_65", 35, Color.WHITE);
      _EXPText.hAlign = HAlign.LEFT;
      _EXPText.x = _lifeBonusPic.x + 90;
      _EXPText.y = _lifeBonusText.y + 145;

      addChild(_lifeBonusText);
      addChild(_scoreText);
      addChild(_timeBonusText);
      addChild(_totalText);
      addChild(_EXPText);
    }
    
    private function replay():void
    {
      StageManager.switchStage(AssetRegistry.LEVELS[_scores.level - 1]);
    }
    
    private function nextLevel():void
    {
      StageManager.switchStage(AssetRegistry.LEVELS[_scores.level]);
    }
    
    private function backToMenu():void
    {
      StageManager.switchStage(MainMenu);
    }
    
    private function addButtons():void
    {
      _replayButton = new Button(AssetRegistry.ScoringAtlas.getTexture("menu-egg-redo"));
      _replayButton.downState = AssetRegistry.ScoringAtlas.getTexture("menu-egg-redo-broken");
      _replayButton.x = 960 / 2 - 145 / 2;
      _replayButton.y = 460;
      
      _replayButton.addEventListener(starling.events.Event.TRIGGERED, replay);
      
      _nextLevelButton = new Button(AssetRegistry.ScoringAtlas.getTexture("menu-egg-next"));
      _nextLevelButton.downState = AssetRegistry.ScoringAtlas.getTexture("menu-egg-next-broken");
      _nextLevelButton.x = 960 / 2 + 145 / 2 + 30;
      _nextLevelButton.y = _replayButton.y + 30;
      
      _nextLevelButton.addEventListener(starling.events.Event.TRIGGERED, nextLevel);
      
      _backToMenuButton = new Button(AssetRegistry.ScoringAtlas.getTexture("menu-egg-back"));
      _backToMenuButton.downState = AssetRegistry.ScoringAtlas.getTexture("menu-egg-back-broken");
      _backToMenuButton.x = 960 / 2 - 145 / 2 - 30 - 135;
      _backToMenuButton.y = _nextLevelButton.y;
      
      _backToMenuButton.addEventListener(starling.events.Event.TRIGGERED, backToMenu);
      
      addChild(_replayButton);
      if(_scores.level != 9) {
        addChild(_nextLevelButton);
      }
      addChild(_backToMenuButton);
    }
    
    private function addBackground():void
    {
      _bg = new Image(AssetRegistry.MenuAtlasOpaque.getTexture("menu_iphone_background"));
      addChild(_bg);
    }
    
    private function addBoards():void
    {
      
      _scoreboard = new Image(AssetRegistry.ScoringAtlas.getTexture("bronze_small"));
      _scoreboard.x = 70;
      _scoreboard.y = 30;
      
      _leaderboard = new Image(AssetRegistry.ScoringAtlas.getTexture("bronze_small"));
      _leaderboard.x = _scoreboard.width + 140;
      _leaderboard.y = _scoreboard.y;
      
      _scorePic = new Image(AssetRegistry.ScoringAtlas.getTexture("bronze_small"));
      _scorePic.x = _scoreboard.x + 20;
      _scorePic.y = _scoreboard.y + 80;
      
      _timeBonusPic = new Image(AssetRegistry.ScoringAtlas.getTexture("bronze_small"));
      _timeBonusPic.x = _scorePic.x;
      _timeBonusPic.y = _scorePic.y + _scorePic.height + 20;
      
      _lifeBonusPic = new Image(AssetRegistry.ScoringAtlas.getTexture("bronze_small"));
      _lifeBonusPic.x = _timeBonusPic.x;
      _lifeBonusPic.y = _timeBonusPic.y + _timeBonusPic.height + 20;
      
      /*
      addChild(_scoreboard);
      addChild(_leaderboard);
      
      addChild(_scorePic);
      addChild(_timeBonusPic);
      addChild(_lifeBonusPic);
      */
      
    }
    
    override public function dispose():void
    {
      for each(var tween:GTween in _tweens) {
        tween.end();
      }
      _tweens = null;
      super.dispose();
    }
  }

}
