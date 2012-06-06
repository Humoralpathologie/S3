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
    
    private var _head:TileSprite;
    private var _speed:Number;
    private var _headTween:Tween;
    private var _body:Vector.<Snake.BodyPart>
        
    public function Snake(speed:Number) 
    {
      _speed = speed;   
      
      _head = new Head(5, 0, _speed);
      
      addChild(_head);
            
      _body = new Vector.<BodyPart>;
      
      for (var i:int = 0; i < 4; i++) {
        var bodyPart:BodyPart = new BodyPart(_head.tileX - (i + 1), _head.tileY, _speed);
        _body.push(bodyPart);
        addChild(bodyPart);
      }
    }
    
    public function move():void {
      _head.advance();
      for each(var bodyPart:Snake.BodyPart in _body) {
        bodyPart.advance();
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
        
  }

}