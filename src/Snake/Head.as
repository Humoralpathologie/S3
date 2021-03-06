package Snake
{
  import engine.TileSprite;
  import engine.AssetRegistry;
  import flash.geom.Point;
  import starling.animation.IAnimatable;
  import starling.core.Starling;
  import starling.display.MovieClip;
  import starling.textures.Texture;
  import starling.textures.TextureSmoothing;
  
  /**
   * ...
   * @author
   */
  public class Head extends TileSprite implements IAnimatable
  {
    private var _headLeft:MovieClip;
    private var _headRight:MovieClip;
    private var _headUp:MovieClip;
    private var _headDown:MovieClip;
    private var _mps:Number;
    private var _newFramesLeft:Vector.<Texture> = new Vector.<Texture>;
    private var _newFramesRight:Vector.<Texture> = new Vector.<Texture>;
    private var _newFramesUp:Vector.<Texture> = new Vector.<Texture>;
    private var _newFramesDown:Vector.<Texture> = new Vector.<Texture>;
    private var _changed:Boolean = false;

    public function Head(tileX:int, tileY:int, speed:Number, mps:Number)
    {
      _mps = mps;
      super(tileX, tileY, null, speed);
      makeHeadClips();
      
      frameOffset = new Point(15, 30);
      update(0);
    }
    
    private function makeHeadClips():void
    {
      var framesLeft:Vector.<Texture> = new Vector.<Texture>;
      framesLeft.push(AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_2"), AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_3"));
      _headLeft = new MovieClip(framesLeft, 2);
      _headLeft.smoothing = TextureSmoothing.NONE;
      
      var framesRight:Vector.<Texture> = new Vector.<Texture>;
      framesRight.push(AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_0"), AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_1"));
      _headRight = new MovieClip(framesRight, 2);
      _headRight.smoothing = TextureSmoothing.NONE;
      
      var framesDown:Vector.<Texture> = new Vector.<Texture>;
      framesDown.push(AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_6"), AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_7"));
      _headDown = new MovieClip(framesDown, 2);
      _headDown.smoothing = TextureSmoothing.NONE;
      
      var framesUp:Vector.<Texture> = new Vector.<Texture>;
      framesUp.push(AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_4"), AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_5"));
      _headUp = new MovieClip(framesUp, 2);
      _headUp.smoothing = TextureSmoothing.NONE;
      
      addChild(_headLeft);
      addChild(_headDown);
      addChild(_headRight);
      addChild(_headUp);

    }
    
    public function advanceTime(time:Number):void {
      _headLeft.advanceTime(time);
      _headDown.advanceTime(time);
      _headRight.advanceTime(time);
      _headUp.advanceTime(time);
    }
    
    private function changeTexture():void
    {
      if (!_changed) {
        if (_mps < 12) {
          _newFramesRight[0] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_0");
          _newFramesRight[1] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_1");
          _newFramesLeft[0] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_2"); 
          _newFramesLeft[1] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_3");
          _newFramesUp[0] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_4");
          _newFramesUp[1] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_5");
          _newFramesDown[0] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_6");
          _newFramesDown[1] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_7");
        } else if (_mps >= 12 && _mps < 14) {
          _newFramesRight[0] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_8");
          _newFramesRight[1] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_9");
          _newFramesLeft[0] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_10"); 
          _newFramesLeft[1] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_11");
          _newFramesUp[0] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_12");
          _newFramesUp[1] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_13");
          _newFramesDown[0] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_14");
          _newFramesDown[1] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_15");
        } else if (_mps >= 14 && _mps < 19) {
          _newFramesRight[0] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_16");
          _newFramesRight[1] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_17");
          _newFramesLeft[0] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_18"); 
          _newFramesLeft[1] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_19");
          _newFramesUp[0] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_20");
          _newFramesUp[1] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_21");
          _newFramesDown[0] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_22");
          _newFramesDown[1] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_23");
        } else if (_mps >= 19 && _mps < 31){
          _newFramesRight[0] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_24");
          _newFramesRight[1] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_25");
          _newFramesLeft[0] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_26"); 
          _newFramesLeft[1] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_27");
          _newFramesUp[0] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_28");
          _newFramesUp[1] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_29");
          _newFramesDown[0] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_30");
          _newFramesDown[1] = AssetRegistry.Alpha_1_Atlas.getTexture("snake_head_31");
        }
        _headRight.setFrameTexture(0, _newFramesRight[0]);
        _headRight.setFrameTexture(1, _newFramesRight[1]);
        _headLeft.setFrameTexture(0, _newFramesLeft[0]);
        _headLeft.setFrameTexture(1, _newFramesLeft[1]);
        _headUp.setFrameTexture(0, _newFramesUp[0]);
        _headUp.setFrameTexture(1, _newFramesUp[1]);
        _headDown.setFrameTexture(0, _newFramesDown[0]);
        _headDown.setFrameTexture(1, _newFramesDown[1]);
        _changed = true;
      }
    }
    public function set changed(changed:Boolean):void {
      _changed = changed;
    }
    
    public function set mps(mps:Number):void {
      _mps = mps;
      changeTexture();      
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
    
    override public function dispose():void {
      _headDown.dispose();
      _headRight.dispose();
      _headUp.dispose();
      _headDown.dispose();
      super.dispose();
    }
  }

}
