package Eggs
{
  import Snake.Snake;
  import starling.display.Sprite;
  import Eggs.Egg;
  
  /**
   * ...
   * @author
   */
  public class Eggs extends Sprite
  {
    private var _eggPool:Vector.<Egg>;
    
    public function Eggs()
    {
      super();
      _eggPool = new Vector.<Egg>;
    }
    
    public function spawnRandomEgg(tileWidth:int, tileHeight:int ):void
    {
      var egg:Egg = new Egg(Math.floor(Math.random() * tileWidth), Math.floor(Math.random() * tileHeight), Math.floor(Math.random() * 7));
      _eggPool.push(egg);
      addChild(egg);
    }
    
    public function addEgg(egg:Eggs.Egg):void {
      _eggPool.push(egg);
      addChild(egg);
    }
    
    public function get eggPool():Vector.<Egg>
    {
      return _eggPool;
    }
  
    public function hit(x:int, y:int):Boolean {
      for (var i:int = 0; i < _eggPool.length; i++) {
        if (_eggPool[i].tileX == x && _eggPool[i].tileY == y) {
          return true;
        }
      }
      return false;
    }
  }

}