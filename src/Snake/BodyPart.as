package Snake 
{
	import engine.TileSprite;
  import flash.geom.Point;
  import starling.display.Image;
  import engine.AssetRegistry;
  import starling.textures.TextureSmoothing;
  import flash.utils.*;
	
	/**
     * ...
     * @author 
     */
  public class BodyPart extends TileSprite 
  {
        
    private var _imageLeft:Image;
    private var _imageDown:Image;
    private var _type:int;
    private var _removing:Boolean = false;
    
    public function BodyPart(tileX:int, tileY:int, speed:Number, type:int = AssetRegistry.EGGZERO) 
    {
      _type = type;
      makeImages();
      super(tileX, tileY, null, speed);
      frameOffset = new Point(15, 15);
    }
    
    private function makeImages():void {
      switch(_type) {
        case AssetRegistry.EGGZERO:
            _imageLeft = new Image(AssetRegistry.SnakeAtlas.getTexture("snake_body_1"));
            _imageDown = new Image(AssetRegistry.SnakeAtlas.getTexture("snake_body_0"));
            break;
        case AssetRegistry.EGGA:
            _imageLeft = new Image(AssetRegistry.SnakeAtlas.getTexture("snake_body_3"));
            _imageDown = new Image(AssetRegistry.SnakeAtlas.getTexture("snake_body_2"));
            break;
        case AssetRegistry.EGGB:
            _imageLeft = new Image(AssetRegistry.SnakeAtlas.getTexture("snake_body_7"));
            _imageDown = new Image(AssetRegistry.SnakeAtlas.getTexture("snake_body_6"));
            break;
        case AssetRegistry.EGGC:
            _imageLeft = new Image(AssetRegistry.SnakeAtlas.getTexture("snake_body_5"));
            _imageDown = new Image(AssetRegistry.SnakeAtlas.getTexture("snake_body_4"));
            break;                                     
      }
      
      _imageLeft.smoothing = TextureSmoothing.NONE;
      _imageDown.smoothing = TextureSmoothing.NONE;
    }    
    
    public function flicker(n:Number = 2, tps:int = 5):void {
      var times:int = tps * n;
      var ms:Number = n * 1000 / times;
      var count:int = 0;
      _imageDown.visible = false;
      _imageLeft.visible = false;
      
      var func:Function = function ():void {
        if (count < times) {
          count++;
          if (_imageDown.visible) {
            _imageDown.visible = false;
            _imageLeft.visible = false;
          } else {
            _imageDown.visible = true;
            _imageLeft.visible = true;
          }
          setTimeout(func, ms);
        } else {
          _imageDown.visible = true;
          _imageLeft.visible = true;          
        }
      }
      func();
    }
    
    override public function set facing(value:int):void
    {
      super.facing = value;
      if(_image) {
        removeChild(_image);
      }
      
      switch(facing) {
        case AssetRegistry.UP:
        case AssetRegistry.DOWN:
            _image = _imageLeft;
            break;
        case AssetRegistry.RIGHT:
        case AssetRegistry.LEFT:
            _image = _imageDown;
            break;       
      }        
      
      addChild(_image);
    }        
    
    public function get type():int 
    {
        return _type;
    }
    
    public function get removing():Boolean 
    {
        return _removing;
    }
    
    public function set removing(value:Boolean):void 
    {
        _removing = value;
    }
  }

}