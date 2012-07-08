package Eggs 
{
	import engine.TileSprite;
  import starling.textures.Texture;
	import starling.display.Image;
  import engine.AssetRegistry
  import starling.display.MovieClip;
  import flash.geom.Point;
  import starling.textures.TextureSmoothing;
  import starling.core.Starling;
	
	/**
     * ...
     * @author 
     */
  public class Egg extends TileSprite 
  {
    private var _type:int = 0;
    
    public function Egg(tileX:int = 0, tileY:int = 0, type:int = AssetRegistry.EGGZERO) 
    {
      super(tileX, tileY, null, 1000);   
      this.type = type;
      frameOffset = new Point(1, 6);
    }
         
    
    public function get type():int 
    {
        return _type;
    }
    
    public function set type(value:int):void {
      _type = value;
      var frames:Vector.<Texture> = new Vector.<Texture>;
      
      switch(_type) {
        case AssetRegistry.EGGZERO:
            frames.push(AssetRegistry.SnakeAtlas.getTexture("eggs_0"));
            frames.push(AssetRegistry.SnakeAtlas.getTexture("eggs_1"));        
            break;
        case AssetRegistry.EGGA:
            frames.push(AssetRegistry.SnakeAtlas.getTexture("eggs_2"));
            frames.push(AssetRegistry.SnakeAtlas.getTexture("eggs_3")); 
            break;
        case AssetRegistry.EGGB:
            frames.push(AssetRegistry.SnakeAtlas.getTexture("eggs_4"));
            frames.push(AssetRegistry.SnakeAtlas.getTexture("eggs_5")); 
            break;
        case AssetRegistry.EGGC:
            frames.push(AssetRegistry.SnakeAtlas.getTexture("eggs_6"));
            frames.push(AssetRegistry.SnakeAtlas.getTexture("eggs_7")); 
            break;          
        case AssetRegistry.EGGROTTEN:
            frames.push(AssetRegistry.SnakeAtlas.getTexture("eggs_10"));
            frames.push(AssetRegistry.SnakeAtlas.getTexture("eggs_11")); 
            break;   
        case AssetRegistry.EGGGOLDEN:
            frames.push(AssetRegistry.SnakeAtlas.getTexture("eggs_8"));
            frames.push(AssetRegistry.SnakeAtlas.getTexture("eggs_9")); 
            break;   
        case AssetRegistry.EGGSHUFFLE:
            frames.push(AssetRegistry.SnakeAtlas.getTexture("eggs_12"));
            frames.push(AssetRegistry.SnakeAtlas.getTexture("eggs_13")); 
            break;                
      }
         
      if (_image) {
        removeChild(_image);
        Starling.juggler.remove(_image as MovieClip);
        _image.dispose();
      }
      _image = new MovieClip(frames, 2);
      _image.smoothing = TextureSmoothing.NONE;
      addChild(_image);
      Starling.juggler.add(_image as MovieClip );      
    }
  }

}