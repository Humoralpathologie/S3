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
	
	/**
     * ...
     * @author 
     */
  public class HUD extends Sprite 
  {       
    private var _eggs:Eggs;
    private var _radar:Radar;
    private var _snake:Snake;
    private var _overlay:Image;
    private var _neededEggs:Image;
    private var _neededEggsText:TextField;
    
    public function HUD(eggs:Eggs.Eggs, snake:Snake) 
    {
      _eggs = eggs;
      _snake = snake;
      
      _overlay = new Image(AssetRegistry.SnakeAtlas.getTexture("UIOverlay"));
      _overlay.smoothing = TextureSmoothing.NONE;
     
      _neededEggs = new Image(AssetRegistry.SnakeAtlas.getTexture("icon-eggs"));
      _neededEggs.smoothing = TextureSmoothing.NONE;
      _neededEggs.scaleX = _neededEggs.scaleY = 2;
      
      _neededEggs.x = 105;
      _neededEggs.y = 65;
      
      _neededEggsText = new TextField(80, 50, "0", "kroeger 06_65", 45, Color.WHITE);
      _neededEggsText.x = _neededEggs.x + _neededEggs.width + 15;
      _neededEggsText.y = _neededEggs.y;
      
      _neededEggsText.hAlign = HAlign.LEFT;

      addChild(_overlay);
          
      addChild(_neededEggsText);     
      addChild(_neededEggs);
      
      _radar = new Radar(_eggs, _snake);
      
      addChild(_radar);
    }
    
    public function update():void {
      _radar.update();
      _neededEggsText.text = String(_snake.eatenEggs);
    }
  }
}