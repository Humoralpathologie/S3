package UI 
{
  import Eggs.Eggs;
  import Snake.Snake;
  import starling.display.Image;
	import starling.display.Sprite;
  import starling.textures.Texture;
  import engine.AssetRegistry;
  import starling.textures.TextureSmoothing;
	
	/**
     * ...
     * @author 
     */
  public class HUD extends Sprite 
  {       
    private var _eggs:Eggs;
    private var _radar:Radar;
    private var _snake:Snake;
    
    public function HUD(eggs:Eggs.Eggs, snake:Snake) 
    {
      _eggs = eggs;
      _snake = snake;
      
      var overlay:Image = new Image(AssetRegistry.SnakeAtlas.getTexture("UIOverlay"));
      overlay.smoothing = TextureSmoothing.NONE;
      
      addChild(overlay);
      
      _radar = new Radar(_eggs, _snake);
      
      addChild(_radar);
    }
    
    public function update():void {
      _radar.update();
    }
  }
}