package Level 
{
  import com.gskinner.motion.GTween;
  import Eggs.Egg;
  import Eggs.Eggs;
  import fr.kouma.starling.utils.Stats;
  import Snake.Snake;
  import starling.animation.Tween;
  import starling.core.Starling;
  import starling.display.DisplayObject;
  import starling.display.Image;
  import starling.display.Quad;
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
  import starling.utils.HAlign;
  import Combo.*;
  import flash.utils.*;
  import com.greensock.easing.Expo;
  
	
	/**
     * ...
     * @author 
     */
    public class LevelState extends Sprite 
    {      
      protected var _bg:Image;
      protected var _bgTexture:Texture;
      protected var _overlay:Image;
      private var _hud:HUD;
      private var _timer:Number = 0;
      private var _snake:Snake;
      private var _speed:Number = 0.3;
      protected var _levelStage:Sprite;
      private var _particles:PDParticleSystem;
      private var _eggs:Eggs;
      private var _overallTimer:Number = 0;
      private var _text:TextField;
      private var _comboSet:Combo.ComboSet;
      private var _justAte:Boolean = false;
      private var _comboTimer:Number = 0;
      private var _currentCombos:Array;
      private var _combos:int = 0;
      private var _score:int = 0;
      private var _zoom:int = 3;
      private var _following:Snake.Head;
        
      public function LevelState() 
      {
        super();
        AssetRegistry.init();           
        
        _currentCombos = null;
 
        _speed = 1 / 10;
        
        this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
        this.addEventListener(TouchEvent.TOUCH, onTouch);
        
        // Combos:
        
        _comboSet = new Combo.ComboSet();
        _comboSet.addCombo(new Combo.FasterCombo());
            
        // Level Stage.
        // TODO: Should probably be managed with a real camera.
        _levelStage = new Sprite();
        _levelStage.scaleX = _levelStage.scaleY = _zoom;
        addChild(_levelStage);

        addBackground();        
                
        _snake = new Snake(_speed);
        _following = _snake.head;
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
        
        _text = new TextField(300, 200, "SNAKE", "kroeger 06_65", 30);
        _text.color = Color.WHITE;
        _text.hAlign = HAlign.LEFT;
        addChild(_text);
                
        // For debugging. 
        Starling.current.showStats = true;
      }

      private function eggCollide():void {
        var eggs:Vector.<Egg> = _eggs.eggPool;
        var head:Snake.Head = _snake.head;
        
        for (var i:int = 0; i < eggs.length; i++) {
          if (head.tileX == eggs[i].tileX && head.tileY == eggs[i].tileY) {
            eatEgg(eggs[i]);
            _justAte = true;
          }
        }
      }
      
      private function eatEgg(egg:Egg):void {
        _particles.x = egg.x;
        _particles.y = egg.y;
        _particles.start(0.5);
        _eggs.eggPool.splice(_eggs.eggPool.indexOf(egg), 1);
        _eggs.removeChild(egg);
        _eggs.spawnRandomEgg();
        
        if(egg.type < AssetRegistry.EGGROTTEN) {
          _snake.eat(egg.type);
        }
      }
      
      private function updateTimers(event:EnterFrameEvent):void {
        _timer += event.passedTime;
        _overallTimer += event.passedTime;  
        _comboTimer -= event.passedTime;
      }
      
      protected function addBackground():void {
        _bg = new Image(_bgTexture);
        _bg.smoothing = TextureSmoothing.NONE;
        _bg.blendMode = BlendMode.NONE;     
        _levelStage.addChild(_eggs);        
      }
      
    protected function removeAndExplodeCombo(combo:Array):void {
      var interval:int;
      var prefib:int = 2;
      var fib:int = 3;
      var temp:int = 0;
      var soundCounter:int = 0;
      var expoCounter:int = 0;

      for(var i:int = 0; i < combo.length; i++) {
        combo[i].removing = true;
      }

      var func:Function = function():void {
        if(combo.length > 0) {
          var egg:Snake.BodyPart = (combo.pop() as Snake.BodyPart);
          if(egg) {
            expoCounter++;
            _score += fib;
            //showPoints(egg, '+' + String(fib), new AxColor(Math.random(), Math.random(), Math.random(), 1));
            temp = fib; 
            fib+= prefib;
            prefib = temp;
            //_soundEffects[soundCounter].play();
            //AxParticleSystem.emit("combo", egg.x, egg.y);
            _snake.removeChild(egg);
            _snake.body.splice(_snake.body.indexOf(egg), 1);
            soundCounter++;
            setTimeout(func, (300 / (expoCounter * expoCounter)) + 80 );
          } 
        }  
      }

      func();
    }      

    protected function doCombos():void {
      var combo:Object;
      var j:int, i:int;
      if (_currentCombos && _comboTimer <= 0) {
        for(j = 0; j < _currentCombos.length; j++) {
          combo = _currentCombos[j];
          removeAndExplodeCombo(combo.eggs);
          //combo.combo.effect(this);
          _combos += 1;
        }
        _currentCombos = null;
      }
      if (_justAte) {
        _justAte = false;
        trace("checking for combos");
        var bodyArray:Array = new Array();
        
        for(i = 0; i < _snake.body.length; i++) {
          if(!(_snake.body[i] as Snake.BodyPart).removing) {
            bodyArray.push(_snake.body[i]);
          }
        }
        
        var combos:Array = _comboSet.checkCombos(bodyArray);
        if(combos.length > 0) {
          _currentCombos = combos;
          for(j = 0; j < _currentCombos.length; j++) {
            combo = _currentCombos[j].eggs;
            for(i = 0; i < combo.length; i++) {
              combo[i].flicker(2);
            }
          }
        }
        _comboTimer = 2;
      }
      
    }
      
      private function onEnterFrame(event:EnterFrameEvent):void
      {
        updateCamera();
        
        var bodyArray:Array;
        var comboArray:Array;

        updateTimers(event);
        
        _text.text = String(_overallTimer.toFixed(2));
        _hud.update(); 
        
        if (_timer >= _speed) {
          _snake.move(); 
          
          doCombos();
          eggCollide();
          _timer -= _speed;
        }
        
      }
      
      private function updateCamera():void {        
        //_levelStage.x = Math.min(0, -_snake.head.x * 2 + Starling.current.nativeStage.stageWidth / 2);
        //_levelStage.y = Math.min(0, -_snake.head.y * 2 + Starling.current.nativeStage.stageHeight / 2);
        //_levelStage.x = - (_following.x + _following.frameOffset.x) + Starling.current.viewPort.width / 2;
        //_levelStage.y = - (_following.y + _following.frameOffset.x) + Starling.current.viewPort.height / 2;
        var a:int, b:int;
        a = _following.x + _following.frameOffset.x + 7;
        b = _following.y + _following.frameOffset.y + 7;
        _levelStage.x = - (a * _zoom) + Starling.current.viewPort.width / 2;
        _levelStage.y = - (b * _zoom) + Starling.current.viewPort.height / 2;
        
        _levelStage.x = Math.min(_levelStage.x, 0);
        _levelStage.y = Math.min(_levelStage.y, 0);
        // TODO: Should be computet only once.
        _levelStage.x = Math.max(-(_bg.width * _zoom) + Starling.current.viewPort.width, _levelStage.x);
        _levelStage.y = Math.max(-(_bg.height * _zoom) + Starling.current.viewPort.height, _levelStage.y);
      }
      
      private function onTouch(event:TouchEvent):void {
        var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
        if (touch) {
          if (touch.getLocation(this).x > 480) {
            _snake.moveRight();
          } else {
            _snake.moveLeft();
          }
        }        
      }
    }

}