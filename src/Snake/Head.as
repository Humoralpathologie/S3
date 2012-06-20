package Snake
{
  import engine.TileSprite;
  import engine.AssetRegistry;
  import flash.geom.Point;
  import starling.core.Starling;
  import starling.display.MovieClip;
  import starling.textures.Texture;
  import starling.textures.TextureSmoothing;
  
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
    
    public function Head(tileX:int, tileY:int, speed:Number)
    {
      super(tileX, tileY, null, speed);
      makeHeadClips();
      
      frameOffset = new Point(15, 30);
      update(0);
    }
    
    private function makeHeadClips():void
    {
      var framesLeft:Vector.<Texture> = new Vector.<Texture>;
      framesLeft.push(AssetRegistry.SnakeAtlas.getTexture("snake_head_2"), AssetRegistry.SnakeAtlas.getTexture("snake_head_3"));
      _headLeft = new MovieClip(framesLeft, 2);
      _headLeft.smoothing = TextureSmoothing.NONE;
      
      var framesRight:Vector.<Texture> = new Vector.<Texture>;
      framesRight.push(AssetRegistry.SnakeAtlas.getTexture("snake_head_0"), AssetRegistry.SnakeAtlas.getTexture("snake_head_1"));
      _headRight = new MovieClip(framesRight, 2);
      _headRight.smoothing = TextureSmoothing.NONE;
      
      var framesDown:Vector.<Texture> = new Vector.<Texture>;
      framesDown.push(AssetRegistry.SnakeAtlas.getTexture("snake_head_6"), AssetRegistry.SnakeAtlas.getTexture("snake_head_7"));
      _headDown = new MovieClip(framesDown, 2);
      _headDown.smoothing = TextureSmoothing.NONE;
      
      var framesUp:Vector.<Texture> = new Vector.<Texture>;
      framesUp.push(AssetRegistry.SnakeAtlas.getTexture("snake_head_4"), AssetRegistry.SnakeAtlas.getTexture("snake_head_5"));
      _headUp = new MovieClip(framesUp, 2);
      _headUp.smoothing = TextureSmoothing.NONE;
      
      addChild(_headLeft);
      addChild(_headDown);
      addChild(_headRight);
      addChild(_headUp);
      
      Starling.juggler.add(_headLeft);
      Starling.juggler.add(_headDown);
      Starling.juggler.add(_headRight);
      Starling.juggler.add(_headUp);
    }
    
    override public function update(time:Number):void
    {
      super.update(time);
      _headUp.visible = false;
      _headDown.visible = false;
      _headLeft.visible = false;
      _headRight.visible = false;
      switch (facing)
      {
        case AssetRegistry.UP: 
          _headUp.visible = true;
          break;
        case AssetRegistry.DOWN: 
          _headDown.visible = true;
          break;
        case AssetRegistry.RIGHT: 
          _headRight.visible = true;
          break;
        case AssetRegistry.LEFT: 
          _headLeft.visible = true;
          break;
      }
    }
  /*
     public function set facing(value:int):void
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
   }*/
  }

}