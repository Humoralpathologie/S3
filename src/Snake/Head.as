package Snake 
{
	import engine.TileSprite;
  import engine.AssetRegistry;
  import flash.geom.Point;
  import starling.core.Starling;
  import starling.display.MovieClip;
  import starling.textures.Texture;
	
	/**
     * ...
     * @author 
     */
  public class Head extends TileSprite 
  {
    private var _headLeft:MovieClip;
    private var _headRight:MovieClip;
    private var _headUp:MovieClip;
    private var _headDown:MovieClip;
    
    public function Head(tileX:int, tileY:int, speed:Number ) 
    {
      makeHeadClips();
      super(tileX, tileY, null, speed);
      frameOffset = new Point(15, 30);
    }
    
    private function makeHeadClips():void {
      var framesLeft:Vector.<Texture> = new Vector.<Texture>;
      framesLeft.push(AssetRegistry.SnakeAtlas.getTexture("snake_head_2"), AssetRegistry.SnakeAtlas.getTexture("snake_head_3"));
      _headLeft = new MovieClip(framesLeft, 2);
      
      var framesRight:Vector.<Texture> = new Vector.<Texture>;
      framesRight.push(AssetRegistry.SnakeAtlas.getTexture("snake_head_0"), AssetRegistry.SnakeAtlas.getTexture("snake_head_1"));
      _headRight = new MovieClip(framesRight, 2);  
      
      var framesDown:Vector.<Texture> = new Vector.<Texture>;
      framesDown.push(AssetRegistry.SnakeAtlas.getTexture("snake_head_6"), AssetRegistry.SnakeAtlas.getTexture("snake_head_7"));
      _headDown = new MovieClip(framesDown, 2);
 
      var framesUp:Vector.<Texture> = new Vector.<Texture>;
      framesUp.push(AssetRegistry.SnakeAtlas.getTexture("snake_head_4"), AssetRegistry.SnakeAtlas.getTexture("snake_head_5"));
      _headUp = new MovieClip(framesUp, 2);
      }    
    
    override public function set facing(value:int):void
    {
      super.facing = value;
      if(_image) {
        removeChild(_image);
        Starling.juggler.remove(_image as MovieClip);
      }
      
      switch(facing) {
         case AssetRegistry.UP:
            _image = _headUp;
            break;
        case AssetRegistry.DOWN:
            _image = _headDown;
            break;
        case AssetRegistry.RIGHT:
            _image = _headRight;
            break;
        case AssetRegistry.LEFT:
            _image = _headLeft;
            break;       
      }        
      
      addChild(_image);
      Starling.juggler.add(_image as MovieClip);
    }
  }

}