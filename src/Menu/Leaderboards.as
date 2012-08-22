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
    
    public function Leaderboards(score:Object)
    {
      super();
      _score = score;
      addBoards();
      addButton();
      addRadioButtons();
      Utils.getLeaderboard(_score.level, updateLeaderboard);
    }
    
    override protected function initialize():void
    {
    
    }
    
    private function updateLeaderboard(data:Array) {
      var txt:String = "";
      var count:int = 1;
      
      for each(var playerScore:Object in data) {
        txt += String(count) + ". ";
        txt += playerScore.Player.first_name;
        txt += ": ";
        txt += playerScore.Score.score;
        txt += "\n";
        count++
      }
      
      _scoreText = new TextField(_leaderboard.width, _leaderboard.height - (_leaderboardText.height + 40), txt, "kroeger 06_65", 32, Color.WHITE);
      _scoreText.hAlign = HAlign.LEFT;
      _scoreText.vAlign = VAlign.TOP;
      _scoreText.x = _leaderboard.x + 20;
      _scoreText.y = _leaderboardText.y + _leaderboardText.height + 60;
      addChild(_scoreText);
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
    
    private function addRadioButtons():void
    {
      var leaderboardGroup:ToggleGroup = new ToggleGroup;
      var alltime:Radio = new Radio();
      alltime.label = AssetRegistry.Strings.ALLTIME;
      alltime.toggleGroup = leaderboardGroup;
      alltime.onPress.add(function(radio:Radio):void
        {
        //SaveGame.controlType = 1;
        });
      
      var weekly:Radio = new Radio;
      weekly.label = AssetRegistry.Strings.WEEKLY;
      weekly.toggleGroup = leaderboardGroup;
      weekly.onPress.add(function(radio:Radio):void
        {
        //SaveGame.controlType = 2;
        });
      
      var friends:Radio = new Radio();
      friends.label = AssetRegistry.Strings.FRIENDS;
      friends.toggleGroup = leaderboardGroup;
      friends.onPress.add(function(radio:Radio):void
        {
        //SaveGame.controlType = 1;
        });
      
      var personal:Radio = new Radio;
      personal.label = AssetRegistry.Strings.PERSONAL;
      personal.toggleGroup = leaderboardGroup;
      personal.onPress.add(function(radio:Radio):void
        {
        //SaveGame.controlType = 2;
        });
      
      alltime.x = _leaderboard.x + 20;
      weekly.x = _leaderboard.x + 215;
      friends.x = _leaderboard.x + 410;
      personal.x = _leaderboard.x + 605;
      
      alltime.y = _leaderboardText.y + _leaderboardText.height;
      weekly.y = alltime.y;
      friends.y = alltime.y;
      personal.y = alltime.y;
      
      addChild(alltime);
      addChild(weekly);
      addChild(friends);
      addChild(personal);
    }
    
    public function get onLeaderboards():ISignal
    {
      return _onLeaderboards;
    }
  }
}