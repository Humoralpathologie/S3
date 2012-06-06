package Level 
{
  import fr.kouma.starling.utils.Stats;
  import Snake.Snake;
  import starling.core.Starling;
  import starling.display.Image;
	import starling.display.Sprite;
  import starling.text.TextField;
  import starling.textures.Texture;
  import starling.events.EnterFrameEvent;
  import starling.events.TouchEvent;
  import starling.events.Touch;
  import starling.events.TouchPhase;
  import engine.AssetRegistry;
  import UI.HUD;
  
	
	/**
     * ...
     * @author 
     */
    public class Arcade extends Sprite 
    {
      [Embed(source = "../../assets/Levels/arcade.png")] private static const Background:Class;
      
      private var _bg:Image;
      private var _hud:HUD;
      private var _timer:Number = 0;
      private var _snake:Snake;
      private var _speed:Number = 0.3;
        
      public function Arcade() 
      {
        super();
                
        new AssetRegistry();
        _speed = 1 / 10;
        
        this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
        this.addEventListener(TouchEvent.TOUCH, onTouch);

        var bgTexture:Texture = Texture.fromBitmap(new Background);
        _bg = new Image(bgTexture);
            
        addChild(_bg);
        
        _snake = new Snake(_speed);
        addChild(_snake);
        
        _hud = new HUD();
        addChild(_hud);
        
        // For debugging. 
        addChild(new Stats());
      }

      private function onEnterFrame(event:EnterFrameEvent):void
      {
        _timer += event.passedTime;
        if (_timer >= _speed) {
          _snake.move();    
          _timer -= _speed;
        }
      }
      
      private function onTouch(event:TouchEvent):void {
        var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
        if (touch) {
          if (touch.getLocation(this).x > Starling.current.viewPort.width / 2) {
            _snake.moveRight();
          } else {
            _snake.moveLeft();
          }
        }
        
      }
    }

}