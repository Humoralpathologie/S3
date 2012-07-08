package Snake
{
  import engine.TileSprite;
  import starling.animation.Tween;
  import starling.display.DisplayObject;
  import starling.display.MovieClip;
  import starling.display.Sprite;
  import engine.AssetRegistry
  import starling.textures.Texture;
  import starling.core.Starling;
  import Snake.Head;
  import Snake.BodyPart;
  import Snake.Tail;
  
  /**
   * ...
   * @author
   */
  
  public class Snake extends Sprite
  {
    
    private var _head:Head;
    private var _speed:Number;
    private var _mps:int;
    //private var _body:Vector.<Snake.BodyPart>;
    private var _body:Array;
    private var _tail:Tail;
    private var _newPart:Snake.BodyPart = null;
    private var _eatenEggs:int = 0;
    private var _lives:int = 3;
    private var _oneeighty:int = 0;
    private var _oneeightyDirection:int;
    private var _bodyEggs:Sprite;
    private var _changedDirection:Boolean;
    
    public function Snake(mps:Number)
    {
      
      _head = new Head(5, 5, _speed, mps);
      
      _body = [];
      _bodyEggs = new Sprite();
      
      for (var i:int = 0; i < 4; i++)
      {
        var bodyPart:BodyPart = new BodyPart(_head.tileX - (i + 1), _head.tileY, _speed, AssetRegistry.EGGZERO);
        _body.push(bodyPart);
        _bodyEggs.addChild(bodyPart);
      }
      
      _tail = new Tail(_body[3].tileX - 1, _head.tileY, _speed);
      addChild(_tail);
      addChild(_bodyEggs);
      addChild(_head);
      
      this.mps = mps;
    }
    
    public function shuffle():void
    {
      function randomSort(a:*, b:*):Number
      {
        if (Math.random() < 0.5)
          return -1;
        else
          return 1;
      }
      _body.sort(randomSort);
    }
    
    public function faster():void
    {
      this.mps += 1;
    }
    
    public function eat(eggType:int):void
    {
      _eatenEggs++;
      _newPart = new BodyPart(-1, -1, _speed, eggType);
    }
    
    public function selfCollide():Boolean
    {
      for (var i:int = 0; i < _body.length; i++)
      {
        if (_head.tileX == _body[i].tileX && _head.tileY == _body[i].tileY)
        {
          return true;
        }
      }
      return false;
    }
    
    public function hit(x:int, y:int):Boolean
    {
      if (_head.tileX == x && _head.tileY == y)
      {
        return true;
      }
      
      for (var i:int = 0; i < _body.length; i++)
      {
        if (x == body[i].tileX && y == body[i].tileY)
        {
          return true;
        }
      }
      
      return false;
    }
    
    public function move():void
    {
      if (_oneeighty != 0)
      {
        _oneeighty--;
        if (_oneeightyDirection == AssetRegistry.RIGHT)
        {
          moveRight();
        }
        else
        {
          moveLeft();
        }
      }
      
      if (_newPart != null)
      {
        _body.push(_newPart);
        _newPart.tileX = -10;
        _newPart.tileY = -10;
        _tail.tileX = -10;
        _tail.tileY = -10;
        _bodyEggs.addChild(_newPart);
        _newPart = null;
      }
      
      var l:int = _body.length
      var a:Snake.BodyPart, b:Snake.BodyPart;
      a = body[l - 1];
      
      //move Tail
      _tail.tileX = _body[l - 1].tileX;
      _tail.tileY = _body[l - 1].tileY;
      _tail.prevFacing = _tail.facing;
      _tail.facing = _body[l - 1].facing;
      _tail.animateMove();
      
      for (var i:int = l - 1; i > 0; i--)
      {
        b = _body[i - 1];
        a.tileX = b.tileX;
        a.tileY = b.tileY;
        a.prevFacing = a.facing;
        a.facing = b.facing;
        a.animateMove();
        a = b;
      }
      
      a.tileX = _head.tileX;
      a.tileY = _head.tileY;
      a.prevFacing = a.facing;
      a.facing = _head.facing;
      a.animateMove();
      
      _head.advance();
      _changedDirection = false;
      
    }
    
    public function update(time:Number):void
    {
      _head.update(time);
      for (var i:int = 0; i < _body.length; i++)
      {
        _body[i].update(time);
      }
      _tail.update(time);
    }
    
    public function changeDirection(newDirection:int) {
      if(!_changedDirection){
        _head.facing = newDirection;
        _changedDirection = true;
      }
    }
    
    public function removeBodyPart(part:DisplayObject):void {
      _bodyEggs.removeChild(part);
      body.splice(body.indexOf(part), 1);
    }
    
    public function moveRight():void
    {
      switch (_head.facing)
      {
        case AssetRegistry.UP: 
          changeDirection(AssetRegistry.RIGHT);
          break;
        case AssetRegistry.LEFT: 
          changeDirection(AssetRegistry.UP);
          break;
        case AssetRegistry.DOWN: 
          changeDirection(AssetRegistry.LEFT);
          break;
        case AssetRegistry.RIGHT: 
          changeDirection(AssetRegistry.DOWN);
          break;
      }
    }
    
    public function moveLeft():void
    {
      
      switch (_head.facing)
      {
        case AssetRegistry.UP: 
          changeDirection(AssetRegistry.LEFT);
          break;
        case AssetRegistry.LEFT: 
          changeDirection(AssetRegistry.DOWN);
          break;
        case AssetRegistry.DOWN: 
          changeDirection(AssetRegistry.RIGHT);
          break;
        case AssetRegistry.RIGHT: 
          changeDirection(AssetRegistry.UP);
          break;
      }
    }
    
    public function oneeightyLeft():void
    {
      if (_oneeighty > 0) {
        return;
      }
      _oneeighty = 2;
      _oneeightyDirection = AssetRegistry.LEFT;
    }
    
    public function oneeightyRight():void
    {
      if (_oneeighty > 0) {
        return;
      }
      _oneeighty = 2;
      _oneeightyDirection = AssetRegistry.RIGHT;
      
    }
    
    public function get head():Snake.Head
    {
      return _head;
    }
    
    //public function get body():Vector.<Snake.BodyPart> 
    public function get body():Array
    {
      return _body;
    }
    
    public function get tail():Snake.Tail
    {
      return _tail;
    }
    
    public function get eatenEggs():int
    {
      return _eatenEggs;
    }
    
    public function get lives():int
    {
      return _lives;
    }
    
    public function set lives(value:int):void
    {
      _lives = value;
    }
    
    public function get mps():int
    {
      return _mps;
    }
    
    public function set mps(value:int):void
    {
      _speed = 1 / value;
      _mps = value;
      _head.mps = this.mps;
      _head.changed = false;
      _head.speed = _speed;
      for (var i:int = 0; i < _body.length; i++)
      {
        _body[i].speed = _speed;
      }
      _tail.speed = _speed
    }
    
    public function get speed():Number
    {
      return _speed;
    }
    
    public function get oneeighty():int
    {
      return _oneeighty;
    }
  
  }

}
