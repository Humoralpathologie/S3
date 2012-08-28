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
    private var _scoreText:TextField;
    private var _tabBar:TabBar;
    private var _leaderboardShowing:String;
    protected var _sharedData:Object = {};
    
    public function Leaderboards(score:Object)
    {
      super();
      _score = score;
      addBoards();
      addButton();
      addTabBar();
      createLeaderboardText();
      
      _leaderboardShowing = "alltime";
      refreshLeaderboard();
    }
    
    private function refreshLeaderboard():void {
      _scoreText.text = "Loading...";
      Utils.getLeaderboard(_score.level, updateLeaderboard, _leaderboardShowing);
    }
    
    private function addTabBar():void {
      _tabBar = new TabBar();
      _tabBar.dataProvider = new ListCollection( [
        { label: AssetRegistry.Strings.ALLTIME },
        { label: AssetRegistry.Strings.WEEKLY },
        { label: AssetRegistry.Strings.PERSONAL}
        ]);
      _tabBar.onChange.add(function(bar:TabBar) {
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
        refreshLeaderboard();
      });
      _tabBar.width = _leaderboard.width;
      _tabBar.x = _leaderboard.x;
      _tabBar.y = _leaderboard.y;
      addChild(_tabBar);
    }
    
    override protected function initialize():void
    {
    
    }
    
    private function updateLeaderboard(data:Array, type:String):void {
      var txt:String = "";
      var count:int = 1;
      
      for each(var playerScore:Object in data) {
        txt += String(count) + ". ";
        if(type == "alltime" || type == "weekly") {
          txt += playerScore.Player.first_name;
          txt += ": ";
        }
        txt += playerScore.Score.score + " ";
        txt += playerScore.Score.created;
        txt += "\n";
        count++
        if (count > 9) {
          break;
        }
      }
      _scoreText.text = txt;
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
      _back = new Button(AssetRegistry.MenuAtlasAlpha.getTexture("arrow_reduced"));
      _back.scaleX = -1;
      _back.rotation = -Math.PI;
      _back.x = _leaderboard.x - _back.width;
      _back.y = _leaderboard.y + _back.height + 10;
      var that:Leaderboards = this;
      _back.addEventListener(Event.TRIGGERED, function(event:Event):void
        {
          _onLeaderboards.dispatch(that);
        });
      addChild(_back);
    }
    
    private function createLeaderboardText():void 
    {
        _scoreText = new TextField(_leaderboard.width, _leaderboard.height - (_leaderboardText.height + 40), "", "kroeger 06_65", 32, Color.WHITE);
        _scoreText.hAlign = HAlign.LEFT;
        _scoreText.vAlign = VAlign.TOP;
        _scoreText.x = _leaderboard.x + 20;
        _scoreText.y = _leaderboardText.y + _leaderboardText.height + 60;
        addChild(_scoreText);
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
  }
}