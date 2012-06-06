package engine 
{
    import flash.geom.Point;
    import starling.animation.Tween;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.core.Starling;
	/**
     * ...
     * @author 
     */
  public class TileSprite extends Sprite
  {
 
    private var _tileX:int;
    private var _tileY:int;
    private var _frameOffset:Point;
    private var _facing:int;
    private var _prevFacing:int;
    private var _speed:Number;
    protected var _image:Image;
  
    public function TileSprite(tileX:int = 0, tileY:int = 0, image:Image = null, speed:Number = 0.3) 
    {
      super();
      _frameOffset = new Point(0, 0);

      this.tileX = tileX;
      this.tileY = tileY;
      this._image = image;

      _speed = speed;
      
      if(_image != null) {
        addChild(_image);
      }
      
      facing = AssetRegistry.RIGHT;     
      _prevFacing = facing;

    }
    
    public function advance():void {
      var tween:Tween = new Tween(this, _speed);
      switch(_prevFacing) {
        case AssetRegistry.UP:
            tileY -= 1;
            break;
        case AssetRegistry.DOWN:
            tileY += 1;
            break;
        case AssetRegistry.RIGHT:
            tileX += 1;
            break;
        case AssetRegistry.LEFT:
            tileX -= 1;
            break;
      }
      
      switch(_facing) {
         case AssetRegistry.UP:
            tween.animate("y", y - AssetRegistry.TILESIZE);
            break;
        case AssetRegistry.DOWN:
            tween.animate("y", y + AssetRegistry.TILESIZE);
            break;
        case AssetRegistry.RIGHT:
            tween.animate("x", x + AssetRegistry.TILESIZE);
            break;
        case AssetRegistry.LEFT:
            tween.animate("x", x - AssetRegistry.TILESIZE);
            break;       
      }
      _prevFacing = _facing;
      Starling.juggler.add(tween);
    }
    
    public function get tileX():int 
    {
        return _tileX;
    }
    
    public function set tileX(value:int):void 
    {
        _tileX = value;
        x = _tileX * AssetRegistry.TILESIZE - _frameOffset.x;
    }
    
    public function get tileY():int 
    {
        return _tileY;
    }
    
    public function set tileY(value:int):void 
    {
        _tileY = value;
        y = _tileY * AssetRegistry.TILESIZE - _frameOffset.y;
    }
    
    public function get facing():int 
    {
        return _facing;
    }
    
    public function set facing(value:int):void 
    {
        _facing = value;
    }
    
    public function get frameOffset():Point 
    {
        return _frameOffset;
    }
    
    public function set frameOffset(value:Point):void 
    {
        _frameOffset = value;
        tileX = tileX;
        tileY = tileY;
    }
    
  }

}