package Menu
{
  import com.gskinner.motion.easing.Exponential;
  import com.gskinner.motion.easing.Elastic;
  import com.gskinner.motion.GTween;
  import org.josht.starling.display.Image;
  import org.josht.starling.foxhole.controls.Screen;
  import org.josht.starling.foxhole.controls.TabBar;
  import org.josht.starling.foxhole.controls.ToggleSwitch;
  import org.josht.starling.foxhole.data.ListCollection;
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
  import starling.utils.Color;
  import starling.utils.HAlign;
  import starling.utils.VAlign;
  import starling.textures.Texture;
  import Menu.MainMenu;
  import Menu.LevelScore;
  import starling.events.EnterFrameEvent;
  import org.josht.starling.foxhole.controls.Radio;
  import org.josht.starling.foxhole.core.ToggleGroup;
  import engine.Utils;
  
  /**
   * ...
   * @author
   */
  public class Leaderboards extends Screen
  {
    private var _leaderboard:Quad;
    private var _leaderboardText:TextField;
    
    protected var _onLeaderboards:Signal = new Signal(Leaderboards);
    private var _back:Button;
    private var _score:Object
    private var _countText:TextField;
    private var _nameText:TextField;
    private var _scoreText:TextField;
    private var _timeText:TextField;
    private var _tabBar:TabBar;
    private var _leaderboardShowing:String;
    protected var _sharedData:Object = { };
    
    public static const REFRESH_LEADERBOARD:String = "refreshleaderboard";
    
    public function Leaderboards(score:Object)
    {
      super();
      _score = score;
      addBoards();
      addButton();
      addTabBar();
      createLeaderboardText();
      
      _leaderboardShowing = "alltime";
      
      addEventListener(REFRESH_LEADERBOARD, refreshLeaderboard);
      trace("Constructing");
      
    }

    
    private function refreshLeaderboard(evt:Event = null):void {
      trace("Refreshing leaderboard...");
      _scoreText.text = "Loading...";
      _countText.text = "";
      _nameText.text = "";
      _timeText.text = "";
      
      AssetRegistry.mogade.getScores(_score.lid, 1, updateLeaderboard);
      
      //Utils.getLeaderboard(_score.level, updateLeaderboard, _leaderboardShowing);
    }
    
    private function addTabBar():void {
      _tabBar = new TabBar();
      _tabBar.dataProvider = new ListCollection( [
        { label: AssetRegistry.Strings.ALLTIME },
        { label: AssetRegistry.Strings.WEEKLY },
        { label: AssetRegistry.Strings.PERSONAL}
        ]);
      _tabBar.onChange.add(function(bar:TabBar) {
        var prevShowing:String = _leaderboardShowing;
        switch(bar.selectedIndex) {
          case 0:
            _leaderboardShowing = "alltime";
            break;
          case 1:
            _leaderboardShowing = "weekly";
            break;
          case 2:
            _leaderboardShowing = "personal";
            break;    
        }
        if(_leaderboardShowing != prevShowing) {
          refreshLeaderboard();
        }
      });
      _tabBar.width = _leaderboard.width;
      _tabBar.x = _leaderboard.x;
      _tabBar.y = _leaderboard.y;
      addChild(_tabBar);
    }
    
    override protected function initialize():void
    {
      trace("Initializing");
    }
    
    private function updateLeaderboard(data:Object, type:String = "alltime"):void {
      
      var count:int = 1;
      _scoreText.text = "";
      for each(var playerScore:Object in data.scores) {
        _countText.text += String(count) + ".\n";
        if (type == "alltime" || type == "weekly") {
          /*
          var _nameText:TextField = new TextField(_leaderboard.width, _leaderboard.height - (_leaderboardText.height + 40), "", "kroeger 06_65", 32, Color.WHITE);
          _nameText.hAlign = HAlign.LEFT;
          _nameText.vAlign = VAlign.TOP;
          _nameText.x = _leaderboard.x + 50;
          _nameText.y = _countText.y;*/
          _nameText.text += playerScore.username + ":\n";
          _scoreText.x = _leaderboard.x + 350;
          _timeText.x = _leaderboard.x + 570;
        } else {
          _nameText.text = "";
          _timeText.x =  _leaderboard.x + 250;
          _scoreText.x = _leaderboard.x + 50;
        }
        _scoreText.text += playerScore.points + "\n";  
        _timeText.text += playerScore.dated.split("T")[0] + "\n";
       
        count++;
        if (count > 8) {
          break;
        }
      }
   
      
    }
    
    private function addBoards():void
    {
      
      _leaderboard = new Quad(820, 475, 0x545454);
      _leaderboard.alpha = 179 / 255;
      _leaderboard.x = 70;
      _leaderboard.y = 30;
      addChild(_leaderboard);
      
      _leaderboardText = new TextField(300, 40, AssetRegistry.Strings.LEADERBOARDS, "kroeger 06_65", 40, Color.WHITE);
      _leaderboardText.vAlign = VAlign.TOP;
      //_leaderboardText.hAlign = HAlign.LEFT;
      _leaderboardText.x = _leaderboard.x + (_leaderboard.width - _leaderboardText.width) / 2;
      _leaderboardText.y = _leaderboard.y + 20;
      addChild(_leaderboardText);
    
    }
    
    private function addButton():void
    {
      _back = new Button();
      _back.label = AssetRegistry.Strings.SCOREBOARDBUTTON;
      
      if (SaveGame.isArcade || _score.level == 7){
      _back.width = 320;
      _back.x = 640;
    } else {
      _back.width = 240;
      _back.x = 720;
    }
    _back.height = 80;
    _back.y = Starling.current.stage.stageHeight - _back.height;
      
      var that:Leaderboards = this;
      _back.onRelease.add(function(button:Button):void {
        
          _onLeaderboards.dispatch(that);
      });
      addChild(_back);
    }
    
    private function createLeaderboardText():void 
    {
        _countText = new TextField(_leaderboard.width, _leaderboard.height - (_leaderboardText.height + 40), "", "kroeger 06_65", 32, Color.WHITE);
        _countText.hAlign = HAlign.LEFT;
        _countText.vAlign = VAlign.TOP;
        _countText.x = _leaderboard.x + 20;
        _countText.y = _leaderboardText.y + _leaderboardText.height + 60;
        addChild(_countText);
        
        _nameText = new TextField(_leaderboard.width, _leaderboard.height - (_leaderboardText.height + 40), "", "kroeger 06_65", 32, Color.WHITE);
        _nameText.hAlign = HAlign.LEFT;
        _nameText.vAlign = VAlign.TOP;
        _nameText.x = _leaderboard.x + 50;
        _nameText.y = _countText.y;
        addChild(_nameText);
        
        _scoreText = new TextField(_leaderboard.width, _leaderboard.height - (_leaderboardText.height + 40), "", "kroeger 06_65", 32, Color.WHITE);
        _scoreText.hAlign = HAlign.LEFT;
        _scoreText.vAlign = VAlign.TOP;
        _scoreText.x = _leaderboard.x + 250;
        _scoreText.y = _countText.y;
        addChild(_scoreText);
        
        _timeText = new TextField(_leaderboard.width, _leaderboard.height - (_leaderboardText.height + 40), "", "kroeger 06_65", 32, Color.WHITE);
        _timeText.hAlign = HAlign.LEFT;
        _timeText.vAlign = VAlign.TOP;
        _timeText.x = _leaderboard.x + 560;
        _timeText.y = _countText.y;
        addChild(_timeText);
    }
    
    public function get onLeaderboards():ISignal
    {
      return _onLeaderboards;
    }
    
      public function get sharedData():Object
    {
      return _sharedData;
    }
    
    public function set sharedData(value:Object):void
    {
      _sharedData = value;
    }
    
    override public function dispose():void {
      super.dispose();
      removeEventListener(REFRESH_LEADERBOARD, refreshLeaderboard);
    }
  }
}