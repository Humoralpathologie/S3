package UI 
{
  import Eggs.Egg;
  import flash.geom.Point;
  import Snake.Snake;
	import starling.display.Sprite;
  import starling.display.Image;
  import engine.AssetRegistry;
  import starling.core.Starling;
  import Eggs.Eggs;
  import starling.textures.TextureSmoothing;

	
	/**
     * ...
     * @author 
     */
  public class Radar extends Sprite 
  {

    private var _eggs:Vector.<Egg>;
    private var _snake:Snake.Snake;
    private var _radarEggPool:Vector.<RadarEgg>;
    
    private var _center:Point;
    private var _radius:int = 210;
    
    public function Radar(eggs:Eggs, snake:Snake) 
    {
      _eggs = eggs.eggPool;
      _snake = snake;

      var radarCircle:Image = new Image(AssetRegistry.SnakeAtlas.getTexture("KreisRadar"));    
      _center = new Point(Starling.current.nativeStage.stageWidth / 2, Starling.current.nativeStage.stageHeight / 2);
      radarCircle.x = _center.x - radarCircle.width / 2;
      radarCircle.y = _center.y - radarCircle.height / 2;
      radarCircle.smoothing = TextureSmoothing.NONE;
      addChild(radarCircle);
      
      fillPool();
    }
    
    private function fillPool():void {
      var radarEgg:RadarEgg;
      _radarEggPool = new Vector.<RadarEgg>;
      
      for (var i:int = 0; i < 20; i++) {
        radarEgg = new RadarEgg();
        radarEgg.visible = false;
        _radarEggPool.push(radarEgg);
      }
    }
    
    private function freshEgg():RadarEgg {
      var rEgg:RadarEgg = null;
      var i:int = 0;
      while (i < _radarEggPool.length && rEgg == null) {
        if (_radarEggPool[i].visible == false) {
          rEgg = _radarEggPool[i];
        }
        i++
      }
      if (rEgg == null) {
        rEgg = new RadarEgg();
        _radarEggPool.push(rEgg);
      }
      addChild(rEgg);
  
      return rEgg;
    }
    
    public function update():void {
      
      for (var k:int = 0; k < _radarEggPool.length; k++) {
        _radarEggPool[k].visible = false;
        removeChild(_radarEggPool[k]);
      }
      
      var rEgg:RadarEgg;
      var theta:Number;
      var dx:Number, dy:Number;
      

      for (var i:int = 0; i < _eggs.length; i++) {
        if (_eggs[i].visible) {
          rEgg = freshEgg();
          dx = _eggs[i].x - _snake.head.x;
          dy = _eggs[i].y - _snake.head.y;
          
          theta = Math.atan2(dy, dx);
          
          rEgg.type = _eggs[i].type;
          rEgg.x = (_center.x - (rEgg.width) / 2) + (_radius * Math.cos(theta));
          rEgg.y = (_center.y - (rEgg.height) / 2) + (_radius * Math.sin(theta));         
          rEgg.visible = true;
          
        }
      }
    }
        
  }

}