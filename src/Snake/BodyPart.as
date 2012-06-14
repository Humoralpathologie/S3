package Snake
{
  import engine.TileSprite;
  import flash.geom.Point;
  import starling.display.Image;
  import engine.AssetRegistry;
  import starling.textures.Texture;
  import starling.textures.TextureSmoothing;
  import flash.utils.*;
  
  /**
   * ...
   * @author
   */
  public class BodyPart extends TileSprite
  {
    
    private var _imageLeft:Texture;
    private var _imageDown:Texture;
    private var _type:int;
    private var _removing:Boolean = false;
    
    public function BodyPart(tileX:int, tileY:int, speed:Number, type:int = AssetRegistry.EGGZERO)
    {
      _type = type;
      makeImages();
      _image = new Image(_imageDown);
      _image.smoothing = TextureSmoothing.NONE;
      super(tileX, tileY, _image, speed);
      frameOffset = new Point(15, 15);
    }
    
    private function makeImages():void
    {
      switch (_type)
      {
        case AssetRegistry.EGGZERO: 
          _imageLeft = AssetRegistry.SnakeAtlas.getTexture("snake_body_1");
          _imageDown = AssetRegistry.SnakeAtlas.getTexture("snake_body_0");
          break;
        case AssetRegistry.EGGA: 
          _imageLeft = AssetRegistry.SnakeAtlas.getTexture("snake_body_3");
          _imageDown = AssetRegistry.SnakeAtlas.getTexture("snake_body_2");
          break;
        case AssetRegistry.EGGB: 
          _imageLeft = AssetRegistry.SnakeAtlas.getTexture("snake_body_7");
          _imageDown = AssetRegistry.SnakeAtlas.getTexture("snake_body_6");
          break;
        case AssetRegistry.EGGC: 
          _imageLeft = AssetRegistry.SnakeAtlas.getTexture("snake_body_5");
          _imageDown = AssetRegistry.SnakeAtlas.getTexture("snake_body_4");
          break;
      }

    }
    
    public function flicker(n:Number = 2, tps:int = 5):void
    {
      var times:int = tps * n;
      var ms:Number = n * 1000 / times;
      var count:int = 0;
      _image.visible = false;      
      var func:Function = function():void
      {
        if (count < times)
        {
          count++;
          if (_image.visible)
          {
            _image.visible = false;
          }
          else
          {
            _image.visible = true;
          }
          setTimeout(func, ms);
        }
        else
        {
          _image.visible = true;
        }
      }
      func();
    }
    
    override public function update(time:Number):void
    {
      super.update(time);
      if (facing != prevFacing)
      {
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