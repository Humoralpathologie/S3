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
  //import Level.ArcadeState;
  import flash.events.Event;
  //import starling.display.Button;
  import org.josht.starling.foxhole.controls.Button;
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
  import engine.Utils;
  import starling.core.Starling;
  
  /**
   * ...
   * @author
   */
  public class LevelScore extends ManagedStage
  {
    /*
       private var _tweens:Vector.<GTween>;
    
       private var _scoreboard:Quad;
       private var _leaderboard:Quad;
     */
    private var _bg:Image;
    /*private var _replayButton:starling.display.Button;
       private var _nextLevelButton:starling.display.Button;
     private var _backToMenuButton:starling.display.Button;*/
    
    private var _replayButton:Button;
    private var _nextLevelButton:Button;
    private var _backToMenuButton:Button;
    
    private var _scores:Object = null;
    private var _timeBonus:int = 0;
    
    /*
       private var _scorePic:Image;
       private var _scoreText:TextField;
       public var _scoreCounter:int = 0;
    
       private var _timeBonusPic:Image;
       private var _timeBonusText:TextField;
       public var _timeBonusCounter:int = 0;
    
    
       private var _lifeBonusPic:Image;
       private var _lifeBonusText:TextField;
       public var _lifeBonusCounter:int = 0;
    
       private var _totalText:TextField;
       public var _totalCounter:int = 0;
    
    
       private var _medal:Image;
       private var _medalTween:GTween;
       private var _medalSmall:Image;
    
       private var _leaderboardText:TextField;
       private var _scoreboardText:TextField;
       private var _scoreHeading:TextField;
       private var _timeBonusHeading:TextField;
       private var _lifeBonusHeading:TextField;
       private var _totalHeading:TextField;
     */
    private var _boards:ScreenNavigator;
    private static const SCORE:String = "Score";
    private static const LEADERBOARDS:String = "Leaderboards";
    private var _scoreScreen:ScoreBoard;
    private var _leaderboardScreen:Leaderboards;
    private var _buttonWidth:int;
    
    public function LevelScore(scores:Object = null)
    {
      AssetRegistry.loadGraphics([AssetRegistry.SCORING, AssetRegistry.SNAKE, AssetRegistry.MENU]);
      
      _scores = scores;
      
      if (_scores == null)
      {
        _scores = {score: 1000, lives: 3, time: 30, level: 1}
      }
      if (_scores.lives > 0)
      {
        if (SaveGame.difficulty == 1)
        {
          _scores["liveBonus"] = _scores.lives * 50;
        }
        else
        {
          _scores["liveBonus"] = _scores.lives * 100;
        }
      }
      else
      {
        _scores["liveBonus"] = 0;
      }
      _scores["total"] = _scores.score + _scores.liveBonus;
      calculateTime();
      
      // No negative scores;
      
      _scores.timeBonus = Math.max(_timeBonus, 0);
      
      _scores.total += (_scores.timeBonus * 5);
      calculateMedal();
      trace("total: " + _scores.total)
      
      addBackground();
      addButtons();
      createScoreBoard();
      _boards.showScreen(SCORE);
      
      if (!_scores.lost)
      {
        SaveGame.saveScore(_scores.level, _scores.total);
        SaveGame.storePersonalScores(_scores.lid, _scores.total);
        AssetRegistry.mogade.submitScore(SaveGame.userName, SaveGame.guid, _scores.lid, _scores.total, showRank);
      }
      else
      {
        showRank({lost: true});
      }
    }
    
    private function showRank(ranks:Object):void
    {
      
      if (ranks.error)
      {
        // We have no net connection        
        SaveGame.savedScores.push({lid: _scores.lid, total: _scores.total});
      }
      else
      {
        if (!ranks.lost)
        {
          // We should have now, so send all the old scores out.
          var savedScore:Object;
          while (SaveGame.savedScores.length != 0)
          {
            savedScore = SaveGame.savedScores.pop();
            AssetRegistry.mogade.submitScore(SaveGame.userName, SaveGame.guid, savedScore.lid, savedScore.total);
          }
        }
      }
      
      _leaderboardScreen.dispatchEventWith(Leaderboards.REFRESH_LEADERBOARD);
      _scoreScreen.dispatchEventWith(ScoreBoard.SHOW_RANK, false, ranks);
    }
    
    private function calculateTime():void
    {
      if (SaveGame.difficulty == 1)
      {
        switch(_scores.level) {
        case 1:
						_timeBonus = 100 - int(_scores.time);
						break;
					case 2: 
						_timeBonus = 120 - int(_scores.time);
						break;
					case 3: 
						_timeBonus = 120 - int(_scores.time);
						break;
					case 4: 
						_timeBonus = 100 - int(_scores.time);
						break;
          case 5: 
					  _timeBonus = 0;
					  break;
          case 6: 
						_timeBonus = 180 - int(_scores.time);
						break;
          case 7: 
						_timeBonus = 220 - int(_scores.time);
					  break;
					case 9: 
						_timeBonus = 0;
						break;
				}
			}
			else
			{
				switch (_scores.level)
				{
					case 1: 
						_timeBonus = 120 - int(_scores.time);
          break;
        case 2:
          _timeBonus = 240 - int(_scores.time);
          break;
        case 3:
          _timeBonus = 240 - int(_scores.time);
          break;
        case 4:
          _timeBonus = 180 - int(_scores.time);
          break;
        case 5:
          _timeBonus = 0;
        break;
        case 6:
          _timeBonus = 180 - int(_scores.time);
          break;
        case 7:
          _timeBonus = 240 - int(_scores.time);
          break;
        case 9:
          _timeBonus = 0;
				  break;
      }}
    
    }
    
    private function calculateMedal():void
    {
      var medalReq:Array;
      if (SaveGame.difficulty == 1)
      {
        switch (_scores.level)
        {
          case 1:
            medalReq = [300, 400, 500, 700];
            break;
          case 2:
            medalReq = [700, 850, 1000, 1300];
            break;
          case 3:
            medalReq = [600, 750, 900, 1200];
            break;
          case 4:
            medalReq = [500, 600, 700, 1000];
            break;
          case 5:
            medalReq = [1000, 1250, 1500, 1800];
            break;
          case 6:
            medalReq = [750, 1000, 1500, 2500];
            break;
          case 7:
            medalReq = [1200, 1500, 1800, 2500];
            break;
        }

			}
			else
			{
				switch (_scores.level)
				{
          case 1: 
            medalReq = [800, 900, 1000, 1400];
            break;
          case 2:
            medalReq = [1250, 2000, 2500, 3500];
            break;
          case 3: 
            medalReq = [1500, 1750, 2000, 2500];
            break;
          case 4:
            medalReq = [1000, 1250, 1500, 2000];
            break;
          case 5: 
            medalReq = [1000, 1250, 1500, 2000];
            break;
          case 6:
            medalReq = [1250, 1500, 2000, 2500];
            break;
          case 7:
            medalReq = [1000, 2000, 3000, 4000];
            break;
        }
      }
      
      var actualMedal:int;
      if (medalReq)
      {
        if (_scores.total >= medalReq[0] && _scores.total < medalReq[1])
        {
          _scores.bigMedal = "medaille_bronze";
          _scores.smallMedal = "bronze_small";
          actualMedal = 0;
          
        }
        else if (_scores.total >= medalReq[1] && _scores.total < medalReq[2])
        {
          _scores.bigMedal = "medaille_silber";
          _scores.smallMedal = "silver_small";
          actualMedal = 1;
        }
        else if (_scores.total >= medalReq[2] && _scores.total < medalReq[3])
        {
          _scores.bigMedal = "medaille_gold";
          _scores.smallMedal = "gold_small";
          actualMedal = 2;
        }
        else if (_scores.total >= medalReq[3])
        {
          _scores.bigMedal = "medaille_saphir";
          _scores.smallMedal = "saphire_small";
          actualMedal = 3;
        }
      }
      
      if (!_scores.lost && !SaveGame.medals[_scores.level - 1] || actualMedal > SaveGame.medals[_scores.level - 1])
      {
        SaveGame.storeMedals(_scores.level, actualMedal);
      }
      
      trace(AssetRegistry.MEDALS[SaveGame.medals[_scores.level - 1]]);
    }
    
    private function createScoreBoard():void
    {
      _boards = new ScreenNavigator();
      var trans:ScreenFadeTransitionManager = new ScreenFadeTransitionManager(_boards);
      _scoreScreen = new ScoreBoard(_scores);
      _leaderboardScreen = new Leaderboards(_scores);
      _boards.addScreen(SCORE, new ScreenNavigatorItem(_scoreScreen, {onScoring: LEADERBOARDS}, {scores: this._scores}));
      _boards.defaultScreenID = SCORE;
      _boards.addScreen(LEADERBOARDS, new ScreenNavigatorItem(_leaderboardScreen, {onLeaderboards: SCORE}));
      addChild(_boards);
    
    }
    
    private function updateLeaderboard(data:Array):void
    {
    
    }
    
    private function replay():void
    {
      dispatchEventWith(SWITCHING, true, {stage: AssetRegistry.LEVELS[_scores.level - 1]});
    }
    
    private function nextLevel():void
    {
      dispatchEventWith(SWITCHING, true, {stage: AssetRegistry.LEVELS[_scores.level]});
    }
    
    private function backToMenu():void
    {
      dispatchEventWith(SWITCHING, true, {stage: MainMenu});
    }
    
    private function addButtons():void
    {
      var buttonWidth:int = 320;
      
      _backToMenuButton = new Button();
      _replayButton = new Button();
      _nextLevelButton = new Button();
      
      if (_scores.level != 9 && _scores.level != 7 && SaveGame.levelUnlocked(_scores.level + 1))
      {
        buttonWidth = 240;
        addChild(_nextLevelButton);
      }
      
      _backToMenuButton.label = AssetRegistry.Strings.BACKTOMENUBUTTON;
      _backToMenuButton.width = buttonWidth;
      _backToMenuButton.height = 80;
      _backToMenuButton.x = 0;
      _backToMenuButton.y = Starling.current.stage.stageHeight - _backToMenuButton.height;
      _backToMenuButton.onRelease.add(function(button:Button):void
        {
          backToMenu();
        });
      
      _replayButton.label = "REPLAY";
      _replayButton.width = buttonWidth;
      _replayButton.height = 80;
      _replayButton.x = _backToMenuButton.x + _backToMenuButton.width;
      _replayButton.y = _backToMenuButton.y;
      _replayButton.onRelease.add(function(button:Button):void
        {
          replay();
        });
      
      _nextLevelButton.label = "NEXT";
      _nextLevelButton.width = buttonWidth;
      _nextLevelButton.height = 80;
      _nextLevelButton.x = _replayButton.x + _replayButton.width;
      _nextLevelButton.y = _backToMenuButton.y;
      _nextLevelButton.onRelease.add(function(button:Button):void
        {
          nextLevel();
        });
      
      addChild(_replayButton);
      
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
