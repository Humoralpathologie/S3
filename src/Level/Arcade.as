package Level 
{
  import Eggs.Egg;
  import Eggs.Eggs;
  import fr.kouma.starling.utils.Stats;
  import Snake.Snake;
  import starling.core.Starling;
  import starling.display.Image;
	import starling.display.Sprite;
  import starling.extensions.ParticleDesignerPS;
  import starling.extensions.PDParticleSystem;
  import starling.text.TextField;
  import starling.textures.Texture;
  import starling.textures.TextureSmoothing;
  import starling.events.EnterFrameEvent;
  import starling.events.TouchEvent;
  import starling.events.Touch;
  import starling.events.TouchPhase;
  import engine.AssetRegistry;
  import UI.HUD;
  import flash.system.Capabilities;
  import starling.display.BlendMode;
  import starling.text.TextField;
  import starling.utils.Color;
  
	
	/**
     * ...
     * @author 
     */
    public class Arcade extends Sprite 
    {      
      private var _bg:Image;
      private var _hud:HUD;
      private var _timer:Number = 0;
      private var _snake:Snake;
      private var _speed:Number = 0.3;
      private var _levelStage:Sprite;
      private var _particles:PDParticleSystem;
      private var _eggs:Eggs;
        
      public function Arcade() 
      {
        super();
        AssetRegistry.init();       
        _speed = 1 / 10;
        
        this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
        this.addEventListener(TouchEvent.TOUCH, onTouch);
        
        _levelStage = new Sprite();
        _levelStage.scaleX = _levelStage.scaleY = 2;
        addChild(_levelStage);

        _bg = new Image(AssetRegistry.ArcadeBackground);
        _bg.smoothing = TextureSmoothing.NONE;
        _bg.blendMode = BlendMode.NONE;
            
        _levelStage.addChild(_bg);
               
        _snake = new Snake(_speed);
        _levelStage.addChild(_snake);
        
        _eggs = new Eggs();
        for (var j:int = 0; j < 10; j++) {
          _eggs.spawnRandomEgg();     
        }
        _levelStage.addChild(_eggs);
        
        _hud = new HUD(_eggs, _snake);
        addChild(_hud);
        
        _particles = new PDParticleSystem(AssetRegistry.DrugParticleConfig, AssetRegistry.DrugParticleTexture);
        _levelStage.addChild(_particles);
        Starling.juggler.add(_particles);
        
        var text:TextField = new TextField(300, 200, "SNAKE", "kroeger 06_65", 30);
        text.color = Color.WHITE;
        addChild(text);
                
        // For debugging. 
        // addChild(new Stats());
        Starling.current.showStats = true;
      }

      private function eggCollide():void {
        var eggs:Vector.<Egg> = _eggs.eggPool;
        var head:Snake.Head = _snake.head;
        
        for (var i:int = 0; i < eggs.length; i++) {
          if (head.tileX == eggs[i].tileX && head.tileY == eggs[i].tileY) {
            eatEgg(eggs[i]);
          }
        }
      }
      
      private function eatEgg(egg:Egg):void {
        _particles.x = egg.x - egg.width / 2;
        _particles.x = egg.y - egg.height / 2;
        _particles.start(0.5);
        _eggs.eggPool.splice(_eggs.eggPool.indexOf(egg), 1);
        _eggs.removeChild(egg);
        if(egg.type < AssetRegistry.EGGROTTEN) {
          _snake.eat(egg.type);
          _eggs.spawnRandomEgg();
        }
      }
      
      private function onEnterFrame(event:EnterFrameEvent):void
      {
        _timer += event.passedTime;
       
        trace("New Frame");
        
        _hud.update();
        
        _particles.x = _snake.head.x + 15;
        _particles.y = _snake.head.y + 30;        
        
        if (_timer >= _speed) {
          _snake.move();    
          eggCollide();
          _timer -= _speed;
        }
        _levelStage.x = Math.min(0, -_snake.head.x * 2 + Starling.current.nativeStage.stageWidth / 2);
        _levelStage.y = Math.min(0, -_snake.head.y * 2 + Starling.current.nativeStage.stageHeight / 2);
      }
      
      private function onTouch(event:TouchEvent):void {
        var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
        if (touch) {
          trace(touch.getLocation(this).x);
          if (touch.getLocation(this).x > 480) {
            _snake.moveRight();
          } else {
            _snake.moveLeft();
          }
        }
        
      }
    }

}