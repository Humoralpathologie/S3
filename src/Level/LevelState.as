package Level
{
  import com.gskinner.motion.GTween;
  import Eggs.Egg;
  import Eggs.Eggs;
  import flash.geom.Point;
  import fr.kouma.starling.utils.Stats;
  import Snake.Snake;
  import starling.animation.Tween;
  import starling.core.Starling;
  import starling.display.DisplayObject;
  import starling.display.Image;
  import starling.display.Quad;
  import starling.display.Sprite;
  import starling.extensions.ParticleDesignerPS;
  import starling.extensions.ParticleSystem;
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
  import starling.utils.*;
  import Combo.*;
  import flash.utils.*;
  import flash.events.GestureEvent;
  import flash.events.TransformGestureEvent;
  import flash.media.Sound;
  import flash.events.Event;
  import flash.media.SoundTransform;
  import engine.ManagedStage;
  import engine.StageManager;
  import Menu.MainMenu;
  
  /**
   * ...
   * @author
   */
  public class LevelState extends ManagedStage
  {
    protected var _bg:Image;
    protected var _bgTexture:Texture;
    protected var _overlay:Image;
    private var _hud:HUD;
    private var _timer:Number = 0;
    protected var _snake:Snake;
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
    private var _zoom:Number = 3;
    private var _following:Snake.Head;
    private var _possibleSwipe:Boolean = false;
    private var _swipeY:int;
    private var _swipeMenu:Sprite;
    private var _paused:Boolean = false;
    private var _firstFrame:Boolean = true;
    private var _particlePool:Vector.<PDParticleSystem>;
    private var _sadSnake:Image;
    private var _evilSnake:Image;
    protected var _levelNr:int = 0;
    private var _won:Boolean = false;
    
    private var _bonusBarSprite:Sprite;
    private var _bonusBackSprite:Sprite;
    private var _bonusTimer:Number = 0; 
    private var _bonusBar:Quad;
    private var _bonusBack:Quad;
//		private static const sfx:Sound = new AssetRegistry.WinMusic() as Sound;
 
		private static const SilentSoundTransform:SoundTransform = new SoundTransform(0);
 
		private static function playSoundSilentlyEndlessly(evt:Event = null):void
		{
//			sfx.play(0, 1000, SilentSoundTransform).addEventListener(Event.SOUND_COMPLETE, playSoundSilentlyEndlessly, false, 0, true); // plays the sound with volume 0 endlessly
		}
        
    public function LevelState()
    {
      super();

      // Fix for laggy sound
      playSoundSilentlyEndlessly();
      
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
      
      for (var j:int = 0; j < 10; j++)
      {
        _eggs.spawnRandomEgg();
      }
      
      _levelStage.addChild(_eggs);
      
      _hud = new HUD(_eggs, _snake);
      addChild(_hud);
      
      _particles = new PDParticleSystem(AssetRegistry.DrugParticleConfig, AssetRegistry.SnakeAtlas.getTexture("drugs_particle"));
      _levelStage.addChild(_particles);
      Starling.juggler.add(_particles);
      
      // Make the particle Systems for Combos;
      _particlePool = new Vector.<PDParticleSystem>;
      for (var i:int = 0; i < 10; i++) {
        _particlePool.push(new PDParticleSystem(AssetRegistry.ComboParticleConfig, AssetRegistry.SnakeAtlas.getTexture("shell")));
        _levelStage.addChild(_particlePool[i]);
      }      
      
      _text = new TextField(300, 200, "SNAKE", "kroeger 06_65", 30);
      _text.color = Color.WHITE;
      _text.hAlign = HAlign.LEFT;
      addChild(_text);
      
      _swipeMenu = new Sprite();
      var swipeBackground:Quad = new Quad(Starling.current.viewPort.width, 100, 0x000000);
      swipeBackground.alpha = 0.3;
            
      _swipeMenu.addChild(swipeBackground);     
      _swipeMenu.y = Starling.current.viewPort.height;
      addChild(_swipeMenu);
      
      var back:TextField = new TextField(300, 100, "BACK", "kroeger 06_65", 80, Color.WHITE);
      
      back.addEventListener(TouchEvent.TOUCH, 
        function(event:TouchEvent):void {
          var touch:Touch = event.getTouch(back, TouchPhase.ENDED);
          if (touch) {
            StageManager.switchStage(MainMenu);
          }
        });
      _swipeMenu.addChild(back);

      //create bonusbar
      _bonusBarSprite = new Sprite()
      _bonusBackSprite = new Sprite()
      _bonusBar = new Quad(1, 8);
      _bonusBack = new Quad(27, 10, 0x000000);
      
      _bonusBackSprite.addChild(_bonusBack);
      _bonusBarSprite.addChild(_bonusBar);
      
      _bonusBackSprite.alpha = 0;
      _bonusBarSprite.scaleX = 0;
      _levelStage.addChild(_bonusBarSprite);
      _levelStage.addChild(_bonusBackSprite);
      // For debugging. 
      Starling.current.showStats = true;
    }
    
    private function eggCollide():void
    {
      var eggs:Vector.<Egg> = _eggs.eggPool;
      var head:Snake.Head = _snake.head;
      
      for (var i:int = 0; i < eggs.length; i++)
      {
        if (head.tileX == eggs[i].tileX && head.tileY == eggs[i].tileY)
        {
          eatEgg(eggs[i]);
          _justAte = true;
          //peggle();
          _bonusTimer = 2.5;
        }
      }
    }
    
    private function screenCollide():void {
      if (_snake.head.tileX < 0 || _snake.head.tileY < 0 || _snake.head.tileX >= _bg.width / AssetRegistry.TILESIZE || _snake.head.tileY >= _bg.height / AssetRegistry.TILESIZE) {
        die();
      }
    }
    
    private function die():void {
      _snake.lives--;
      pause();
      
      _sadSnake = new Image(AssetRegistry.SnakeAtlas.getTexture("sadsnake"));
      _sadSnake.x = (Starling.current.viewPort.width - _sadSnake.width) / 2;
      _sadSnake.y = Starling.current.viewPort.height;
      addChild(_sadSnake);
      
      // Use a GTween, as the Starling tweens are paused.
      new GTween(_sadSnake, 2, { y: Starling.current.viewPort.height - _sadSnake.height } );
      
      removeEventListener(TouchEvent.TOUCH, onTouch);
      addEventListener(TouchEvent.TOUCH, dieScreenTouch);
      
    }
    
    private function dieScreenTouch(event:TouchEvent):void {
      var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
      if (touch) {
        removeChild(_sadSnake);
        removeEventListener(TouchEvent.TOUCH, dieScreenTouch);
        addEventListener(TouchEvent.TOUCH, onTouch);
        resetSnake();
        unpause();
      }
    }
    
    private function resetSnake():void {
      _snake.head.tileX = 5;
      _snake.head.tileY = 5;
      _snake.head.facing = AssetRegistry.RIGHT;
      _snake.head.prevFacing = _snake.head.facing;
    }
    
    private function showParticles(egg:DisplayObject):void {
      var pd:ParticleSystem;
      for (var i:int = 0; i < _particlePool.length; i++) {
        
      }      
      pd = _particlePool[0];
      pd.x = egg.x;
      pd.y = egg.y;
      
      pd.start(1);
      Starling.juggler.add(pd);
    }
    
    private function peggle():void
    {
      if (_snake.eatenEggs == 3)
      {
        new GTween(this, 0.5, {zoom: 5});
        new GTween(Starling.juggler, 0.5, { timeFactor: 0.1 } );
        AssetRegistry.WinMusicSound.play();
      }
    }
    
    private function eatEgg(egg:Egg):void
    {
      AssetRegistry.BiteSound.play();
      
      _particles.x = egg.x;
      _particles.y = egg.y;
      _particles.start(0.5);
      _eggs.eggPool.splice(_eggs.eggPool.indexOf(egg), 1);
      _eggs.removeChild(egg);
      _eggs.spawnRandomEgg();
            
      showPoints(egg, "2");
      
      if (egg.type < AssetRegistry.EGGROTTEN)
      {
        _snake.eat(egg.type);
      }
    }
    
    private function updateTimers(event:EnterFrameEvent):void
    {
      var passedTime:Number = event.passedTime * Starling.juggler.timeFactor;
      _timer += passedTime;
      _bonusTimer -= passedTime;
      _overallTimer += passedTime;
      _comboTimer -= passedTime;
    }
    
    private function updateBonusBar():void {
      _bonusBarSprite.x = _snake.head.x - 5;
      _bonusBarSprite.y = _snake.head.y - 15;
      _bonusBackSprite.x = _bonusBarSprite.x - 1;
      _bonusBackSprite.y = _bonusBarSprite.y - 1;
      trace(_bonusTimer)
     if (_bonusTimer > 0.5) {
        _bonusBackSprite.alpha = 0.6;
        _bonusBarSprite.scaleX = ((_bonusTimer - 0.5) / 2) * 25;
        
      } else {
        _bonusBarSprite.scaleX = 0;
        _bonusBackSprite.alpha = 0;
      } 


    }
    
    protected function addBackground():void
    {
      _bg = new Image(_bgTexture);
      _bg.smoothing = TextureSmoothing.NONE;
      _bg.blendMode = BlendMode.NONE;
      _levelStage.addChild(_eggs);
    }
    
    protected function removeAndExplodeCombo(combo:Array):void
    {
      var interval:int;
      var prefib:int = 2;
      var fib:int = 3;
      var temp:int = 0;
      var soundCounter:int = 0;
      var expoCounter:int = 0;
      
      for (var i:int = 0; i < combo.length; i++)
      {
        combo[i].removing = true;
      }
      
      var func:Function = function():void
      {
        if (combo.length > 0)
        {
          var egg:Snake.BodyPart = (combo.pop() as Snake.BodyPart);
          if (egg)
          {
            expoCounter++;
            _score += fib;
            var randColor:uint = Color.argb(256, Math.floor(Math.random() * 100) + 155, Math.floor(Math.random() * 255), Math.floor(Math.random() * 256));
            showPoints(egg, '+' + String(fib) + randColor);
            temp = fib;
            fib += prefib;
            prefib = temp;
            //_soundEffects[soundCounter].play();
            //AxParticleSystem.emit("combo", egg.x, egg.y);
            showParticles(egg);
            _snake.removeChild(egg);
            _snake.body.splice(_snake.body.indexOf(egg), 1);
            soundCounter++;
            setTimeout(func, (300 / (expoCounter * expoCounter)) + 80);
          }
        }
      }
      
      func();
    }
    
    private function showPoints(egg:DisplayObject, points:String, color:uint = 0xffffff):void {
      var text:TextField = new TextField(120, 120, points, "kroeger 06_65", 60);
      text.color = color;
      text.autoScale = true;
      text.hAlign = HAlign.CENTER;
      text.x = egg.x - 60;
      text.y = egg.y - 60;
      _levelStage.addChild(text);
      var tween:Tween = new Tween(text, 2, "linear");
      tween.animate("y", 0);
      tween.animate("scaleX", 3);
      tween.animate("scaleY", 3);
      tween.animate("x", 0);
      tween.animate("rotation", deg2rad(180));
      tween.fadeTo(0); 
      
      tween.onComplete = function():void {
        removeChild(text);
      }
      
      Starling.juggler.add(tween);
    }
    
    protected function doCombos():void
    {
      var combo:Object;
      var j:int, i:int;
      if (_currentCombos && _comboTimer <= 0)
      {
        for (j = 0; j < _currentCombos.length; j++)
        {
          combo = _currentCombos[j];
          removeAndExplodeCombo(combo.eggs);
          //combo.combo.effect(this);
          _combos += 1;
        }
        _currentCombos = null;
      }
      if (_justAte)
      {
        _justAte = false;
        trace("checking for combos");
        var bodyArray:Array = new Array();
        
        for (i = 0; i < _snake.body.length; i++)
        {
          if (!(_snake.body[i] as Snake.BodyPart).removing)
          {
            bodyArray.push(_snake.body[i]);
          }
        }
        
        var combos:Array = _comboSet.checkCombos(bodyArray);
        if (combos.length > 0)
        {
          _currentCombos = combos;
          for (j = 0; j < _currentCombos.length; j++)
          {
            combo = _currentCombos[j].eggs;
            for (i = 0; i < combo.length; i++)
            {
              combo[i].flicker(2);
            }
          }
        }
        _comboTimer = 2;
      }
    
    }
    
    private function snakeAi():void {
      var egg:Eggs.Egg = _eggs.eggPool[0];
      if (egg.tileX > _snake.head.tileX) {
        _snake.head.facing = AssetRegistry.RIGHT;
      } else if (egg.tileX < _snake.head.tileX) {
        _snake.head.facing = AssetRegistry.LEFT;
        
      } else if (egg.tileY < _snake.head.tileY) {
        _snake.head.facing = AssetRegistry.UP;
      } else if (egg.tileY > _snake.head.tileY){
        _snake.head.facing = AssetRegistry.DOWN;
      }
      _snake.head.prevFacing = _snake.head.facing;
    }
    
    private function onEnterFrame(event:EnterFrameEvent):void
    {
      var bodyArray:Array;
      var comboArray:Array;
      
      if(!_won) {
        checkWin();
      }
      
      if (!_paused)
      {
        
        updateBonusBar();
        snakeAi();
        
        if (_firstFrame) {
          _firstFrame = false;
        } else {
          updateTimers(event);
        }
        
        _text.text = String(_overallTimer.toFixed(2));
        _hud.update();
        
        _snake.update(event.passedTime * Starling.juggler.timeFactor);
        
        if (_timer >= _speed)
        {
          var startTimer:Number, endTimer:Number;
          startTimer = getTimer();
          _snake.move();
          endTimer = getTimer();
          
          trace("Moving took " +String(endTimer - startTimer) + "ms");
          
          doCombos();
          eggCollide();
          screenCollide();
          _timer -= _speed;
        }
        updateCamera();
        
      }
    
    }
    
    private function updateCamera():void
    {
      //_levelStage.x = Math.min(0, -_snake.head.x * 2 + Starling.current.nativeStage.stageWidth / 2);
      //_levelStage.y = Math.min(0, -_snake.head.y * 2 + Starling.current.nativeStage.stageHeight / 2);
      //_levelStage.x = - (_following.x + _following.frameOffset.x) + Starling.current.viewPort.width / 2;
      //_levelStage.y = - (_following.y + _following.frameOffset.x) + Starling.current.viewPort.height / 2;
      var a:Number, b:Number;
      a = _following.x + _following.frameOffset.x + 7;
      b = _following.y + _following.frameOffset.y + 7;
      _levelStage.x = -(a * _zoom) + Starling.current.viewPort.width / 2;
      _levelStage.y = -(b * _zoom) + Starling.current.viewPort.height / 2;
      
      _levelStage.x = Math.min(_levelStage.x, 0);
      _levelStage.y = Math.min(_levelStage.y, 0);
      // TODO: Should be computed only once.
      _levelStage.x = Math.max(-(_bg.width * _zoom) + Starling.current.viewPort.width, _levelStage.x);
      _levelStage.y = Math.max(-(_bg.height * _zoom) + Starling.current.viewPort.height, _levelStage.y);
    }
    
    private function pause():void
    {
      _paused = true;
      Starling.juggler.paused = true;
    }
    
    private function unpause():void
    {
      _paused = false;
      Starling.juggler.paused = false;
    }
    
    private function onTouch(event:TouchEvent):void
    {
      var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
      if (touch)
      {
        if (touch.getLocation(this).y > 400)
        {
          trace("Possible swipe!");
          _possibleSwipe = true;
          _swipeY = touch.getLocation(this).y;
        }
        else
        {
          _possibleSwipe = false;
          
        }
      }
      else
      {
        touch = event.getTouch(this, TouchPhase.ENDED);
        if (touch)
        {
          if (_possibleSwipe && Math.abs((_swipeY - touch.getLocation(this).y)) > 50)
          {
            trace("Swipe!");
            if (_swipeMenu.y == Starling.current.viewPort.height && _swipeY > touch.getLocation(this).y)
            {
              new GTween(_swipeMenu, 0.2, {"y": Starling.current.viewPort.height - _swipeMenu.height});
              pause();
            }
            else if (_swipeMenu.y == Starling.current.viewPort.height - _swipeMenu.height && _swipeY < touch.getLocation(this).y)
            {
              new GTween(_swipeMenu, 0.2, {"y": Starling.current.viewPort.height});
              unpause();
            }
          }
          else
          {
            if (_swipeMenu.y == Starling.current.viewPort.height)
            {
              if (touch.getLocation(this).x > 480)
              {
                _snake.moveRight();
              }
              else
              {
                _snake.moveLeft();
              }
            }
          }
        }
      }
    }
    
    protected function checkWin():void {
      
    }    
    
    protected function win():void {
      _won = true;
      pause();
      
      _evilSnake = new Image(AssetRegistry.SnakeAtlas.getTexture("snake_evillaugh"));
      _evilSnake.x = (Starling.current.viewPort.width - _evilSnake.width) / 2;
      _evilSnake.y = Starling.current.viewPort.height;
      addChild(_evilSnake);
      
      // Use a GTween, as the Starling tweens are paused.
      new GTween(_evilSnake, 2, { y: Starling.current.viewPort.height - _evilSnake.height } );
      
      removeEventListener(TouchEvent.TOUCH, onTouch);
      addEventListener(TouchEvent.TOUCH, dieScreenTouch);      
    }
    
    public function get zoom():Number
    {
      return _zoom;
    }
    
    public function set zoom(value:Number):void
    {
      _zoom = value;
      _levelStage.scaleX = _levelStage.scaleY = _zoom;
    }
    
  
  }

}
