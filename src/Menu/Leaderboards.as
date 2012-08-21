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
  public class Leaderboards extends Screen
  {
	private var _leaderboard:Quad;
	private var _leaderboardText:TextField;
	
	protected var _onLeaderboards:Signal = new Signal(Leaderboards);
	private var _back:Button;
	public function Leaderboards()
    {
      super();
	  addBoards();
	  addButton();
    }
    
    override protected function initialize():void
    {
	
	}
	private function addBoards():void
    {
      
      _leaderboard = new Quad(820, 475, 0x545454);
      _leaderboard.alpha = 179 / 255;
      _leaderboard.x = 70;
      _leaderboard.y = 30;
      addChild(_leaderboard);
	  
	  _leaderboardText = new TextField(200, 35, "Leaderboard", "kroeger 06_65", 35, Color.WHITE);
      _leaderboardText.vAlign = VAlign.TOP;
      _leaderboardText.hAlign = HAlign.LEFT;
      _leaderboardText.x = _leaderboard.x + 20;
      _leaderboardText.y = _leaderboard.y + 20;      
      addChild(_leaderboardText);      
	  
	}
	private function addButton():void
	{
		_back = new Button(AssetRegistry.MenuAtlasAlpha.getTexture("arrow_reduced"));
		_back.scaleX = -1;
		_back.rotation =  - Math.PI;
		_back.x = _leaderboard.x - _back.width;
		_back.y = _leaderboard.y + _back.height + 10;
		var that:Leaderboards = this;
		_back.addEventListener(Event.TRIGGERED, function(event:Event):void {
			_onLeaderboards.dispatch(that);
		});
		addChild(_back);
	}
	public function get onLeaderboards():ISignal
    {
      return _onLeaderboards;
    }
  }
}