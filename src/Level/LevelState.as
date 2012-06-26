package Level
{
  import com.gskinner.motion.GTween;
  import Eggs.Egg;
  import Eggs.Eggs;
  import flash.geom.Point;
  import flash.geom.Rectangle;
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
    protected var _eggs:Eggs;
    private var _rottenEggs:Eggs.Eggs;
    protected var _overallTimer:Number = 0;
    private var _text:TextField;
    protected var _comboSet:Combo.ComboSet;
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
    private var _sadText:Image;
    private var _evilSnake:Image;
    private var _evilText:Image;
    protected var _levelNr:int = 0;
    private var _won:Boolean = false;
    private var _lost:Boolean = false;
    protected var _obstacles:Object = {};
    protected var _tileWidth:int = 0;
    protected var _tileHeight:int = 0;
    private var _camerax:Number = 0;
    private var _cameray:Number = 0;
    
    private static var sfx:Sound;
    private var _bonusTimer:Number = 0;
    private var _bonusTimerPoints:Number = 0;
    private var _bonusBar:Quad;
    private var _bonusBack:Quad;
    
    protected var _rottenTimer:Number = 0;
    protected var _rottenEnabled:Boolean = false;
    protected var _particles:Object;
    
    protected var _startPos:Point = new Point(5, 5);
    protected var _levelBoundaries:Rectangle;
    protected var _timeLeft:Number = 3 * 60;
    protected var _poisonEggs:int = 0;
    
    private static const SilentSoundTransform:SoundTransform = new SoundTransform(0);
    
    private static const WINDOW:Number = 100;
    
    private static function playSoundSilentlyEndlessly(evt:Event = null):void
    {
      sfx.play(0, 1000, SilentSoundTransform).addEventListener(Event.SOUND_COMPLETE, playSoundSilentlyEndlessly, false, 0, true); // plays the sound with volume 0 endlessly
    }
    
    public function LevelState()
    {
      super();
      
      sfx = AssetRegistry.WinMusicSound;
      
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
      addFrame();
      
      _tileHeight = Math.ceil(_bg.height / AssetRegistry.TILESIZE);
      _tileWidth = Math.ceil(_bg.width / AssetRegistry.TILESIZE);
      
      addObstacles();
      setBoundaries();
      
      _snake = new Snake(10);
      _following = _snake.head;
      _levelStage.addChild(_snake);
      
      addAboveSnake();
      
      _eggs = new Eggs();
      _rottenEggs = new Eggs.Eggs();
      
      spawnInitialEggs();
      
      _levelStage.addChild(_eggs);
      _levelStage.addChild(_rottenEggs);
      
      addHud();
      addParticles();
      
      _swipeMenu = new Sprite();
      var swipeBackground:Quad = new Quad(Starling.current.stage.stageWidth, 100, 0x000000);
      swipeBackground.alpha = 0.3;
      
      _swipeMenu.addChild(swipeBackground);
      _swipeMenu.y = Starling.current.stage.stageHeight;
      addChild(_swipeMenu);
      
      var back:Image = new Image(AssetRegistry.SnakeAtlas.getTexture("text-ingame-main menu"));
      back.x = 20;
      back.y = (_swipeMenu.height - back.height) / 2;
      
      back.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void
        {
          var touch:Touch = event.getTouch(back, TouchPhase.ENDED);
          if (touch)
          {
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
      
      startAt(_startPos.x, _startPos.y);
      
      pause();
      
      showObjective();
    
    }
    
    protected function addParticles():void
    {
      var list:Array = [[AssetRegistry.EGGA, XML(new AssetRegistry.EggsplosionGreen), AssetRegistry.SnakeAtlas.getTexture("EggsplosionA")], [AssetRegistry.EGGB, XML(new AssetRegistry.EggsplosionGreen), AssetRegistry.SnakeAtlas.getTexture("EggsplosionB")], [AssetRegistry.EGGC, XML(new AssetRegistry.EggsplosionGreen), AssetRegistry.SnakeAtlas.getTexture("EggsplosionC")], [AssetRegistry.EGGROTTEN, XML(new AssetRegistry.EggsplosionGreen), AssetRegistry.SnakeAtlas.getTexture("EggsplosionRottenLV1and2")], [AssetRegistry.EGGGOLDEN, XML(new AssetRegistry.EggsplosionGold), AssetRegistry.SnakeAtlas.getTexture("EggsplosionGold")], [AssetRegistry.EGGSHUFFLE, XML(new AssetRegistry.EggsplosionShuffle), AssetRegistry.SnakeAtlas.getTexture("EggsplosionShuffle")], [AssetRegistry.EGGZERO, XML(new AssetRegistry.EggsplosionGreen), AssetRegistry.SnakeAtlas.getTexture("EggsplosionGreen")], ["realRotten", XML(new AssetRegistry.EggsplosionRotten), AssetRegistry.SnakeAtlas.getTexture("EggsplosionRotten")]];
      
      _particles = {};
      for (var i:int = 0; i < list.length; i++)
      {
        _particles[list[i][0]] = new PDParticleSystem(list[i][1], list[i][2]);
        _levelStage.addChild(_particles[list[i][0]]);
        Starling.juggler.add(_particles[list[i][0]]);
      }
    }
    
    protected function showObjective():void
    {
      unpause();
    }
    
    public function showMessage(message:String):void
    {
      var field:TextField = recycleText();
      field.text = message;
      addChild(field);
      var tween:Tween = new Tween(field, 3);
      tween.animate("y", -field.height);
      //tween.animate("scaleX", 3);
      //tween.animate("scaleY", 3);
      tween.animate("alpha", 0);
      tween.onComplete = function():void
      {
        removeChild(field);
      }
      Starling.current.juggler.add(tween);
    }
    
    private function recycleText():TextField
    {
      return new TextField(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, "", "kroeger 06_65", 90, Color.WHITE);
    }
    
    protected function setBoundaries():void
    {
      _levelBoundaries = new Rectangle(0, 0, _tileWidth, _tileHeight);
    }
    
    public function addFrame():void
    {
      var frame:Image = new Image(AssetRegistry.LevelFrame);
      frame.x = -200;
      frame.y = -150;
      _levelStage.addChild(frame);
    }
    
    protected function addHud():void
    {
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
      
      eggs = _rottenEggs.eggPool;
      for (var i:int = 0; i < eggs.length; i++)
      {
        if (head.tileX == eggs[i].tileX && head.tileY == eggs[i].tileY)
        {
          eatEgg(eggs[i]);
            //_justAte = true;
            //peggle();
        }
      }
    }
    
    protected function addAboveSnake():void
    {
    
    }
    
    protected function addObstacles():void
    {
    
    }
    
    private function obstacleCollide():void
    {
      if (_obstacles[_snake.head.tileY * _tileWidth + _snake.head.tileX])
      {
        die();
      }
    }
    
    protected function screenCollide():void
    {
      if (_snake.head.tileX < _levelBoundaries.x || _snake.head.tileY < _levelBoundaries.y || _snake.head.tileX >= _levelBoundaries.x + _levelBoundaries.width || _snake.head.tileY >= _levelBoundaries.y + _levelBoundaries.height)
      {
        die();
      }
    }
    
    private function die():void
    {
      _snake.lives--;
      if (_snake.lives < 0) {
        return;
      }
      pause();
      
      _sadSnake = new Image(AssetRegistry.SnakeAtlas.getTexture("sadsnake"));
      _sadSnake.x = (Starling.current.stage.stageWidth - _sadSnake.width) / 2;
      _sadSnake.y = Starling.current.stage.stageHeight;
      
      _sadText = new Image(AssetRegistry.SnakeAtlas.getTexture("SadSnakeText"));
      _sadText.x = (Starling.current.stage.stageWidth - _sadText.width) / 2;
      _sadText.y = -_sadText.height;
      
      addChild(_sadSnake);
      addChild(_sadText);
      
      // Use a GTween, as the Starling tweens are paused.
      new GTween(_sadSnake, 2, {y: Starling.current.stage.stageHeight - _sadSnake.height});
      new GTween(_sadText, 2, {y: 0});
      
      removeEventListener(TouchEvent.TOUCH, onTouch);
      removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
      
      var registerTouchHandler = function() {
        addEventListener(TouchEvent.TOUCH, dieScreenTouch);
      }
      
      new GTween(null, 2, null, { paused:false, onComplete:registerTouchHandler } );
    
    }
    
    protected function spawnInitialEggs():void
    {
      for (var j:int = 0; j < 4; j++)
      {
        spawnRandomEgg();
      }
    }
    
    private function _onKeyDown(event:KeyboardEvent):void
    {
      switch (event.keyCode)
      {
        case 40: //DOWN
          if (_snake.head.facing == AssetRegistry.RIGHT || _snake.head.facing == AssetRegistry.LEFT)
          {
            _snake.head.facing = AssetRegistry.DOWN;
          }
          break;
        
        case 38: //UP
          if (_snake.head.facing == AssetRegistry.RIGHT || _snake.head.facing == AssetRegistry.LEFT)
          {
            _snake.head.facing = AssetRegistry.UP;
          }
          break;
        
        case 39: //RIGHT
          if (_snake.head.facing == AssetRegistry.UP || _snake.head.facing == AssetRegistry.DOWN)
          {
            _snake.head.facing = AssetRegistry.RIGHT;
          }
          break;
        
        case 37: //LEFT
          if (_snake.head.facing == AssetRegistry.UP || _snake.head.facing == AssetRegistry.DOWN)
          {
            _snake.head.facing = AssetRegistry.LEFT;
          }
          break;
      
      }
    
    }
    
    private function dieScreenTouch(event:TouchEvent):void
    {
      var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
      if (touch)
      {
        removeChild(_sadSnake);
        removeChild(_sadText);
        
        removeEventListener(TouchEvent.TOUCH, dieScreenTouch);
        addEventListener(TouchEvent.TOUCH, onTouch);
        addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
        resetSnake();
        unpause();
      }
    }
    
    private function resetSnake():void
    {
      startAt(_startPos.x, _startPos.y);
      _snake.head.facing = AssetRegistry.RIGHT;
      _snake.head.prevFacing = _snake.head.facing;
    }
    
    private function showParticles(egg:DisplayObject):void
    {
    /*
       var pd:ParticleSystem;
       for (var i:int = 0; i < _particlePool.length; i++)
       {
    
       }
       pd = _particlePool[0];
       pd.x = egg.x;
       pd.y = egg.y;
    
       pd.start(1);
       Starling.juggler.add(pd);
     */
    }
    
    private function peggle():void
    {
      if (_snake.eatenEggs == 10)
      {
        new GTween(this, 0.5, {zoom: 5});
        new GTween(Starling.juggler, 0.5, {timeFactor: 0.1});
        AssetRegistry.WinMusicSound.play();
      }
    }
    
    protected function spawnRandomEgg():void
    {
      var egg:Eggs.Egg = new Eggs.Egg(0, 0, Math.floor(Math.random() * 7));
      placeEgg(egg);
    }
    
    public function placeEgg(egg:Eggs.Egg, rotten:Boolean = false):void
    {
      var eggx:int;
      var eggy:int;
      do
      {
        eggx = _levelBoundaries.x + Math.floor(Math.random() * _levelBoundaries.width);
        eggy = _levelBoundaries.y + Math.floor(Math.random() * _levelBoundaries.height);
      } while (!free(eggx, eggy));
      egg.tileX = eggx;
      egg.tileY = eggy;
      
      if (!rotten)
      {
        _eggs.addEgg(egg);
      }
      else
      {
        _rottenEggs.addEgg(egg);
      }
    
    }
    
    private function free(x:int, y:int):Boolean
    {
      return !(_obstacles[y * _tileWidth + x]) && !(_snake.hit(x, y)) && !(_eggs.hit(x, y)) && !(_rottenEggs.hit(x, y));
    }
    
    private function eatEgg(egg:Egg):void
    {
      AssetRegistry.BiteSound.play();
      
      if (!_rottenEnabled && egg.type == AssetRegistry.EGGROTTEN || egg.type != AssetRegistry.EGGROTTEN) // || egg.type < AssetRegistry.EGGROTTEN)
      {
        if (egg.type <= AssetRegistry.EGGROTTEN)
        {
          _snake.eat(egg.type);
        }
        
        var particle:PDParticleSystem = _particles[egg.type];
        if (particle)
        {
          particle.x = egg.x + 10;
          particle.y = egg.y + 13;
          particle.start(0.5);
        }
        _eggs.eggPool.splice(_eggs.eggPool.indexOf(egg), 1);
        _eggs.removeChild(egg);
        spawnRandomEgg();
        
        showPoints(egg, "2");
        
        if (_bonusTimer > 0)
        {
          var randColor:uint = Color.argb(255, Math.floor(Math.random() * 100) + 155, Math.floor(Math.random() * 255), Math.floor(Math.random() * 256));
          _bonusTimerPoints += 2;
          showPoints(egg, "+" + String(_bonusTimerPoints), 20, randColor);
          _score += _bonusTimerPoints;
        }
        _score += 2;
        _bonusTimer = 2.5;
      }
      else
      {
        _poisonEggs += 1;
        _score -= 5;
        showPoints(egg, "-5", 20, Color.RED);
        var particle:PDParticleSystem = _particles["realRotten"];
        if (particle)
        {
          particle.x = egg.x + 10;
          particle.y = egg.y + 13;
          particle.start(0.5);
        }
        _rottenEggs.eggPool.splice(_eggs.eggPool.indexOf(egg), 1);
        _rottenEggs.removeChild(egg);
        _bonusTimer = 0;
      }
    }
    
    private function updateTimers(event:EnterFrameEvent):void
    {
      var passedTime:Number = event.passedTime * Starling.juggler.timeFactor;
      _timer += passedTime;
      _bonusTimer -= passedTime;
      _overallTimer += passedTime;
      _comboTimer -= passedTime;
      _rottenTimer -= passedTime;
      _timeLeft -= passedTime;
    }
    
    private function updateBonusBar():void
    {
      _bonusBar.x = _snake.head.x - 5;
      _bonusBar.y = _snake.head.y - 10;
      _bonusBack.x = _bonusBar.x - 1;
      _bonusBack.y = _bonusBar.y - 1;
      trace(_bonusTimer)
      if (_bonusTimer > 0.5)
      {
        _bonusBack.alpha = 0.3;
        _bonusBar.scaleX = ((_bonusTimer - 0.5) / 2) * 25;
        _bonusBar.color = Color.argb(255, (1 - ((_bonusTimer - 0.5) / 2)) * 255, ((_bonusTimer - 0.5) / 2) * 255, 0);
        
      }
      else
      {
        if (_bonusTimer <= 0)
        {
          _bonusTimerPoints = 0;
        }
        _bonusBar.scaleX = 0;
        _bonusBack.alpha = 0;
      }
    
    }
    
    protected function addBackground():void
    {
    /*
       _bg = new Image(_bgTexture);
       _bg.smoothing = TextureSmoothing.NONE;
       _bg.blendMode = BlendMode.NONE;
       _levelStage.addChild(_eggs);
     */
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
    
    private function showPoints(egg:DisplayObject, points:String, offset:int = 0, color:uint = 0xffffff):void
    {
      var text:TextField = new TextField(120, 120, points, "kroeger 06_65", 60);
      text.color = color;
      text.autoScale = true;
      text.hAlign = HAlign.CENTER;
      var p:Point = new Point(egg.x, egg.y);
      p = _levelStage.localToGlobal(p);
      text.x = p.x + egg.width / 2 - text.width / 2 + offset;
      text.y = p.y + egg.height / 2 - text.height / 2 + offset; //egg.y + (egg.height / 2) - text.height / 2);
      addChild(text);
      var tween:Tween = new Tween(text, 2, "easeIn");
      tween.animate("y", offset);
      tween.animate("scaleX", 3);
      tween.animate("scaleY", 3);
      tween.animate("x", offset);
      tween.animate("rotation", deg2rad(45 - offset));
      tween.fadeTo(0);
      
      tween.onComplete = function():void
      {
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
          combo.combo.effect(this);
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
    
    private function snakeAi():void
    {
      var egg:Eggs.Egg = _eggs.eggPool[0];
      if (egg.tileX > _snake.head.tileX)
      {
        _snake.head.facing = AssetRegistry.RIGHT;
      }
      else if (egg.tileX < _snake.head.tileX)
      {
        _snake.head.facing = AssetRegistry.LEFT;
        
      }
      else if (egg.tileY < _snake.head.tileY)
      {
        _snake.head.facing = AssetRegistry.UP;
      }
      else if (egg.tileY > _snake.head.tileY)
      {
        _snake.head.facing = AssetRegistry.DOWN;
      }
      _snake.head.prevFacing = _snake.head.facing;
    }
    
    private function checkLost():void
    {
      if (snake.lives < 0)
      {
        lose();
      }
    }
    
    private function lose():void
    {
      _lost = true;
      pause();
      var image:Image;
      image = new Image(AssetRegistry.SnakeAtlas.getTexture("game over_gravestone"));
      image.x = (Starling.current.stage.stageWidth - image.width) / 2;
      image.y = Starling.current.stage.stageHeight;
      addChild(image);
      
      // Use a GTween, as the Starling tweens are paused.
      new GTween(image, 2, {y: Starling.current.stage.stageHeight - image.height});
      removeEventListener(TouchEvent.TOUCH, onTouch);
      removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
      
      var registerTouchHandler = function()
      {
        addEventListener(TouchEvent.TOUCH, onLoseHandler);
      }
      
      new GTween(null, 2, null, { onComplete:registerTouchHandler, paused:false } );
    
    }
    
    protected function onLoseHandler(event:TouchEvent):void {
      var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
      if(touch) {
        var score:Object = {score: _score, lives: _snake.lives * 100, time: _overallTimer, level: _levelNr}
            
        StageManager.switchStage(LevelScore, score);
     }      
    }
    
    protected function updateHud():void
    {
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
      
      if (!_won)
      {
        checkWin();
      }
      
      if (!_lost)
      {
        checkLost();
      }
      
      if (!_paused)
      {
        
        //snakeAi();
        
        if (_firstFrame)
        {
          _firstFrame = false;
        }
        else
        {
          updateTimers(event);
        }
        
        updateHud();
        
        var startTimer:Number, endTimer:Number;
        
        //startTimer = getTimer();
        
        _snake.update(event.passedTime * Starling.juggler.timeFactor);
        
        //endTimer = getTimer();
        
        //Starling.current.mCombo = endTimer - startTimer;        
        
        _speed = _snake.speed;
        if (_timer >= _speed)
        {
          //startTimer = getTimer();
          _snake.move();
          //endTimer = getTimer();
          
          //Starling.current.mMove = endTimer - startTimer;
          
          doCombos();
          
          eggCollide();
          screenCollide();
          obstacleCollide();
          selfCollide();
          _timer -= _speed;
        }
        
        updateBonusBar();
        updateCamera();
        if (_rottenEnabled)
        {
          updateRotten();
        }
        
      }
    
    }
    
    protected function updateRotten():void
    {
      if (_rottenTimer < 0)
      {
        _rottenTimer = 30;
        var rotten:Eggs.Egg = new Eggs.Egg(0, 0, AssetRegistry.EGGROTTEN);
        placeEgg(rotten, true);
      }
    }
    
    private function selfCollide():void
    {
      if (_snake.selfCollide())
      {
        die();
      }
    }
    
    protected function updateCamera():void
    {
      
      var a:Number, b:Number;
      var centerX:Number, centerY:Number;
          
      _camerax = _following.x;
      _cameray = _following.y;
      
      a = _camerax + _following.frameOffset.x + 7;
      b = _cameray + _following.frameOffset.y + 7;
      centerX = -(a * _zoom) + Starling.current.stage.stageWidth / 2;
      centerY = -(b * _zoom) + Starling.current.stage.stageHeight / 2;
      
      
      if (Math.abs(centerX - _levelStage.x) > WINDOW) {
        if(centerX > _levelStage.x) {
          _levelStage.x += (centerX - _levelStage.x) - WINDOW;
        } else {
          _levelStage.x += (centerX - _levelStage.x) + WINDOW;         
        }
      }
      
      if (Math.abs(centerY - _levelStage.y) > WINDOW) {
        if(centerY > _levelStage.y) {
          _levelStage.y += (centerY - _levelStage.y) - WINDOW;
        } else {
          _levelStage.y += (centerY - _levelStage.y) + WINDOW;         
        }
      }      
      
      var frame:int = 4 * AssetRegistry.TILESIZE;
      
      _levelStage.x = Math.min(_levelStage.x, frame);
      _levelStage.y = Math.min(_levelStage.y, frame);
      // TODO: Should be computed only once.
      _levelStage.x = Math.max(-((_bg.width + frame) * _zoom) + Starling.current.stage.stageHeight, _levelStage.x);
      _levelStage.y = Math.max(-((_bg.height + frame) * _zoom) + Starling.current.stage.stageHeight, _levelStage.y);
    }
    
    public function pause():void
    {
      _paused = true;
      Starling.juggler.paused = true;
    }
    
    public function unpause():void
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
            if (_swipeMenu.y == Starling.current.stage.stageHeight && _swipeY > touch.getLocation(this).y)
            {
              new GTween(_swipeMenu, 0.2, {"y": Starling.current.stage.stageHeight - _swipeMenu.height});
              pause();
            }
            else if (_swipeMenu.y == Starling.current.stage.stageHeight - _swipeMenu.height && _swipeY < touch.getLocation(this).y)
            {
              new GTween(_swipeMenu, 0.2, {"y": Starling.current.stage.stageHeight});
              unpause();
            }
          }
          else
          {
            if (_swipeMenu.y == Starling.current.stage.stageHeight)
            {
              if (SaveGame.controlType == 1)
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
              else if (SaveGame.controlType == 2)
              {
                if (touch.getLocation(this).x > 480)
                {
                  if (_snake.head.facing == AssetRegistry.DOWN)
                  {
                    _snake.moveLeft();
                  }
                  else
                  {
                    _snake.moveRight();
                  }
                }
                else
                {
                  if (_snake.head.facing == AssetRegistry.DOWN)
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
      }
    }
    
    protected function checkWin():void
    {
    
    }
    
    protected function win():void
    {
      _won = true;
      pause();
      
      _evilSnake = new Image(AssetRegistry.SnakeAtlas.getTexture("snake_evillaugh"));
      _evilSnake.x = (Starling.current.stage.stageWidth - _evilSnake.width) / 2;
      _evilSnake.y = Starling.current.stage.stageHeight;
      addChild(_evilSnake);
      
      _evilText = new Image(AssetRegistry.SnakeAtlas.getTexture("Snake_EvilLaughText"));
      _evilText.x = (Starling.current.stage.stageWidth - _evilText.width) / 2;
      _evilText.y = 0;
      addChild(_evilText);
      
      // Use a GTween, as the Starling tweens are paused.
      new GTween(_evilSnake, 2, {y: Starling.current.stage.stageHeight - _evilSnake.height});
      new GTween(_evilText, 2, {y: 0});
      
      removeEventListener(TouchEvent.TOUCH, onTouch);
      removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
      
      var registerTouchHandler = function():void {
        addEventListener(TouchEvent.TOUCH, winScreenTouch);
      }
      
      new GTween(null, 2, null, { paused:false, onComplete:registerTouchHandler } );
    }
    
    protected function showObjectiveBox(desc:String, fontSize:int = 50):void
    {
      var box:Quad = new Quad(800, 600, 0);
      box.alpha = 0x44 / 0xff;
      box.x = (960 - box.width) / 2;
      box.y = (640 - box.height) / 2;
      addChild(box);
      
      var text:TextField = new TextField(700, 500, "", "kroeger 06_65", fontSize, Color.WHITE);
      text.text = desc;
      
      addChild(text);
      text.x = (960 - text.width) / 2;
      text.y = (640 - text.height) / 2;
      text.touchable = false;
      
      box.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void
        {
          var touch:Touch = event.getTouch(box, TouchPhase.ENDED);
          if (touch)
          {
            removeChild(box);
            removeChild(text);
            unpause();
          }
        });
    }
    
    protected function startAt(x:int, y:int):void
    {
      _snake.head.tileX = x;
      _snake.head.tileY = y;
      _snake.head.facing = AssetRegistry.RIGHT;
      for (var i:int = 0; i < _snake.body.length; i++)
      {
        _snake.body[i].tileX = -10;
        _snake.body[i].tileY = -10;
        _snake.body[i].facing = AssetRegistry.RIGHT;
      }
      _snake.tail.tileX = -10;
      _snake.tail.tileY = -10;
      _snake.tail.facing = AssetRegistry.RIGHT;
      
    }
    
    private function winScreenTouch(event:TouchEvent):void
    {
      var touch:Touch;
      touch = event.getTouch(this, TouchPhase.ENDED);
      if (touch)
      {
        var score:Object = {score: _score, lives: _snake.lives * 100, time: _overallTimer, level: _levelNr}
        
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
    
    public function get snake():Snake
    {
      return _snake;
    }
    
    public function get timeLeft():Number
    {
      return _timeLeft;
    }
    
    public function set timeLeft(value:Number):void
    {
      _timeLeft = value;
    }
  
  }

}
