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
    
    public function spawnRandomEgg():void
    {
      var egg:Egg = new Egg(Math.floor(Math.random() * (640 / 15)), Math.floor(Math.random() * (480 / 15)), Math.floor(Math.random() * 7));
      _eggPool.push(egg);
      addChild(egg);
    }
    
    public function get eggPool():Vector.<Egg>
    {
      return _eggPool;
    }
  
  }

}