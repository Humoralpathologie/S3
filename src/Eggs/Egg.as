package Eggs
{
  import engine.TileSprite;
  import starling.textures.Texture;
  import starling.display.Image;
  import engine.AssetRegistry
  import starling.display.MovieClip;
  import flash.geom.Point;
  import starling.textures.TextureSmoothing;
  import starling.core.Starling;
  
  /**
   * ...
   * @author
   */
  public class Egg extends TileSprite
  {
    private var _type:int = 0;
    private static var _clips:Object;
    
    // Strange bug. AssetRegistry.EGGZERO
    public function Egg(tileX:int = 0, tileY:int = 0, type:int = 0)
    {
      super(tileX, tileY, null, 1000);
      if (_clips == null) {
        makeClips();
      }
      this.type = type;
      frameOffset = new Point(1, 6);
      touchable = false;
    }
    
    public function get type():int
    {
      return _type;
    }
    
    private function makeClips():void {
      _clips = { };
      var frames:Vector.<Texture> = new Vector.<Texture>;
      var eggTypeGraphics = {
        (int(AssetRegistry.EGGZERO)): ["eggs_0", "eggs_1"],
        (int(AssetRegistry.EGGA)): ["eggs_2", "eggs_3"],
        (int(AssetRegistry.EGGB)): ["eggs_4", "eggs_5"],
        (int(AssetRegistry.EGGC)): ["eggs_6", "eggs_7"],
        (int(AssetRegistry.EGGROTTEN)): ["eggs_10", "eggs_11"],
        (int(AssetRegistry.EGGGOLDEN)): ["eggs_8", "eggs_9"],
        (int(AssetRegistry.EGGSHUFFLE)): ["eggs_12", "eggs_13"]
      }
      
      for (var eggType in eggTypeGraphics) {
        var pics:Array;
        pics = eggTypeGraphics[eggType]
        frames = new Vector.<Texture>;
        frames.push(AssetRegistry.SnakeAtlas.getTexture(pics[0]));
        frames.push(AssetRegistry.SnakeAtlas.getTexture(pics[1]));
        _clips[int(eggType)] = frames;
      }
       
    }
    
    
    public function set type(value:int):void
    {
      _type = value;
      if (_image != null) {
        _image.dispose();
        removeChild(_image);
      }
      _image = new MovieClip(_clips[value], 1);
      addChild(_image);
      Starling.juggler.add(_image as MovieClip);
    }
    
    public function pinkify():void
    {
      if (_type == AssetRegistry.EGGROTTEN)
      {
        //Starling.juggler.remove(_image as MovieClip);        
        //_image.dispose();
        (_image as MovieClip).removeFrameAt(1);
        (_image as MovieClip).addFrame(AssetRegistry.SnakeAtlas.getTexture("rottenEggPink"));
      }
    }
    
    override public function dispose():void {
      _clips = null;
      super.dispose();
    }
  }

}