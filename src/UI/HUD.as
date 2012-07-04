package UI 
{
  import Eggs.Eggs;
  import flash.system.ImageDecodingPolicy;
  import Level.LevelState;
  import mx.core.ButtonAsset;
  import Snake.Snake;
  import starling.display.Button;
  import starling.display.Image;
	import starling.display.Sprite;
  import starling.events.Event;
  import starling.text.TextField;
  import starling.textures.Texture;
  import engine.AssetRegistry;
  import starling.textures.TextureSmoothing;
  import starling.utils.HAlign;
  import starling.utils.Color;
  import starling.display.BlendMode;
  import starling.core.Starling;
  import engine.SaveGame;
  import starling.events.TouchEvent;
  import starling.events.TouchPhase;
  import starling.events.Touch;
	
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
    private var _poison:Image = new Image(AssetRegistry.SnakeAtlas.getTexture("icon-poison"));

    private var _lifesText:TextField = new TextField(80, 50, "0", "kroeger 06_65", 45, Color.WHITE);
    private var _neededEggsText:TextField = new TextField(80, 50, "0", "kroeger 06_65", 45, Color.WHITE);
    private var _timeText:TextField = new TextField(150, 50, "0", "kroeger 06_65", 45, Color.WHITE);
    private var _comboText:TextField = new TextField(80, 50, "0", "kroeger 06_65", 45, Color.WHITE);
    private var _speedText:TextField = new TextField(80, 50, "0", "kroeger 06_65", 45, Color.WHITE);
    private var _poisonText:TextField = new TextField(80, 50, "0", "kroeger 06_65", 45, Color.WHITE);
 
    private var _icons:Object = {lifes: [_lifes, _lifesText, {x: 12, y: 12}],
                          combo: [_combo, _comboText, {x: 12, y: 70}],
                          eggs: [_neededEggs, _neededEggsText, {x: 12, y: 70}],
                          time: [_time, _timeText, {x: 108, y: 12}],
                          speed: [_speed, _speedText, {x: 108, y: 70}],
                          poison: [_poison, _poisonText, {x: 12, y: 70}]
                          };
                          
    // TODO: We dont need all these parameters
    
    public function HUD(radar:Radar, others:Array, levelstate:LevelState )//[lifes, eggs, time ...]; 
    {
      _radar = radar;
      _scoreText = new TextField(100, 50, "0", "kroeger 06_65", 45, Color.WHITE);
      _scoreText.x = Starling.current.stage.stageWidth / 2 - _scoreText.width/2;
      _scoreText.y = 0;
      _scoreText.hAlign = HAlign.CENTER;
      

      if (SaveGame.controlType == 1 || SaveGame.controlType == 2) {
        var bottom:Image = new Image(AssetRegistry.SnakeAtlas.getTexture("ui-180-bottom"));
        bottom.y = 190;
        addChild(bottom);
      }
      
      if (SaveGame.controlType == 4) {
        var left:Button = new Button(AssetRegistry.SnakeAtlas.getTexture("ui-4way-bottom-left"));
        left.y = 190;
        left.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void {
          if (event.getTouch(left, TouchPhase.BEGAN) && levelstate.snake.head.facing != AssetRegistry.RIGHT) {
            levelstate.snake.head.facing = AssetRegistry.LEFT;
          }
        });
        addChild(left);
        
        var right:Button = new Button(AssetRegistry.SnakeAtlas.getTexture("ui-4way-bottom-right"));
        right.y = 190;
        right.x = left.x + left.width;
        right.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void {        
          if ((event.getTouch(right, TouchPhase.BEGAN)) && levelstate.snake.head.facing != AssetRegistry.LEFT) {
            levelstate.snake.head.facing = AssetRegistry.RIGHT;
          }
        });
        addChild(right);
        
        var up:Button = new Button(AssetRegistry.SnakeAtlas.getTexture("ui-4way-bottom-up"));
        up.x = right.x + right.width;
        up.y = 190;
        up.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void {
          if (event.getTouch(up, TouchPhase.BEGAN) && levelstate.snake.head.facing != AssetRegistry.DOWN) {
            levelstate.snake.head.facing = AssetRegistry.UP;
          }
        });
        addChild(up);
        
        var down:Button = new Button(AssetRegistry.SnakeAtlas.getTexture("ui-4way-bottom-down"));
        down.x = up.x;
        down.y = up.y + up.height;
        down.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void {
          if (event.getTouch(down, TouchPhase.BEGAN) && levelstate.snake.head.facing != AssetRegistry.UP) {
            levelstate.snake.head.facing = AssetRegistry.DOWN;
          }
        });
        addChild(down);              
      }
      
      _overlay = new Image(AssetRegistry.SnakeAtlas.getTexture("ui-top"));
      _overlay.smoothing = TextureSmoothing.NONE;
      addChild(_overlay);
     
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
          _icons[others[j]][1].x = _icons[others[j]][0].x + _icons[others[j]][0].width + 12;
          _icons[others[j]][1].y = _icons[others[j]][0].y - 5;
          _icons[others[j]][1].hAlign = HAlign.LEFT;
          addChild( _icons[others[j]][1]);
        }
      }

      addChild(_scoreText);
      addChild(_radar);      
          
    }
    
    public function get radar():Radar {
      return _radar;
    }
    public function get poison():Image {
      return _poison;
    }
    public function get poisonTextField():TextField {
      return _poisonText;
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
      _speedText.text = String(int(speed) - 9);
    }
    public function set eggsText(eggs:String):void {
      _neededEggsText.text = eggs;
    }
    public function set poisonText(poison:String):void {
      _poisonText.text = poison;
    }
    public function set score(score:String):void {
      _scoreText.text = score;
    }
   
  }
}
