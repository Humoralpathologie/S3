package Eggs
{
  import Snake.Snake;
  import starling.display.Sprite;
  import Eggs.Egg;
  import engine.AssetRegistry;
  
  /**
   * ...
   * @author
   */
  public class Eggs extends Sprite
  {
    private var _eggPool:Vector.<Egg>;
    private var _length:int = 0;
    
    public function Eggs()
    {
      super();
      _eggPool = new Vector.<Egg>;
      touchable = false;
    }
    
    /*
    public function addEgg(egg:Eggs.Egg):void {
      _eggPool.push(egg);
      addChild(egg);
    }
    */
    // Strange bug. AssetRegistry.EGGZERO 
    public function recycleEgg(tileX:int = 0, tileY:int = 0, type:int = 0):Eggs.Egg {
      var length:int;
      var egg:Eggs.Egg;
      length = _eggPool.length;
      // First try to find one with the right type.
      for (var i:int = 0; i < length; i++) {
        egg = _eggPool[i];
        if (!egg.visible && egg.type == type) {
          trace("Recycling Egg with right type.");
          egg.visible = true;
          egg.tileX = tileX;
          egg.tileY = tileY;
          addChild(egg);
          _length++;
          return(egg);
        }       
      }
      for (var i:int = 0; i < length; i++) {
        egg = _eggPool[i];
        if (!egg.visible) {
          trace("Recycling Egg.");
          egg.visible = true;
          egg.tileX = tileX;
          egg.tileY = tileY;
          egg.type = type;
          addChild(egg);
          _length++;
          return(egg);
        }
      }
      trace("Building new Egg.");
      egg = new Eggs.Egg(tileX, tileY, type);
      _eggPool.push(egg);
      addChild(egg);
      _length++;
      return egg;
    }
    
    public function get eggPool():Vector.<Egg>
    {
      return _eggPool;
    }
    
    public function get length():int 
    {
        return _length;
    }
    
    public function removeEgg(egg:Eggs.Egg):void {
      removeChild(egg);
      egg.visible = false;
      _length--;
    }
    
    public function overlapEgg(head:Snake.Head):Eggs.Egg {
      var length = _eggPool.length;
      var egg:Eggs.Egg;
      for (var i:int = 0; i < length; i++) {
        egg = _eggPool[i];
        if (egg.visible && head.tileX == egg.tileX && head.tileY == egg.tileY) {
          return egg;
        }
      }
      return null;
    }
    
    public function clear():void {
      for (var i:int = 0; i < _eggPool.length; i++) {
        removeChild(_eggPool[i]);
        _eggPool[i].dispose();
      }
      _eggPool.length = 0;
    }
  
    public function hit(x:int, y:int):Boolean {
      for (var i:int = 0; i < _eggPool.length; i++) {
        if (_eggPool[i].tileX == x && _eggPool[i].tileY == y) {
          return true;
        }
      }
      return false;
    }
    
    override public function dispose():void {
      var i:int = 0;
      
      if(_eggPool != null) {
        for (i = 0; i < _eggPool.length; i++) {
          _eggPool[i].dispose();
        }
        _eggPool = null;

      }
      
      super.dispose();
    }
    
  }

}