package Snake
{
  import engine.TileSprite;
  import flash.geom.Point;
  import starling.animation.IAnimatable;
  import starling.display.Image;
  import engine.AssetRegistry;
  import starling.textures.Texture;
  import starling.textures.TextureSmoothing;
  import flash.utils.*;
  import starling.events.Event;
  import starling.core.Starling;
  
  /**
   * ...
   * @author
   */
  public class BodyPart extends TileSprite implements IAnimatable
  {
    
    private var _imageLeft:Texture;
    private var _imageDown:Texture;
    private var _type:int;
    private var _removing:Boolean = false;
    private var _flickerRest:Number = 0;
    private var _flickerStep:Number = 0;
    private var _flickerCount:Number = 0;
    
    public function BodyPart(tileX:int, tileY:int, speed:Number, type:int = 0) // AssetRegistry.EGGZERO)
    {
      this.type = type;      
      _image = new Image(_imageDown);
      _image.smoothing = TextureSmoothing.NONE;
      super(tileX, tileY, _image, speed);
      frameOffset = new Point(15, 15);
    }
    
    public function flicker(n:Number = 2, tps:int = 10):void
    {
      if (_flickerRest <= 0)
      {
        Starling.juggler.add(this);
      }
      
      _flickerRest = n;
      _flickerStep = 1 / tps;
      _flickerCount = 0;
    }
    
    override public function update(time:Number):void
    {
      super.update(time);
      if (facing != prevFacing)
      {
        setImage();
      }
    }
    
    private function setImage():void
    {
      if (_image == null) {
        _image = new Image(_imageLeft);
      }
      switch (facing)
      {
        case AssetRegistry.UP: 
        case AssetRegistry.DOWN: 
          _image.texture = _imageLeft;
          break;
        case AssetRegistry.RIGHT: 
        case AssetRegistry.LEFT: 
          _image.texture = _imageDown;
          break;
      }
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
    
    public function set type(value:int):void
    {
      _type = value;
      switch (_type)
      {
        case AssetRegistry.EGGZERO: 
          _imageLeft = AssetRegistry.Alpha_1_Atlas.getTexture("snake_body_1");
          _imageDown = AssetRegistry.Alpha_1_Atlas.getTexture("snake_body_0");
          break;
        case AssetRegistry.EGGA: 
          _imageLeft = AssetRegistry.Alpha_1_Atlas.getTexture("snake_body_3");
          _imageDown = AssetRegistry.Alpha_1_Atlas.getTexture("snake_body_2");
          break;
        case AssetRegistry.EGGB: 
          _imageLeft = AssetRegistry.Alpha_1_Atlas.getTexture("snake_body_7");
          _imageDown = AssetRegistry.Alpha_1_Atlas.getTexture("snake_body_6");
          break;
        case AssetRegistry.EGGC: 
          _imageLeft = AssetRegistry.Alpha_1_Atlas.getTexture("snake_body_9");
          _imageDown = AssetRegistry.Alpha_1_Atlas.getTexture("snake_body_8");
          break;
        case AssetRegistry.EGGROTTEN: 
          _imageLeft = AssetRegistry.Alpha_1_Atlas.getTexture("snake_body_5");
          _imageDown = AssetRegistry.Alpha_1_Atlas.getTexture("snake_body_4");
          break;
      }
      setImage();
    }
    
    public function advanceTime(time:Number):void
    {
      if (_flickerRest <= 0)
      {
        _image.visible = true;
        dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
      }
      _flickerCount += time;
      if (_flickerCount > _flickerStep)
      {
        _image.visible = !_image.visible;
        _flickerCount -= _flickerStep;
        _flickerRest -= _flickerStep;
      }
    }
    
    override public function dispose():void
    {
      _imageDown.dispose();
      _imageLeft.dispose();
      _image.dispose();
      super.dispose();
    }
    
    public function get img():Image {
      _image.x = x;
      _image.y = y;
      return _image;
    }
  }

}
