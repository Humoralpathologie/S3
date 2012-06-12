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
    private var _body:Vector.<Snake.BodyPart>
    private var _newPart:Snake.BodyPart = null;
    private var _eatenEggs:int = 0;
    private var _lives:int = 3;
        
    public function Snake(speed:Number) 
    {
      _speed = speed;   
      
      _head = new Head(5, 5, _speed);
      
      addChild(_head);
            
      _body = new Vector.<BodyPart>;
      
      for (var i:int = 0; i < 4; i++) {
        var bodyPart:BodyPart = new BodyPart(_head.tileX - (i + 1), _head.tileY, _speed, Math.floor(Math.random() * 4));
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
      
      for (var i:int = _body.length - 1; i >= 0; i-- ) {
        if (i == 0) {
          _body[i].tileX = _head.tileX;
          _body[i].tileY = _head.tileY;
          _body[i].facing = _head.prevFacing;
        } else {
          _body[i].tileX = _body[i - 1].tileX;
          _body[i].tileY = _body[i - 1].tileY;
          _body[i].facing = _body[i - 1].facing;
        }
        _body[i].animateMove();
      }
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
    }    
    
    public function get head():Snake.Head 
    {
        return _head;
    }
    
    public function get body():Vector.<Snake.BodyPart> 
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
        
  }

}