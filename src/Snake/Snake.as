package Snake 
{
  import engine.TileSprite;
  import starling.animation.Tween;
  import starling.display.MovieClip;
	import starling.display.Sprite;
  import engine.AssetRegistry
  import starling.textures.Texture;
  import starling.core.Starling;
  import Snake.Head;
  import Snake.BodyPart;
	
	/**
     * ...
     * @author 
     */
  
  public class Snake extends Sprite 
  {
    
    private var _head:Head;
    private var _speed:Number;
    //private var _body:Vector.<Snake.BodyPart>;
    private var _body:Array;
    private var _newPart:Snake.BodyPart = null;
    private var _eatenEggs:int = 0;
    private var _lives:int = 3;
        
    public function Snake(speed:Number) 
    {
      _speed = speed;   
      
      _head = new Head(5, 5, _speed);
      
      addChild(_head);
            
      //_body = new Vector.<BodyPart>;
      _body = [];
      
      for (var i:int = 0; i < 4; i++) {
        var bodyPart:BodyPart = new BodyPart(_head.tileX - (i + 1), _head.tileY, _speed, AssetRegistry.EGGZERO);
        _body.push(bodyPart);
        addChild(bodyPart);
      }
    }
    
    public function eat(eggType:int):void {
      _eatenEggs++;
      _newPart = new BodyPart( -1, -1, _speed, eggType);
    }
    
    public function move():void {
      
      if (_newPart != null) {
        _body.push(_newPart);
        addChild(_newPart);
        _newPart = null;
      }
      
      var l:int = _body.length
      var a:Snake.BodyPart, b:Snake.BodyPart;
      a = body[l - 1];
      for (var i:int = l - 1; i > 0; i-- ) {
        b = _body[i - 1];
        a.tileX = b.tileX;
        a.tileY = b.tileY;
        a.facing = b.facing;
        a.animateMove();   
        a = b;
      }
      
      a.tileX = _head.tileX;
      a.tileY = _head.tileY;
      a.facing = _head.prevFacing;     
      a.animateMove();
      
      /*
      var l:int = _body.length;
      var a:Snake.BodyPart, b:Snake.BodyPart;
      //_body.reverse();
      
      a = _body[0];
      for (var i:int = 0; i < l - 1; i++) {
        b = _body[i + 1];
        a.tileX = b.tileX;
        a.tileY = b.tileY;
        a.facing = b.facing;
        a.animateMove();
        a = b;
      }
      
      a.tileX = _head.tileX;
      a.tileY = _head.tileY;
      a.facing = _head.prevFacing;
      a.animateMove();
      
      //_body.reverse();*/
      
      _head.advance();
    }
    
    public function update(time:Number):void {
      _head.update(time);
      for (var i:int = 0; i < _body.length; i++) {
        _body[i].update(time);
      }         
    }
    
    public function moveRight():void {
      switch(_head.facing) {
        case AssetRegistry.UP:
            _head.facing = AssetRegistry.RIGHT;
            break;
        case AssetRegistry.LEFT:
            _head.facing = AssetRegistry.UP;
            break;
        case AssetRegistry.DOWN:
            _head.facing = AssetRegistry.LEFT;
            break;
        case AssetRegistry.RIGHT:
            _head.facing = AssetRegistry.DOWN;
            break;
      }
      _head.prevFacing = _head.facing;
    }
    
    public function moveLeft():void {
      switch(_head.facing) {
        case AssetRegistry.UP:
            _head.facing = AssetRegistry.LEFT;
            break;
        case AssetRegistry.LEFT:
            _head.facing = AssetRegistry.DOWN;
            break;
        case AssetRegistry.DOWN:
            _head.facing = AssetRegistry.RIGHT;
            break;
        case AssetRegistry.RIGHT:
            _head.facing = AssetRegistry.UP;
            break;
      }
      _head.prevFacing = _head.facing;
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
    
    public function get speed():Number {
      return _speed;
    }    
  }

}
