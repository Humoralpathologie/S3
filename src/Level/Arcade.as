package Level 
{
  import fr.kouma.starling.utils.Stats;
  import Snake.Snake;
  import starling.core.Starling;
  import starling.display.Image;
	import starling.display.Sprite;
  import starling.text.TextField;
  import starling.textures.Texture;
  import starling.textures.TextureSmoothing;
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
      private var _levelStage:Sprite;
        
      public function Arcade() 
      {
        super();
                
        new AssetRegistry();
        _speed = 1 / 10;
        
        this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
        this.addEventListener(TouchEvent.TOUCH, onTouch);
        
        _levelStage = new Sprite();
        _levelStage.scaleX = _levelStage.scaleY = 2;
        addChild(_levelStage);

        var bgTexture:Texture = Texture.fromBitmap(new Background);
        _bg = new Image(bgTexture);
        _bg.smoothing = TextureSmoothing.NONE;
            
        _levelStage.addChild(_bg);
        
        _snake = new Snake(_speed);
        _levelStage.addChild(_snake);
        
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
        _levelStage.x = Math.min(0, -_snake.head.x * 2 + Starling.current.stage.stageWidth / 2);
        _levelStage.y = Math.min(0, -_snake.head.y * 2 + Starling.current.stage.stageHeight / 2);
      }
      
      private function onTouch(event:TouchEvent):void {
        var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
        if (touch) {
          if (touch.globalX > Starling.current.viewPort.width / 2) {
            _snake.moveRight();
          } else {
            _snake.moveLeft();
          }
        }
        
      }
    }

}