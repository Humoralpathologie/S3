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
  import starling.core.StatsDisplay;
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
  import starling.events.KeyboardEvent;
  import engine.AssetRegistry;
  import UI.HUD;
  import UI.Radar;
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
  import Menu.LevelScore;
  import engine.SaveGame;
  
  /**
   * ...
   * @author
   */
  public class LevelState extends ManagedStage
  {
    protected var _bg:Image;
    protected var _bgTexture:Texture;
    protected var _overlay:Image;
    protected var _hud:HUD;
    private var _timer:Number = 0;
    protected var _snake:Snake;
    private var _speed:Number = 0.3;
    protected var _levelStage:Sprite;
    private var _particles:PDParticleSystem;
    protected var _eggs:Eggs;
    protected var _overallTimer:Number = 0;
    private var _comboSet:Combo.ComboSet;
    private var _justAte:Boolean = false;
    private var _comboTimer:Number = 0;
    private var _currentCombos:Array;
    protected var _combos:int = 0;
    protected var _score:int = 0;
    private var _zoom:Number = 2;
    private var _following:Snake.Head;
    private var _possibleSwipe:Boolean = false;
    private var _swipeY:int;
    private var _swipeMenu:Sprite;
    private var _paused:Boolean = false;
    private var _firstFrame:Boolean = true;
    private var _frameCounter:int = 0;
    private var _particlePool:Vector.<PDParticleSystem>;
    private var _sadSnake:Image;
    private var _evilSnake:Image;
    protected var _levelNr:int = 0;
    private var _won:Boolean = false;
    protected var _obstacles:Object = { };
    protected var _tileWidth:int = 0;
    protected var _tileHeight:int = 0;
    
		private static var sfx:Sound;
    private var _bonusTimer:Number = 0; 
    private var _bonusTimerPoints:Number = 0; 
    private var _bonusBar:Quad;
    private var _bonusBack:Quad;

 
		private static const SilentSoundTransform:SoundTransform = new SoundTransform(0);
 
		private static function playSoundSilentlyEndlessly(evt:Event = null):void
		{
			sfx.play(0, 1000, SilentSoundTransform).addEventListener(Event.SOUND_COMPLETE, playSoundSilentlyEndlessly, false, 0, true); // plays the sound with volume 0 endlessly
		}
        
    public function LevelState()
    {
      super();
      
      sfx = new AssetRegistry.Bite as Sound;

      // Fix for laggy sound
      playSoundSilentlyEndlessly();
      
      _currentCombos = null;
      
      _speed = 1 / 10;
      
      this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
      this.addEventListener(TouchEvent.TOUCH, onTouch);
      Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
      // Combos:
      
      _comboSet = new Combo.ComboSet();
      _comboSet.addCombo(new Combo.FasterCombo());
      
      // Level Stage.
      // TODO: Should probably be managed with a real camera.
      _levelStage = new Sprite();
      _levelStage.scaleX = _levelStage.scaleY = _zoom;
      addChild(_levelStage);
      
      addBackground();
      
      _tileHeight = Math.ceil(_bg.height / AssetRegistry.TILESIZE);
      _tileWidth = Math.ceil( _bg.width / AssetRegistry.TILESIZE);      
      
      addObstacles();
      
      _snake = new Snake(_speed);
      _following = _snake.head;
      _levelStage.addChild(_snake);
      
      addAboveSnake();
      
      _eggs = new Eggs();
      
      for (var j:int = 0; j < 10; j++)
      {
        _eggs.spawnRandomEgg(_tileWidth, _tileHeight);
      }
      
      _levelStage.addChild(_eggs);
      
      addHud(); 
      //_particles = new PDParticleSystem(AssetRegistry.DrugParticleConfig, AssetRegistry.SnakeAtlas.getTexture("drugs_particle"));
      _particles = new PDParticleSystem(AssetRegistry.EggsplosionParticleConfig, AssetRegistry.EggsplosionParticleTexture);
      _levelStage.addChild(_particles);
      _particles.blendMode = BlendMode.ADD;
      Starling.juggler.add(_particles);
      
      // Make the particle Systems for Combos;
      _particlePool = new Vector.<PDParticleSystem>;
      for (var i:int = 0; i < 10; i++) {
        _particlePool.push(new PDParticleSystem(AssetRegistry.ComboParticleConfig, AssetRegistry.SnakeAtlas.getTexture("shell")));
        _levelStage.addChild(_particlePool[i]);
      }      

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
      _bonusBar = new Quad(1, 8, 0xffffff);
      _bonusBack = new Quad(27, 10, 0x000000);
      
      
      _bonusBack.alpha = 0;
      _bonusBar.scaleX = 0;
      _levelStage.addChild(_bonusBack);
      _levelStage.addChild(_bonusBar);

    }
    
    protected function addHud():void {
      _hud = new HUD(new Radar(_eggs, _snake), ["lifes", "time"]);
      addChild(_hud);
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
        }
      }
    }
    
    protected function addAboveSnake():void {
      
    }
    
    protected function addObstacles():void {
      
    }
    
    private function obstacleCollide():void {
      if (_obstacles[_snake.head.tileY * _tileWidth + _snake.head.tileX]) {
        die();
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
      removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
      addEventListener(TouchEvent.TOUCH, dieScreenTouch);
      
    }
   
    private function _onKeyDown(event:KeyboardEvent):void {
      switch(event.keyCode) {
        case 40: //DOWN
          if (_snake.head.facing == AssetRegistry.RIGHT || _snake.head.facing == AssetRegistry.LEFT) {
            _snake.head.facing = AssetRegistry.DOWN;
          } 
        break;

        case 38: //UP
          if (_snake.head.facing == AssetRegistry.RIGHT || _snake.head.facing == AssetRegistry.LEFT) {
            _snake.head.facing = AssetRegistry.UP;
          } 
        break;

        case 39: //RIGHT
          if (_snake.head.facing == AssetRegistry.UP || _snake.head.facing == AssetRegistry.DOWN) {
            _snake.head.facing = AssetRegistry.RIGHT;
          } 
        break;

        case 37: //LEFT
          if (_snake.head.facing == AssetRegistry.UP || _snake.head.facing == AssetRegistry.DOWN) {
            _snake.head.facing = AssetRegistry.LEFT;
          } 
        break;

      }

    }
    
    private function dieScreenTouch(event:TouchEvent):void {
      var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
      if (touch) {
        removeChild(_sadSnake);
        removeEventListener(TouchEvent.TOUCH, dieScreenTouch);
        addEventListener(TouchEvent.TOUCH, onTouch);
        addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
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
      if (_snake.eatenEggs == 10)
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
      _eggs.spawnRandomEgg(_tileWidth, _tileHeight);
            
      showPoints(egg, "2");

      if (_bonusTimer > 0) {
        var randColor:uint = Color.argb(255, Math.floor(Math.random() * 100) + 155, Math.floor(Math.random() * 255), Math.floor(Math.random() * 256));
        _bonusTimerPoints += 2;
        showPoints(egg, "+" + String(_bonusTimerPoints), 20, randColor);
        _score += _bonusTimerPoints;
      } 
      _score += 2;
      
      if (egg.type < AssetRegistry.EGGROTTEN)
      {
        _snake.eat(egg.type);
      }
      _bonusTimer = 2.5;
      
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
      _bonusBar.x = _snake.head.x - 5;
      _bonusBar.y = _snake.head.y - 10;
      _bonusBack.x = _bonusBar.x - 1;
      _bonusBack.y = _bonusBar.y - 1;
      trace(_bonusTimer)
     if (_bonusTimer > 0.5) {
        _bonusBack.alpha = 0.3;
        _bonusBar.scaleX = ((_bonusTimer - 0.5) / 2) * 25;
        _bonusBar.color = Color.argb(255, (1 - ((_bonusTimer - 0.5) / 2)) * 255, ((_bonusTimer - 0.5) / 2) * 255, 0);
        
      } else {
        if (_bonusTimer <= 0) {
          _bonusTimerPoints = 0;
        }
        _bonusBar.scaleX = 0;
        _bonusBack.alpha = 0;
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
            showPoints(egg, '+' + String(fib), randColor);

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
    
    private function showPoints(egg:DisplayObject, points:String, offset:int = 0, color:uint = 0xffffff):void {
      var text:TextField = new TextField(120, 120, points, "kroeger 06_65", 60);
      text.color = color;
      text.autoScale = true;
      text.hAlign = HAlign.CENTER;
      text.x = 800 + offset;
      text.y = 500 + offset;
      addChild(text);
      var tween:Tween = new Tween(text, 2, "easeIn");
      tween.animate("y", offset);
      tween.animate("scaleX", 3);
      tween.animate("scaleY", 3);
      tween.animate("x", offset);
      tween.animate("rotation", deg2rad(45 - offset));
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
    
    protected function updateHud():void {
      _hud.radar.update(); 
      var _sec:String = (int(_overallTimer) % 60) < 10 ? "0" + String(int(_overallTimer) % 60) : String(int(_overallTimer) % 60);
      var _min:String = (int(_overallTimer) / 60) < 10 ? "0" + String(int(int(_overallTimer) / 60)) : String(int(int(_overallTimer) / 60));
      _hud.score = String(_score);
      _hud.lifesText = String(_snake.lives);
      _hud.timeText = _min + ":" + _sec; 
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
        
        //snakeAi();
        
        if (_firstFrame) {
          _firstFrame = false;
        } else {
          updateTimers(event);
        }
        
        updateHud();    
        var startTimer:Number, endTimer:Number;

        startTimer = getTimer();
        
        _snake.update(event.passedTime * Starling.juggler.timeFactor);        
        
        endTimer = getTimer();
          
        Starling.current.mCombo = endTimer - startTimer;        
        
        if (_timer >= _speed)
        {
          startTimer = getTimer();
          _snake.move();
          endTimer = getTimer();
          
          Starling.current.mMove = endTimer - startTimer;
          
          doCombos();
     
          eggCollide();
          screenCollide();
          obstacleCollide();
          _timer -= _speed;
        }
        
        updateBonusBar();
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
                //if (_snake.head.facing == AssetRegistry.DOWN) {
                //  _snake.moveLeft();
                //} else {
                  _snake.moveRight();
                //}
              }
              else
              {
                //if (_snake.head.facing == AssetRegistry.DOWN) {
                //   _snake.moveRight();                 
                //} else {
                  _snake.moveLeft();
                  
                //}
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
      removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
      addEventListener(TouchEvent.TOUCH, winScreenTouch);      
    }
    
    private function winScreenTouch(event:TouchEvent):void {
      var touch:Touch;
      touch = event.getTouch(this, TouchPhase.ENDED);
      if (touch) {
        var score:Object = {
          score: _score,
          lives: _snake.lives * 100,
          time: _overallTimer,
          level: _levelNr         
        }
        
        StageManager.switchStage(LevelScore, score);
        SaveGame.unlockLevel(_levelNr + 1);
      }
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
