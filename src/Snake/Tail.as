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
  public class Tail extends TileSprite
  {
    
    private var _imageLeft:Texture;
    private var _imageDown:Texture;
    private var _imageRight:Texture;
    private var _imageUp:Texture;

    
    public function Tail(tileX:int, tileY:int, speed:Number)
    {
      makeImages(); 
      _image = new Image(_imageRight);
      _image.smoothing = TextureSmoothing.NONE;
      super(tileX, tileY, _image, speed);
      frameOffset = new Point(15, 15);
    }
    private function makeImages():void
    {
      _imageLeft = AssetRegistry.SnakeAtlas.getTexture("snake_tail_0");
      _imageRight = AssetRegistry.SnakeAtlas.getTexture("snake_tail_1");
      _imageUp = AssetRegistry.SnakeAtlas.getTexture("snake_tail_2");
      _imageDown = AssetRegistry.SnakeAtlas.getTexture("snake_tail_3");

    }
    override public function update(time:Number):void
    {
      super.update(time);
      if (facing != prevFacing)
      {
        switch (facing)
        {
          case AssetRegistry.UP: 
            _image.texture = _imageUp;
            break;
          case AssetRegistry.DOWN: 
            _image.texture = _imageDown;
            break;
          case AssetRegistry.RIGHT:
            _image.texture = _imageRight;
            break; 
          case AssetRegistry.LEFT: 
            _image.texture = _imageLeft;
            break;
        }
      }
    }
    public function get image():Image {
      return _image;
    }     

  }
}
