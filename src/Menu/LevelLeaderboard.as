package Menu
{
  import com.gskinner.motion.easing.Exponential;
  import com.gskinner.motion.easing.Elastic;
  import com.gskinner.motion.GTween;
  import org.josht.starling.display.Image;
  import org.josht.starling.foxhole.controls.Screen;
  import org.josht.starling.foxhole.controls.TabBar;
  import org.josht.starling.foxhole.controls.PickerList;
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
  import starling.events.TouchEvent
  import starling.events.Touch;
  import starling.events.TouchPhase;
  
  /**
   * ...
   * @author
   */
  public class LevelLeaderboard extends Screen
  {
    private var _leaderboard:Quad;
    private var _leaderboardText:TextField;
    
    protected var _toExtras:Signal = new Signal(LevelLeaderboard);
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
    private var _lid:String;
    private var _list:PickerList;
    
    public function LevelLeaderboard(lid:String)
    {
      super();
      trace("personalScores: ");
      //SaveGame.personalScores;
      
      _lid = lid;
      addBoards();
      addButton();
      addTabBar();
      addDropDown();
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
            AssetRegistry.mogade.getScores(_lid, currentScope, updateLeaderboard, {page: _page});
          }
        });
      
      _next.onRelease.add(function(btn:Button):void
      {
        _page++;
        clearText();
        AssetRegistry.mogade.getScores(_lid, currentScope, updateLeaderboard, {page: _page});
      });
      
      addChild(_prev);
      addChild(_next);
    }
        
    private function refreshLeaderboard(evt:Event = null):void
    {
      trace("Refreshing leaderboard...");
      clearText();
      if (_leaderboardShowing == "personal")
      {
        updateLeaderboard({scores: SaveGame.getPersonalScores(_lid)}, "personal");
      }
      else
      {
        AssetRegistry.mogade.getScores(_lid, currentScope, updateLeaderboard, {username: SaveGame.userName, userkey: SaveGame.guid});
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
    
    private function addDropDown():void
    {
      _list = new PickerList();
      _list.dataProvider = new ListCollection([{label: AssetRegistry.Strings.LEVEL1NAME}, {label: AssetRegistry.Strings.LEVEL2NAME}, {label: AssetRegistry.Strings.LEVEL3NAME}, {label: AssetRegistry.Strings.LEVEL4NAME}, {label: AssetRegistry.Strings.LEVEL5NAME}, {label: AssetRegistry.Strings.LEVEL6NAME}, {label: AssetRegistry.Strings.LEVEL7NAME}]);
      _list.onChange.add(function(list:PickerList)
        {
          if (SaveGame.difficulty == 1) {
            switch (list.selectedIndex)
            {
              case 0:
                  _lid = "50421a39563d8a53c20021bb";
                break;
              case 1:
                  _lid = "50422eec563d8a72bd002104";
                break;
              case 2:
                  _lid = "50422efd563d8a72bd002107";
                break;
              case 3:
                  _lid = "50422f0d563d8a51b7002a38";
                break;
              case 4:
                  _lid = "50422f1f563d8a45d3002153";
                break;
              case 5:
                  _lid = "50422f31563d8a45d3002155";
                break;
              case 6:
                  _lid = "50422f41563d8a570c00263c";
                break;
            }
          } else {
            switch (list.selectedIndex)
            {
              case 0:
                 _lid = "50421a3f563d8a632f002091";
                break;
              case 1:
                 _lid = "50422ef5563d8a69f6002187";
                break;
              case 2:
                 _lid = "50422f06563d8a69f6002189";
                break;
              case 3:
                  _lid = "50422f17563d8a570c002638";
                break;
              case 4:
                  _lid = "50422f29563d8a570c00263a";
                break;
              case 5:
                  _lid = "50422f39563d8a72bd00210c";
                break;
              case 6:
                  _lid = "50422f4a563d8a45d300215a";
                break;
            }
          }
          dispatchEventWith(REFRESH_LEADERBOARD);
        });
      _list.width = _leaderboard.width;
      _list.listProperties.width = _list.width;
      _list.height = 70;
      _list.x = _leaderboard.x;
      _list.y = _leaderboard.y;
      addChild(_list);
      
    }
    private function addTabBar():void
    {
      _tabBar = new TabBar();
      _tabBar.dataProvider = new ListCollection([{label: AssetRegistry.Strings.ALLTIME}, {label: AssetRegistry.Strings.WEEKLY}]);
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
          }
          
          if (_leaderboardShowing != prevShowing)
          {
            refreshLeaderboard();
          }
        });
      _tabBar.width = _leaderboard.width;
      _tabBar.height = 70;
      _tabBar.x = _leaderboard.x;
      _tabBar.y = _leaderboard.y - 70;
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
        AssetRegistry.mogade.getScores(_lid, currentScope, updateLeaderboard, {page: _page});        
        
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
      
      _leaderboard = new Quad(800, 475, 0x545454);
      _leaderboard.alpha = 179 / 255;
      _leaderboard.x = 80;
      _leaderboard.y = 80;
      addChild(_leaderboard);
      
      /*
      _leaderboardText = new TextField(300, 40, AssetRegistry.Strings.LEADERBOARDS, "kroeger 06_65", 40, Color.WHITE);
      _leaderboardText.vAlign = VAlign.TOP;
      //_leaderboardText.hAlign = HAlign.LEFT;
      _leaderboardText.x = _leaderboard.x + (_leaderboard.width - _leaderboardText.width) / 2;
      _leaderboardText.y = _leaderboard.y + 20;
      addChild(_leaderboardText); */
    
    }
    
    private function addButton():void
    {
      //add x-button
      var xButton:Image = new Image(AssetRegistry.Alpha_1_Atlas.getTexture("x"));
      xButton.x = Starling.current.stage.stageWidth - xButton.width - 10;
      xButton.y = 90;
      var exit:Quad = new Quad(140, 250, 0xffffff);
      exit.alpha = 0;
      exit.x = Starling.current.stage.stageWidth - exit.width;
      exit.y = 80;
      var that:LevelLeaderboard = this;
      exit.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void
        {
          var touch:Touch = event.getTouch(exit, TouchPhase.ENDED);
          if (touch)
          {
            _toExtras.dispatch(that);
          }
        });
      addChild(xButton);
      addChild(exit); 
    }
    
    private function createLeaderboardText():void
    {
      _countText = new TextField(_leaderboard.width, _leaderboard.height - (_list.height + 40), "", "kroeger 06_65", 32, Color.WHITE);
      _countText.hAlign = HAlign.LEFT;
      _countText.vAlign = VAlign.TOP;
      _countText.x = _leaderboard.x + 20;
      _countText.y = _list.y + _list.height + 30;
      addChild(_countText);
      
      _nameText = new TextField(_leaderboard.width, _leaderboard.height - (_list.height + 40), "", "kroeger 06_65", 32, Color.WHITE);
      _nameText.hAlign = HAlign.LEFT;
      _nameText.vAlign = VAlign.TOP;
      _nameText.x = _leaderboard.x + 70;
      _nameText.y = _countText.y;
      addChild(_nameText);
      
      _scoreText = new TextField(_leaderboard.width, _leaderboard.height - (_list.height + 40), "", "kroeger 06_65", 32, Color.WHITE);
      _scoreText.hAlign = HAlign.LEFT;
      _scoreText.vAlign = VAlign.TOP;
      _scoreText.x = _leaderboard.x + 250;
      _scoreText.y = _countText.y;
      addChild(_scoreText);
      
      _timeText = new TextField(_leaderboard.width, _leaderboard.height - (_list.height + 40), "", "kroeger 06_65", 32, Color.WHITE);
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
    
    public function get toExtras():ISignal
    {
      return _toExtras;
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