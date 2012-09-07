package Menu
{
	import com.gskinner.motion.easing.Exponential;
	import com.gskinner.motion.easing.Elastic;
	import com.gskinner.motion.GTween;
	import org.josht.starling.display.Image;
	import org.josht.starling.foxhole.controls.Screen;
	import org.josht.starling.foxhole.controls.ToggleSwitch;
	import org.osflash.signals.Signal;
	import engine.AssetRegistry;
	import org.osflash.signals.ISignal;
	//import starling.display.Button;
	import org.josht.starling.foxhole.controls.Button;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.utils.Color;
	import starling.core.Starling;
	import engine.StageManager;
	import Level.ArcadeState;
	import engine.SaveGame;
	import starling.text.TextField;
	
	import starling.textures.Texture;
	
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import starling.textures.Texture;
	import Menu.MainMenu;
	import Menu.LevelScore;
	import starling.events.EnterFrameEvent;
	import starling.animation.Tween;
	
	/**
	 * ...
	 * @author
	 */
	public class ScoreBoard extends Screen
	{
		private var _tweens:Vector.<GTween>;
		private var _scoreboard:Quad;
		//private var _scorePic:Image;
		private var _scoreText:TextField;
		public var _scoreCounter:int = 0;
		
		//private var _timeBonusPic:Image;
		private var _timeBonusText:TextField;
		public var _timeBonusCounter:int = 0;
		
		//private var _lifeBonusPic:Image;
		private var _lifeBonusText:TextField;
		public var _lifeBonusCounter:int = 0;
		
		private var _totalText:TextField;
		public var _totalCounter:int = 0;
		
		private var _scores:Object = {};
		private var _medal:Image;
		private var _medalTween:GTween;
		private var _medalSmall:Image;
		
		//private var _leaderboardText:TextField;
		private var _scoreboardText:TextField;
		private var _scoreHeading:TextField;
		private var _timeBonusHeading:TextField;
		private var _lifeBonusHeading:TextField;
		private var _totalHeading:TextField;
		private var _rankHeading:TextField;
		private var _rankText:TextField;
		private var _rank:TextField;
		
		protected var _onScoring:Signal = new Signal(ScoreBoard);
		private var _next:Button;
		private var _highScoreTxt:TextField;
		
		private var _alltimehigh:Boolean = false;
		private var _weekhigh:Boolean = false;
		
		private var _nextTimeBonusPling:int = 0;
		private var _nextLifeBonusPling:int = 0;
		private var _nextScorePling:int = 0;
		private var _nextTotalPling:int = 0;
		
		public static const SHOW_RANK:String = "showrank";
		
		public function ScoreBoard(scores:Object)
		{
			super();
      _scores = scores;
			buildMenu();      
			addEventListener(SHOW_RANK, showRank);
      
		}
		
		// Input looks like this:
		//{"ranks":{"4":1,"1":1,"2":1,"3":1},"highs":{"1":true,"2":true,"3":true}}    
		private function showRank(evt:Event):void
		{
      if (evt.data.lost) {
        _rankText.text = AssetRegistry.Strings.NO_RANK;
        return;
      }
      
			if (evt.data.error)
			{
				_rankText.text = AssetRegistry.Strings.NO_NET_CONNECTION;
				return;
			}
			
			_rankText.text = AssetRegistry.Strings.RANKOVERALL + ":\n" + AssetRegistry.Strings.RANKWEEK + ":\n" + AssetRegistry.Strings.RANKTODAY + ":";
			_rank.text = String(evt.data.ranks[3]) + "\n" + String(evt.data.ranks[2]) + "\n" + String(evt.data.ranks[1]);
			if (evt.data.highs[3])
			{
				_alltimehigh = true;
			}
			if (!evt.data.highs[3] && evt.data.highs[2])
			{
				_weekhigh = true;
			}
		}
		
		private function showMessage(msg:String):void
		{
			trace("wird ausgeführt");
			addChild(_highScoreTxt);
			_highScoreTxt.text = msg;
			_highScoreTxt.touchable = false;
			var onComplete:Function = function(tween:GTween):void
			{
				_highScoreTxt.visible = false;
				removeChild(_highScoreTxt);
				medal(tween);
			}
			var tween:GTween = new GTween(_highScoreTxt, 2, {y: -_highScoreTxt.height}, {ease: Exponential.easeIn, onComplete: onComplete});
			
			_tweens.push(tween);
		}
		
		private function showHighMessage(tween:GTween):void
		{
			AssetRegistry.soundmanager.playSound("pling");
			
			if (_alltimehigh)
			{
				showMessage(AssetRegistry.Strings.HIGHMESSAGE);
			}
			else if (_weekhigh)
			{
				showMessage(AssetRegistry.Strings.WEEKHIGHMESSAGE);
			}
			else
			{
				medal(tween);
			}
		}
		
		override protected function initialize():void
		{
			_highScoreTxt = new TextField(AssetRegistry.STAGE_WIDTH, AssetRegistry.STAGE_HEIGHT, "", "kroeger 06_65", 90, 0x00ff06);
			_highScoreTxt.x = 0;
			_highScoreTxt.y = 0;
			_tweens = new Vector.<GTween>;
			trace(_scores);
			startScoring();
		
			//addEventListener(EnterFrameEvent.ENTER_FRAME, startScoring);
			//updateLeaderboard();
		}
		
		public function get scores():Object
		{
			return _scores;
		}
		
		public function set scores(value:Object):void
		{
			_scores = value;
		}
		
		public function get onScoring():ISignal
		{
			return _onScoring;
		}
		
		private function buildMenu():void
		{
			addBoards();
			addTexts();
			addRank();
			
			_next = new Button();
			_next.label = AssetRegistry.Strings.LEADERBOARDSBUTTON;
			
			if (SaveGame.isArcade || _scores.level == 7 || !SaveGame.levelUnlocked(_scores.level + 1))
			{
				_next.width = 320;
				_next.x = 640;
			}
			else
			{
				_next.width = 240;
				_next.x = 720;
			}
			_next.height = 80;
			
			_next.y = Starling.current.stage.stageHeight - _next.height;
			
			var that:ScoreBoard = this;
			
			_next.onRelease.add(function(button:Button):void
				{
					_onScoring.dispatch(that);
				});
			addChild(_next);
		
		}
		
		private function medal(tween:GTween):void
		{
			trace("medaling");
			var self:ScoreBoard = this;
			var func:Function = function(tween:GTween):void
			{
				_medalTween.setValues({x: 960});
				_medalTween.onComplete = func2;
				//AssetRegistry.soundmanager.playSound("medalSound1");
			}
			
			var func2:Function = function(tween:GTween):void
			{
				self.removeChild(_medal);
				_medalSmall.x = 960;
				_medalSmall.y = 0;
				self.addChild(_medalSmall);
				_medalTween.target = _medalSmall;
				_medalTween.setValues({x: 755, y: 370});
				_medalTween.onComplete = null;
				//_medalTween.autoPlay = false; 
				AssetRegistry.soundmanager.playSound("medalSound2");
			}
			
			if (_scores.bigMedal)
			{
				_medal = new Image(AssetRegistry.ScoringScalableAtlas.getTexture(_scores.bigMedal));
				_medal.x = -800;
				_medal.y = 0;
				_medalSmall = new Image(AssetRegistry.ScoringAtlas.getTexture(_scores.smallMedal));
			}
			
			if (_medal)
			{
				_medalTween = new GTween(_medal, 1.5, {x: 105, y: -100}, {ease: Elastic.easeInOut, onComplete: func});
				_tweens.push(_medalTween);
				AssetRegistry.soundmanager.playSound("medalSound1");
				addChild(_medal);
				
			}
		
		}
		
		private function startScoring():void
		{
			var self:ScoreBoard = this;
			var triggerLife:Function = function(tween:GTween):void
			{
				//AssetRegistry.soundmanager.playSound("pling");
				_tweens.push(new GTween(self, 2, {_lifeBonusCounter: _scores.liveBonus}, {ease: Exponential.easeOut, onComplete: triggerTotal}));
			}
			var triggerTime:Function = function(tween:GTween):void
			{
				if (!_scores.lost)
				{
					//AssetRegistry.soundmanager.playSound("pling");
					_tweens.push(new GTween(self, 2, {_timeBonusCounter: _scores.timeBonus}, {ease: Exponential.easeOut, onComplete: triggerLife}));
				}
			}
			var triggerTotal:Function = function(tween:GTween):void
			{
				//AssetRegistry.soundmanager.playSound("pling");
				
				_tweens.push(new GTween(self, 2, {_totalCounter: _scores.total}, {ease: Exponential.easeOut, onComplete: showHighMessage}));
			}
			
			_tweens.push(new GTween(this, 2, {_scoreCounter: _scores.score}, {ease: Exponential.easeOut, onComplete: triggerTime}));
			addEventListener(EnterFrameEvent.ENTER_FRAME, updateTexts);
		}
		
		private function updateTexts(event:EnterFrameEvent):void
		{
			if (_lifeBonusCounter > _nextLifeBonusPling)
			{
				AssetRegistry.soundmanager.playSound("endPling");
				_nextLifeBonusPling = _lifeBonusCounter + Math.floor(_scores.liveBonus / 30);
			}
			if (_timeBonusCounter * 5 > _nextTimeBonusPling)
			{
				AssetRegistry.soundmanager.playSound("endPling");
				_nextTimeBonusPling = _timeBonusCounter * 5 + Math.floor((_scores.timeBonus * 5) / 30);
			}
			if (_scoreCounter > _nextScorePling)
			{
				AssetRegistry.soundmanager.playSound("endPling");
				_nextScorePling = _scoreCounter + Math.floor(_scores.score / 30);
			}
			if (_totalCounter > _nextTotalPling)
			{
				AssetRegistry.soundmanager.playSound("endPling");
				_nextTotalPling = _totalCounter + Math.floor(_scores.total / 30);
			}
			
			_lifeBonusText.text = String(_lifeBonusCounter);
			_timeBonusText.text = String(_timeBonusCounter * 5);
			_scoreText.text = String(_scoreCounter);
			_totalText.text = String(_totalCounter);
			//_EXPText.text = String(_EXPCounter);
		}
		
		private function addTexts():void
		{
			
			_lifeBonusText = new TextField(100, 40, "1", "kroeger 06_65", 32, Color.WHITE);
			_lifeBonusText.hAlign = HAlign.RIGHT;
			_lifeBonusText.x = _lifeBonusHeading.x + _lifeBonusHeading.width + 10;
			_lifeBonusText.y = _lifeBonusHeading.y;
			
			_scoreText = new TextField(100, 40, "1", "kroeger 06_65", 32, Color.WHITE);
			_scoreText.hAlign = HAlign.RIGHT;
			_scoreText.x = _lifeBonusText.x;
			_scoreText.y = _scoreHeading.y;
			
			_timeBonusText = new TextField(100, 40, "1", "kroeger 06_65", 32, Color.WHITE);
			_timeBonusText.hAlign = HAlign.RIGHT;
			_timeBonusText.x = _lifeBonusText.x;
			_timeBonusText.y = _timeBonusHeading.y;
			
			_totalText = new TextField(100, 40, "1", "kroeger 06_65", 32, Color.WHITE);
			_totalText.hAlign = HAlign.RIGHT;
			_totalText.x = _lifeBonusText.x;
			_totalText.y = _totalHeading.y;
			
		  addChild(_lifeBonusText);
			addChild(_scoreText);
			if (_scores.level != 9 && _scores.level != 5)
			{
				addChild(_timeBonusText);
			}
			addChild(_totalText);
		
		}
		
		private function addBoards():void
		{
			
			_scoreboard = new Quad(820, 475, 0x545454);
			_scoreboard.alpha = 179 / 255;
			_scoreboard.x = 70;
			_scoreboard.y = 30;
			addChild(_scoreboard);
			
			_scoreboardText = new TextField(200, 40, AssetRegistry.Strings.SCORES, "kroeger 06_65", 40, Color.WHITE);
			_scoreboardText.vAlign = VAlign.TOP;
			_scoreboardText.hAlign = HAlign.LEFT;
			_scoreboardText.x = _scoreboard.x + 20;
			_scoreboardText.y = _scoreboard.y + 20;
			addChild(_scoreboardText);
			
			_scoreHeading = new TextField(200, 40, "Score", "kroeger 06_65", 35, Color.WHITE);
			_scoreHeading.x = _scoreboard.x + 20;
			_scoreHeading.y = _scoreboard.y + 80;
			_scoreHeading.vAlign = VAlign.TOP;
			_scoreHeading.hAlign = HAlign.LEFT;
			addChild(_scoreHeading);
			
			_timeBonusHeading = new TextField(200, 40, "Time Bonus", "kroeger 06_65", 35, Color.WHITE);
			_timeBonusHeading.x = _scoreHeading.x;
			_timeBonusHeading.y = _scoreHeading.y + 60;
			_timeBonusHeading.vAlign = VAlign.TOP;
			_timeBonusHeading.hAlign = HAlign.LEFT;
			if (_scores.level != 9 && _scores.level != 5)
			{
				addChild(_timeBonusHeading);
			}
			
			_lifeBonusHeading = new TextField(200, 40, "Life Bonus", "kroeger 06_65", 35, Color.WHITE);
			_lifeBonusHeading.x = _scoreHeading.x;
			_lifeBonusHeading.y = (_scores.level != 9) ? _timeBonusHeading.y + 60 : _scoreHeading.y + 60;
			_lifeBonusHeading.vAlign = VAlign.TOP;
			_lifeBonusHeading.hAlign = HAlign.LEFT;
		  addChild(_lifeBonusHeading);
			
			_totalHeading = new TextField(200, 40, "Total", "kroeger 06_65", 35, Color.WHITE);
			_totalHeading.x = _scoreHeading.x;
			_totalHeading.y = _lifeBonusHeading.y + 80;
			_totalHeading.vAlign = VAlign.TOP;
			_totalHeading.hAlign = HAlign.LEFT;
			addChild(_totalHeading);
		
		}
		
		private function addRank():void
		{
			_rankHeading = new TextField(380, 100, AssetRegistry.Strings.RANK, "kroeger 06_65", 40, Color.WHITE);
			_rankHeading.x = 500;
			_rankHeading.y = _scoreboardText.y;
			_rankHeading.hAlign = HAlign.LEFT;
      _rankHeading.autoScale = true;
			addChild(_rankHeading);
			
			_rankText = new TextField(300, 400, "Checking rank...", "kroeger 06_65", 35, Color.WHITE);
			_rankText.x = _rankHeading.x;
			_rankText.y = _timeBonusHeading.y;
			_rankText.vAlign = VAlign.TOP;
			_rankText.hAlign = HAlign.LEFT;
			addChild(_rankText);
			_rank = new TextField(200, 400, "", "kroeger 06_65", 35, Color.WHITE);
			_rank.x = _rankText.x + 70;
			_rank.y = _rankText.y;
			_rank.vAlign = VAlign.TOP;
			_rank.hAlign = HAlign.RIGHT;
			addChild(_rank);
		}
		
		override public function dispose():void
		{
			for each (var tween:GTween in _tweens)
			{
				tween.onComplete = null;
				tween.end();
			}
			
			_tweens = null;
			_scoreboard.dispose();
			_scoreText.dispose();
			_timeBonusText.dispose();
			_lifeBonusText.dispose();
			_totalText.dispose();
			_scoreboardText.dispose();
			_scoreHeading.dispose();
			_timeBonusHeading.dispose();
			_lifeBonusHeading.dispose();
			_totalHeading.dispose();
			_rankHeading.dispose();
			_rankText.dispose();
			
			if (_medal != null)
				_medal.dispose();
			
			_medalTween = null;
			
			if (_medalSmall != null)
				_medalSmall.dispose();
			
			removeEventListener(SHOW_RANK, showRank);
		
		}
	}
}