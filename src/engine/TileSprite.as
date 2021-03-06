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
    public var facing:int;
    public var prevFacing:int;
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
      prevFacing = facing;

    }
    
    public function advance():void {
      switch(facing) {
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
      prevFacing = facing;
      
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

      switch(facing) {
         case AssetRegistry.UP:
            _velocity.x = 0;
            _velocity.y = -15;
            break;
        case AssetRegistry.DOWN:
            _velocity.x = 0;
            _velocity.y = 15;
            break;
        case AssetRegistry.RIGHT:
            _velocity.x = 15;
            _velocity.y = 0;
            break;
        case AssetRegistry.LEFT:
            _velocity.x = -15;
            _velocity.y = 0;
            break;       
      } 
      
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
    
    public function get speed():Number 
    {
        return _speed;
    }
    
    public function set speed(value:Number):void 
    {
        _speed = value;
    }
    

    
  }

}
