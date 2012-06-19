package UI 
{
  import Eggs.Eggs;
  import flash.system.ImageDecodingPolicy;
  import Snake.Snake;
  import starling.display.Image;
	import starling.display.Sprite;
  import starling.text.TextField;
  import starling.textures.Texture;
  import engine.AssetRegistry;
  import starling.textures.TextureSmoothing;
  import starling.utils.HAlign;
  import starling.utils.Color;
  import starling.display.BlendMode;
  import starling.core.Starling;
	
	/**
     * ...
     * @author 
     */
  public class HUD extends Sprite 
  {       
    private var _radar:Radar;
    private var _overlay:Image;
    private var _scoreText:TextField;
    
    private var _lifes:Image = new Image(AssetRegistry.SnakeAtlas.getTexture("icon-lives"));
    private var _time:Image = new Image(AssetRegistry.SnakeAtlas.getTexture("icon-time"));
    private var _combo:Image = new Image(AssetRegistry.SnakeAtlas.getTexture("icon-combo"));
    private var _neededEggs:Image = new Image(AssetRegistry.SnakeAtlas.getTexture("icon-eggs"));
    private var _speed:Image = new Image(AssetRegistry.SnakeAtlas.getTexture("icon-speed"));

    private var _lifesText:TextField = new TextField(80, 50, "0", "kroeger 06_65", 45, Color.WHITE);
    private var _neededEggsText:TextField = new TextField(80, 50, "0", "kroeger 06_65", 45, Color.WHITE);
    private var _timeText:TextField = new TextField(80, 50, "0", "kroeger 06_65", 45, Color.WHITE);
    private var _comboText:TextField = new TextField(80, 50, "0", "kroeger 06_65", 45, Color.WHITE);
    private var _speedText:TextField = new TextField(80, 50, "0", "kroeger 06_65", 45, Color.WHITE);
 
    private var _icons:Object = {lifes: [_lifes, _lifesText, {x: 10, y: 10}],
                          eggs: [_neededEggs, _neededEggsText, {x: 105, y: 60}],
                          time: [_time, _timeText, {x: 105, y: 10}],
                          speed: [_speed, _speedText, {x: 105, y: 60}]
                          };
    public function HUD(radar:Radar, others:Array)//[lifes, eggs, time ...]; 
    {
      _radar = radar;
      _scoreText = new TextField(100, 50, "0", "kroeger 06_65", 45, Color.WHITE);
      _scoreText.x = Starling.current.viewPort.width/2 - _scoreText.width/2;
      _scoreText.y = 10;
      _scoreText.hAlign = HAlign.CENTER;

      _overlay = new Image(AssetRegistry.SnakeAtlas.getTexture("UIOverlay"));
      _overlay.smoothing = TextureSmoothing.NONE;
     
      for (var i:int; i < others.length; i++) {
        if(_icons[others[i]]) {
          var posX:int = _icons[others[i]][2].x;
          var posY:int = _icons[others[i]][2].y;
          _icons[others[i]][0].smoothing = TextureSmoothing.NONE;
          _icons[others[i]][0].scaleX = _icons[others[i]][0].scaleY = 2;
          _icons[others[i]][0].x = posX;
          _icons[others[i]][0].y = posY;
          addChild(_icons[others[i]][0]);
        }
      } 

      for (var j:int; j < others.length; j++){
        if(_icons[others[j]]) {
          _icons[others[j]][1].x = _icons[others[j]][0].x + _icons[others[j]][0].width + 15;
          _icons[others[j]][1].y = _icons[others[j]][0].y;
          _icons[others[j]][1].hAlign = HAlign.LEFT;
          addChild( _icons[others[j]][1]);
        }
      }

      addChild(_overlay);
      addChild(_scoreText);
      addChild(_radar);      
          
    }
    
    public function get radar():Radar {
      return _radar;
    }
    public function set lifesText(lifes:String):void {
      _lifesText.text = lifes;
    }
    public function set timeText(time:String):void {
      _timeText.text = time;
    }
    public function set comboText(combo:String):void {
      _comboText.text = combo;
    }
    public function set speedText(speed:String):void {
      _speedText.text = speed;
    }
    public function set eggsText(eggs:String):void {
      _neededEggsText.text = eggs;
    }
    public function set score(score:String):void {
      _scoreText.text = score;
    }
   
  }
}
