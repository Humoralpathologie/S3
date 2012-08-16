package Menu
{
  import com.gskinner.motion.easing.Exponential;
  import com.gskinner.motion.easing.Elastic;
  import com.gskinner.motion.GTween;
  import engine.AssetRegistry;
  import engine.ManagedStage;
  import engine.SaveGame;
  import engine.StageManager;
  import starling.display.Quad;
  import starling.display.QuadBatch;
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
  import starling.utils.VAlign;
  import org.josht.starling.foxhole.transitions.ScreenFadeTransitionManager;
  import org.josht.starling.foxhole.controls.ScreenNavigator;
  import org.josht.starling.foxhole.controls.ScreenNavigatorItem;

  
  
  /**
   * ...
   * @author
   */
  public class LevelScore extends ManagedStage
  {
    private var _tweens:Vector.<GTween>;    
    private var _bg:Image;
    private var _scoreboard:Quad;
    private var _leaderboard:Quad;
    private var _replayButton:starling.display.Button;
    private var _nextLevelButton:starling.display.Button;
    private var _backToMenuButton:starling.display.Button;

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
  
    private var _totalText:TextField;
    public var _totalCounter:int = 0;

    private var _scores:Object = null;
    private var _medal:Image;
    private var _medalTween:GTween;
    private var _medalSmall:Image;
    
    private var _leaderboardText:TextField;
    private var _scoreboardText:TextField;
    private var _scoreHeading:TextField;
    private var _timeBonusHeading:TextField;
    private var _lifeBonusHeading:TextField;
    private var _totalHeading:TextField;
    
	private var _boards:ScreenNavigator;
	private static const SCORE:String = "Score";
    private static const LEADERBOARDS:String = "Leaderboards";
	private var _scoreScreen:ScoreBoard;
	private var _leaderboardScreen:Leaderboards;
	
    public function LevelScore(scores:Object = null)
    {
      AssetRegistry.loadGraphics([AssetRegistry.SCORING, AssetRegistry.SNAKE, AssetRegistry.MENU]);
      
      
      _scores = scores;
	  
      if (_scores == null)
      {
        _scores = {score: 1000, lives: 3, time: 30, level: 1}
      }
      _scores["total"] = _scores.score + (_scores.lives * 100);
      calculateTime();
      
      // No negative scores;
      
      _timeBonus = Math.max(_timeBonus, 0);
      
      _scores.total += (_timeBonus * 5);
      if(!_scores.lost) {
        SaveGame.saveScore(_scores.level, _scores.total);
      }
	    
	  addBackground();
	  createScoreBoard();
	  addButtons();
	  _boards.showScreen(SCORE);
      //updateLeaderboard();
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
            _timeBonus = 3 * 60 - int(_scores.time);
            break;
        default:
            _timeBonus = 3 * 60 - int(_scores.time);  
            break;
      }
      
    }

	private function createScoreBoard():void {
      trace(_scores);
      _boards = new ScreenNavigator();
      var trans:ScreenFadeTransitionManager = new ScreenFadeTransitionManager(_boards);
	  _scoreScreen = new ScoreBoard();
	  _leaderboardScreen = new Leaderboards();
      _boards.addScreen(SCORE, new ScreenNavigatorItem(_scoreScreen, { onScoring: LEADERBOARDS}, { scores: this._scores} ));
      _boards.defaultScreenID = SCORE;
	  _boards.addScreen(LEADERBOARDS, new ScreenNavigatorItem(_leaderboardScreen, { onLeaderboards: SCORE}));
      addChild(_boards);
      
    }
    
	/*
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
        loading.dispose();
       
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
	
	
*/
    
    private function replay():void
    {
      dispatchEventWith(SWITCHING, true, { stage: AssetRegistry.LEVELS[_scores.level - 1] } );
    }
    
    private function nextLevel():void
    {
      dispatchEventWith(SWITCHING, true, { stage: AssetRegistry.LEVELS[_scores.level] } );
    }
    
    private function backToMenu():void
    {
      dispatchEventWith(SWITCHING, true, { stage: MainMenu } );
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
    
    
    override public function dispose():void
    { 
	 /*  
      _leaderboardText.dispose();
     */
	  _scoreScreen.dispose();
	  _replayButton.removeEventListeners(starling.events.Event.TRIGGERED);
      _replayButton.dispose();
      _nextLevelButton.removeEventListeners(starling.events.Event.TRIGGERED);
      _nextLevelButton.dispose();
      _backToMenuButton.removeEventListeners(starling.events.Event.TRIGGERED);
      _backToMenuButton.dispose();
	  _bg.dispose();
      super.dispose();
    }
  }

}
