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
    private var _prev:Button;
    private var _next:Button;
    private var _leaderboardShowing:String;
    private var _page:int = 0;
    protected var _sharedData:Object = {};
    
    public static const REFRESH_LEADERBOARD:String = "refreshleaderboard";
    private var lid:String;
    
    public function Leaderboards(score:Object)
    {
      super();
      trace("personalScores: ");
      //SaveGame.personalScores;
      
      _score = score;
    
      lid = _score.lid;
      addBoards();
      addButton();
      addTabBar();
      createLeaderboardText();
      addPrevNextButtons();
      
      _leaderboardShowing = "alltime";
      
      addEventListener(REFRESH_LEADERBOARD, refreshLeaderboard);
      trace("Constructing");
    
    }
    
    private function addPrevNextButtons():void
    {
      _prev = new Button();
      _prev.label = AssetRegistry.Strings.PREV_PAGE;
      _prev.height = 50;
      _prev.width = _leaderboard.width / 2, _prev.x = _leaderboard.x;
      _prev.y = _leaderboard.y + _leaderboard.height - _prev.height;
      
      _next = new Button();
      _next.label = AssetRegistry.Strings.NEXT_PAGE;
      _next.height = _prev.height;
      _next.width = _prev.width;
      _next.x = _prev.x + _prev.width;
      _next.y = _prev.y;
      
      _prev.onRelease.add(function(btn:Button):void
        {
          if (_page > 1)
          {
            _page--;
            clearText();
            AssetRegistry.mogade.getScores(lid, currentScope, updateLeaderboard, {page: _page});
          }
        });
      
      _next.onRelease.add(function(btn:Button):void
      {
        _page++;
        clearText();
        AssetRegistry.mogade.getScores(lid, currentScope, updateLeaderboard, {page: _page});
      });
      
      addChild(_prev);
      addChild(_next);
    }
        
    private function refreshLeaderboard(evt:Event = null):void
    {
      if (SaveGame.isArcade){
        if (SaveGame.endless)
			  {
				  lid = "5041f5ac563d8a632f001f73";
			  }
			  else
			  {
				  lid = "5041f594563d8a570c0024a4";
			  }
      } 
      trace("Refreshing leaderboard...");
      clearText();
      if (_leaderboardShowing == "personal")
      {
        updateLeaderboard({scores: SaveGame.getPersonalScores(lid)}, "personal");
      }
      else
      {
        AssetRegistry.mogade.getScores(lid, currentScope, updateLeaderboard, {username: SaveGame.userName, userkey: SaveGame.guid});
      }
    }
    
    private function get currentScope():int
    {
      var scope:int;
      switch (_leaderboardShowing)
      {
        case "alltime":
          scope = 3;
          break;
        case "weekly":
          scope = 2;
          break;
      
      }
      return scope;
    }
    
    private function addTabBar():void
    {
      _tabBar = new TabBar();
      _tabBar.dataProvider = new ListCollection([{label: AssetRegistry.Strings.ALLTIME}, {label: AssetRegistry.Strings.WEEKLY}, {label: AssetRegistry.Strings.PERSONAL}]);
      _tabBar.onChange.add(function(bar:TabBar)
        {
          var prevShowing:String = _leaderboardShowing;
          switch (bar.selectedIndex)
          {
            case 0:
              _leaderboardShowing = "alltime";
              _prev.visible = true;
              _next.visible = true;
              break;
            case 1:
              _leaderboardShowing = "weekly";
              _prev.visible = true;
              _next.visible = true;
              break;
            case 2:
              _leaderboardShowing = "personal";
              _prev.visible = false;
              _next.visible = false;
              break;
          }
          
          if (_leaderboardShowing != prevShowing)
          {
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
    
    private function updateLeaderboard(data:Object, type:String = "alltime"):void
    {
      if (data.error)
      {
        _scoreText.text = AssetRegistry.Strings.NO_NET_CONNECTION;
        return;
      }
      if (data.scores.length == 0) {
        _page--;
        AssetRegistry.mogade.getScores(lid, currentScope, updateLeaderboard, {username: SaveGame.userName, userkey: SaveGame.guid});        
        
        return;
      }
      _page = data.page;
      
      var count:int = 1 + (10 * (data.page - 1));
      if (type == "personal") {
        count = 1;
      }
      _scoreText.text = "";
      for each (var playerScore:Object in data.scores)
      {
        _countText.text += String(count) + ".\n";
        if (type == "alltime" || type == "weekly")
        {
          _nameText.text += playerScore.username + ":\n";
          _scoreText.x = _leaderboard.x + 350;
          _timeText.x = _leaderboard.x + 570;
          _scoreText.text += playerScore.points + "\n";
          _timeText.text += playerScore.dated.split("T")[0] + "\n";
        }
        else
        {
          _timeText.x = _leaderboard.x + 250;
          _scoreText.x = _leaderboard.x + 70;
          _scoreText.text += String(playerScore) + "\n";
        }
        
        count++;
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
      
      if (SaveGame.isArcade || _score.level == 7 || !SaveGame.levelUnlocked(_score.level + 1))
      {
        _back.width = 320;
        _back.x = 640;
      }
      else
      {
        _back.width = 240;
        _back.x = 720;
      }
      _back.height = 80;
      _back.y = Starling.current.stage.stageHeight - _back.height;
      
      var that:Leaderboards = this;
      _back.onRelease.add(function(button:Button):void
        {
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
      _countText.y = _leaderboardText.y + _leaderboardText.height + 30;
      addChild(_countText);
      
      _nameText = new TextField(_leaderboard.width, _leaderboard.height - (_leaderboardText.height + 40), "", "kroeger 06_65", 32, Color.WHITE);
      _nameText.hAlign = HAlign.LEFT;
      _nameText.vAlign = VAlign.TOP;
      _nameText.x = _leaderboard.x + 70;
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
    
    private function clearText():void 
    {
        _scoreText.text = "Loading...";
        _countText.text = "";
        _nameText.text = "";
        _timeText.text = "";
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
   
    override public function dispose():void
    {
      super.dispose();
      removeEventListener(REFRESH_LEADERBOARD, refreshLeaderboard);
    }
  }
}