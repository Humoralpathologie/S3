package engine 
{
    import com.gskinner.motion.GTween;
    import starling.animation.Tween;
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
    protected var _tween:GTween;
    protected var _starlingTween:Tween;
    private var _velocity:Point;
    private var _tilesize:int;
  
    public function TileSprite(tileX:int = 0, tileY:int = 0, image:Image = null, speed:Number = 0.3) 
    {
      super();
      _frameOffset = new Point(0, 0);
      _velocity = new Point(0, 0);
      _tilesize = AssetRegistry.TILESIZE;

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
      switch(_prevFacing) {
        case AssetRegistry.UP:
            tileY -= 1;
            tileX = tileX;
            break;
        case AssetRegistry.DOWN:
            tileY += 1;
            tileX = tileX;
            break;
        case AssetRegistry.RIGHT:
            tileX += 1;
            tileY = tileY;
            break;
        case AssetRegistry.LEFT:
            tileX -= 1;
            tileY = tileY;
            break;
      }
      animateMove();
      _prevFacing = _facing;
      
    }
    
    private function calcPos():void
    {
      x = _tileX * _tilesize - _frameOffset.x;
      y = _tileY * _tilesize - _frameOffset.y;

    }
    
    public function update(time:Number):void {
      x += time * (_velocity.x / _speed);
      y += time * (_velocity.y / _speed);
    }    
    
    public function animateMove():void {
      /*
      if(_starlingTween == null) {
        _starlingTween = new Tween(this, _speed);
      } else {
        Starling.juggler.remove(_starlingTween);
        _starlingTween.reset(this, _speed);
      }*/
      
      switch(_facing) {
         case AssetRegistry.UP:
            //_tween.setValue("y", y - AssetRegistry.TILESIZE);
            //_starlingTween.animate("y", y - AssetRegistry.TILESIZE);
            _velocity.x = 0;
            _velocity.y = -15;
            break;
        case AssetRegistry.DOWN:
            //_tween.setValue("y", y + AssetRegistry.TILESIZE);
            //_starlingTween.animate("y", y + AssetRegistry.TILESIZE);
            _velocity.x = 0;
            _velocity.y = 15;
            break;
        case AssetRegistry.RIGHT:
            //_tween.setValue("x", x + AssetRegistry.TILESIZE);
            //_starlingTween.animate("x", x + AssetRegistry.TILESIZE);
            _velocity.x = 15;
            _velocity.y = 0;
            break;
        case AssetRegistry.LEFT:
            //_tween.setValue("x", x - AssetRegistry.TILESIZE);
            //_starlingTween.animate("x", x - AssetRegistry.TILESIZE);
            _velocity.x = -15;
            _velocity.y = 0;
            break;       
      } 
      //Starling.juggler.add(_starlingTween);
      
    }
    
    public function get tileX():int 
    {
        return _tileX;
    }
    
    public function set tileX(value:int):void 
    {
        _tileX = value;
        x = _tileX * _tilesize - _frameOffset.x;
    }
    
    public function get tileY():int 
    {
        return _tileY;
    }
    
    public function set tileY(value:int):void 
    {
        _tileY = value;
        y = _tileY * _tilesize - _frameOffset.y;
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
    
    public function get prevFacing():int 
    {
        return _prevFacing;
    }
    
    public function set prevFacing(value:int):void 
    {
        _prevFacing = value;
        facing = value;
    }

    
  }

}