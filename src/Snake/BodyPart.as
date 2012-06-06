package Snake 
{
	import engine.TileSprite;
  import flash.geom.Point;
  import starling.display.Image;
  import engine.AssetRegistry;
  import starling.textures.TextureSmoothing;
	
	/**
     * ...
     * @author 
     */
  public class BodyPart extends TileSprite 
  {
        
    private var _imageLeft:Image;
    private var _imageDown:Image;
    private var _type:int;
    
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
  }

}