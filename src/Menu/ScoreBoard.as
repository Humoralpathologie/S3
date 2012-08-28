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
  import starling.display.Button;
  import starling.display.Quad;
  import starling.events.Event;
  import starling.utils.Color;
  import starling.core.Starling;
  import engine.StageManager;
  import Level.ArcadeState;
  import engine.SaveGame;
  import starling.text.TextField;
  import starling.utils.Color;
  import starling.utils.HAlign;
  import starling.utils.VAlign;
  import starling.textures.Texture;
  import Menu.MainMenu;
  import Menu.LevelScore;
  import starling.events.EnterFrameEvent;


  
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
	
	protected var _onScoring:Signal = new Signal(ScoreBoard);
	private var _next:Button;
	
	public function ScoreBoard()
    {
      super();
	 
    }
    
    override protected function initialize():void
    {
	  _tweens = new Vector.<GTween>;
	  buildMenu(); 
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
	  _next = new Button(AssetRegistry.MenuAtlasAlpha.getTexture("arrow_reduced"));
      _next.scaleX = -1;
      _next.x = _scoreboard.x + _scoreboard.width + _next.width;
      _next.y = _scoreboard.y + 10;
	  var that:ScoreBoard = this;
	  _next.addEventListener(Event.TRIGGERED, function(event:Event):void {
        _onScoring.dispatch(that);
      });
	  addChild(_next);
    }  
	
	private function medal(tween:GTween):void
    {
      var self:ScoreBoard = this;
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
          _medalTween.setValues( { x: 755, y: 370 } );
          _medalTween.onComplete = null;
          //_medalTween.autoPlay = false;   
      }
      
      if (_scores.total >= 400 && _scores.total < 600) {
        _medal = new Image(AssetRegistry.ScoringScalableAtlas.getTexture("medaille_bronze"));
        _medal.x = -800;
        _medal.y = 0;
        _medalSmall = new Image(AssetRegistry.ScoringAtlas.getTexture("bronze_small"));
     
      } else if (_scores.total >= 600 && _scores.total < 800) {
        _medal = new Image(AssetRegistry.ScoringScalableAtlas.getTexture("medaille_silber"));
        _medal.x = -800;
        _medal.y = 0;
        _medalSmall = new Image(AssetRegistry.ScoringAtlas.getTexture("silver_small"));
      } else if (_scores.total >= 800 && _scores.total < 1000) {
        _medal = new Image(AssetRegistry.ScoringScalableAtlas.getTexture("medaille_gold"));
        _medal.x = -800;
        _medal.y = 0;
        _medalSmall = new Image(AssetRegistry.ScoringAtlas.getTexture("gold_small"));
      } else if (_scores.total >= 1000) {
        _medal = new Image(AssetRegistry.ScoringScalableAtlas.getTexture("medaille_saphir"));
        _medal.x = -800;
        _medal.y = 0;
        _medalSmall = new Image(AssetRegistry.ScoringAtlas.getTexture("saphire_small"));
	  }


      if (_medal) {
        _medalTween = new GTween(_medal, 1.5, {x: 105, y: -100}, {ease: Elastic.easeInOut, onComplete: func});
        _tweens.push(_medalTween);
        addChild(_medal);
      }

    }
    private function startScoring():void
    {
      var self:ScoreBoard = this;
      var triggerLife:Function = function(tween:GTween):void{
        _tweens.push(new GTween(self, 2, {_lifeBonusCounter: _scores.lives * 100}, {ease: Exponential.easeOut, onComplete:triggerTotal}));
      }
      var triggerTime:Function = function(tween:GTween):void {
        if(!_scores.lost) {
          _tweens.push(new GTween(self, 2, { _timeBonusCounter: _scores.timeBonus }, { ease: Exponential.easeOut, onComplete:triggerLife } ));
        }
      }
      var triggerTotal:Function = function(tween:GTween):void{
        _tweens.push(new GTween(self, 2, {_totalCounter: _scores.total}, {ease: Exponential.easeOut, onComplete:medal}));
      }
	  
      _tweens.push(new GTween(this, 2, { _scoreCounter: _scores.score }, { ease: Exponential.easeOut, onComplete:triggerTime } ));
	  addEventListener(EnterFrameEvent.ENTER_FRAME,  updateTexts);
    }
    
    private function updateTexts(event:EnterFrameEvent):void
    {
      _lifeBonusText.text = String(_lifeBonusCounter);
      _timeBonusText.text = String(_timeBonusCounter * 5);
      _scoreText.text = String(_scoreCounter);
      _totalText.text = String(_totalCounter);
      //_EXPText.text = String(_EXPCounter);
    }
    
    private function addTexts():void
    {

      
      
      _lifeBonusText = new TextField(100, 35, "1", "kroeger 06_65", 35, Color.WHITE);
      _lifeBonusText.hAlign = HAlign.RIGHT;
      _lifeBonusText.x = _lifeBonusHeading.x + _lifeBonusHeading.width + 10;
      _lifeBonusText.y = _lifeBonusHeading.y;
      
      _scoreText = new TextField(100, 35, "1", "kroeger 06_65", 35, Color.WHITE);
      _scoreText.hAlign = HAlign.RIGHT;
      _scoreText.x = _lifeBonusText.x;
      _scoreText.y = _scoreHeading.y;
      
      _timeBonusText = new TextField(100, 35, "1", "kroeger 06_65", 35, Color.WHITE);
      _timeBonusText.hAlign = HAlign.RIGHT;
      _timeBonusText.x = _lifeBonusText.x;
      _timeBonusText.y = _timeBonusHeading.y;
      
      _totalText = new TextField(100, 35, "1", "kroeger 06_65", 35, Color.WHITE);
      _totalText.hAlign = HAlign.RIGHT;
      _totalText.x = _lifeBonusText.x;
      _totalText.y = _totalHeading.y;

      if ((_scores.level == 9 && SaveGame.endless) || _scores.level != 9){
        addChild(_lifeBonusText);
      }
      addChild(_scoreText);
      if (_scores.level != 9){
        addChild(_timeBonusText);}
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
      if (_scores.level != 9){
        addChild(_timeBonusHeading);
      }
      
      _lifeBonusHeading = new TextField(200, 40, "Life Bonus", "kroeger 06_65", 35, Color.WHITE);
      _lifeBonusHeading.x = _scoreHeading.x;
      _lifeBonusHeading.y = (_scores.level != 9) ? _timeBonusHeading.y + 60 : _scoreHeading.y + 60;
      _lifeBonusHeading.vAlign = VAlign.TOP;
      _lifeBonusHeading.hAlign = HAlign.LEFT;
      if (_scores.level == 9 && SaveGame.endless){
        addChild(_lifeBonusHeading);
      }
      
      _totalHeading = new TextField(200, 40, "Total", "kroeger 06_65", 35, Color.WHITE);
      _totalHeading.x = _scoreHeading.x;
      _totalHeading.y = _lifeBonusHeading.y + 80;
      _totalHeading.vAlign = VAlign.TOP;
      _totalHeading.hAlign = HAlign.LEFT;
      addChild(_totalHeading);
      
      
    }
	
	override public function dispose():void
	{
	  for each(var tween:GTween in _tweens) {
        trace("tweens ended");
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
      
      if(_medal != null)
        _medal.dispose();
        
      _medalTween = null;
      
      if(_medalSmall != null)
        _medalSmall.dispose();
	  
	}
  }
}