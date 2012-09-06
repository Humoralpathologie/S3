package Level
{
  import engine.AssetRegistry;
  import flash.desktop.InteractiveIcon;
  import starling.animation.Juggler;
  //import com.demonsters.debugger.MonsterDebugger;
  import com.gskinner.motion.GTween;
  import Eggs.Egg;
  import Eggs.Eggs;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import org.josht.starling.foxhole.controls.*;
  import org.josht.starling.foxhole.themes.IFoxholeTheme;
  import org.josht.starling.foxhole.transitions.ScreenFadeTransitionManager;
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
  import flash.media.SoundTransform;
  import engine.ManagedStage;
  import engine.StageManager;
  import Menu.MainMenu;
  import Menu.LevelScore;
  import engine.SaveGame;
  import org.josht.starling.foxhole.controls.Screen;
  import org.josht.starling.foxhole.controls.ToggleSwitch;
  import org.josht.starling.foxhole.controls.Button;
  import org.josht.starling.foxhole.controls.Scroller;
  import org.josht.starling.foxhole.controls.ScrollBar;
  import org.osflash.signals.ISignal;
  //import starling.display.Button;
  import starling.display.Quad;
  import engine.AssetRegistry;
  import flash.events.Event;
  import Menu.PauseMenuScreens.*;
  import org.josht.starling.foxhole.themes.MinimalTheme;
  import UI.Shake;
  import engine.Utils;
  
  /**
   * The base class for all Levels
   * @author Roger Braun, Tim Schierbaum, Jiayi Zheng
   */
  
  public class LevelState extends ManagedStage
  {
    protected var _bg:Image;
    protected var _bgTexture:Texture;
    protected var _overlay:Image;
    protected var _hud:HUD;
    private var _timer:Number = 0;
    protected var _snake:Snake;
    protected var _speed:Number = 0.3;
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
    
    // Death screen
    private var _sadSnake:Image;
    private var _sadText:Image;
    private var _mchammer:Quad;
    
    // Shaking
    private var _shaking:Boolean = false;
    
    private var _evilSnake:Image;
    private var _evilText:Image;
    protected var _levelNr:int = 0;
    private var _won:Boolean = false;
    protected var _lost:Boolean = false;
    protected var _obstacles:Object = {};
    protected var _tileWidth:int = 0;
    protected var _tileHeight:int = 0;
    private var _camerax:Number = 0;
    private var _cameray:Number = 0;
    
    private static var sfx:Sound;
    protected var _bonusTimer:Number = 0;
    protected var _bonusTimerPoints:Number = 0;
    
    private var _bonusBar:Quad;
    private var _bonusBack:Quad;
    
    protected var _rottenTimer:Number = 0;
    protected var _rottenEnabled:Boolean = false;
    protected var _particles:Object;
    
    protected var _startPos:Point = new Point(5, 5);
    protected var _levelBoundaries:Rectangle;
    protected var _timeLeft:Number = 3 * 60;
    protected var _poisonEggs:int = 0;
    protected var _maxEggs:int = 5;
    protected var _timeExtension:Number = 5;
    protected var _chainTime:Number = 2.5;
    protected var _extensionTime:int;
    protected var _timeExtensionTime:int;
    protected var _spawnMap:Array = [];
    protected var _textLayer:Sprite;
    
    private var _updateTimer:Number;
    
    // Mogade leaderboard ID
    protected var _lid:String;
    
    // Pause Menu
    protected var _pauseMenu:ScreenNavigator;
    
    protected var _textFieldPool:Vector.<TextField>;
    
    private static const SilentSoundTransform:SoundTransform = new SoundTransform(0);
    
    private static const WINDOW:Number = 100;
    
    private static const PAUSEMAIN:String = "MAIN";
    
    protected var _gameJuggler:Juggler;
    
    protected var _level4Animation:Boolean = false;
    private var _shadow:Image;
    
    //tweens
    protected var _tweens:Vector.<GTween> = new Vector.<GTween>;
    
    public function LevelState()
    {
      super();
      AssetRegistry.loadGraphics([AssetRegistry.MENU, AssetRegistry.SNAKE, AssetRegistry.SCORING]);
      
      setSpeed();
      
      _currentCombos = null;
      
      // Register Keyboard controls
      Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
      
      // Update every frame
      this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
      
      // Initialize and fill the TextField pool
      initializeTextPool();
      
      // Juggler for in-game objects that can be paused
      _gameJuggler = new Juggler();
      
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
      _tileWidth = Math.ceil(_bg.width / AssetRegistry.TILESIZE);
      
      addObstacles();
      addSpawnMap();
      setBoundaries();
      
      _snake = new Snake(SaveGame.startSpeed);
      _gameJuggler.add(_snake);
      
      _snake.addEventListener(Snake.Snake.SNAKE_MOVED, onSnakeMoved);
      
      _following = _snake.head;
      
      _levelStage.addChild(_snake);
      
      _shadow = new Image(AssetRegistry.SnakeAtlas.getTexture("level7-schatten"));
      _shadow.scaleX = _shadow.scaleY = 1.5;
      _shadow.x = 0;
      _shadow.y = 200;
      if (_levelNr == 7){
        _levelStage.addChild(_shadow);
      }
      
      addFrame();
      
      _eggs = new Eggs();
      _rottenEggs = new Eggs();
      
      _gameJuggler.add(_eggs);
      _gameJuggler.add(_rottenEggs);
      
      spawnInitialEggs();
      
      _levelStage.addChild(_eggs);
      _levelStage.addChild(_rottenEggs);
      addAboveSnake();
      addParticles();
      
      addChild(_textLayer);
      
      addHud();
      
      //create bonusbar
      createBonusBar();
      
      startAt(_startPos.x, _startPos.y);
      
      _mchammer = new Quad(AssetRegistry.STAGE_WIDTH, AssetRegistry.STAGE_HEIGHT);
      _mchammer.alpha = 0;
      
      addChild(_mchammer);
      createPauseMenu();
      
      pause();
      showObjective();
      
    }
    
    public function extendTime():void
    {
      _timeLeft += _timeExtension;
    }
    
    protected function addParticles():void
    {
      var list:Array = [[AssetRegistry.EGGA, XML(new AssetRegistry.EggsplosionGreen), AssetRegistry.SnakeAtlas.getTexture("EggsplosionA")], [AssetRegistry.EGGB, XML(new AssetRegistry.EggsplosionGreen), AssetRegistry.SnakeAtlas.getTexture("EggsplosionB")], [AssetRegistry.EGGC, XML(new AssetRegistry.EggsplosionGreen), AssetRegistry.SnakeAtlas.getTexture("EggsplosionC")], [AssetRegistry.EGGROTTEN, XML(new AssetRegistry.EggsplosionGreen), AssetRegistry.SnakeAtlas.getTexture("EggsplosionRottenLV1and2")], [AssetRegistry.EGGGOLDEN, XML(new AssetRegistry.EggsplosionGold), AssetRegistry.SnakeAtlas.getTexture("EggsplosionGold")], [AssetRegistry.EGGSHUFFLE, XML(new AssetRegistry.EggsplosionShuffle), AssetRegistry.SnakeAtlas.getTexture("EggsplosionShuffle")], [AssetRegistry.EGGZERO, XML(new AssetRegistry.EggsplosionGreen), AssetRegistry.SnakeAtlas.getTexture("EggsplosionGreen")], ["realRotten", XML(new AssetRegistry.EggsplosionRotten), AssetRegistry.SnakeAtlas.getTexture("EggsplosionRotten")], ["combo0", XML(new AssetRegistry.Taileggsplosion0), AssetRegistry.SnakeAtlas.getTexture("particleTexture")], ["combo1", XML(new AssetRegistry.Taileggsplosion1), AssetRegistry.SnakeAtlas.getTexture("particleTexture")], ["combo2", XML(new AssetRegistry.Taileggsplosion2), AssetRegistry.SnakeAtlas.getTexture("particleTexture")], ["combo3", XML(new AssetRegistry.Taileggsplosion3), AssetRegistry.SnakeAtlas.getTexture("particleTexture")], ["combo4", XML(new AssetRegistry.Taileggsplosion4), AssetRegistry.SnakeAtlas.getTexture("particleTexture")], ["ExtraLife", XML(new AssetRegistry.ExtraLife), AssetRegistry.SnakeAtlas.getTexture("ExtraLife")], ["ExtraEggs", XML(new AssetRegistry.ExtraEggs), AssetRegistry.SnakeAtlas.getTexture("ExtraEggs")], ["BonusTime", XML(new AssetRegistry.BonusTime), AssetRegistry.SnakeAtlas.getTexture("BonusTime")], ["ChainTimePlus", XML(new AssetRegistry.ChainTimePlus), AssetRegistry.SnakeAtlas.getTexture("ChainTimePlus")], ["goldLv7", XML(new AssetRegistry.EggsplosionGoldLv7), AssetRegistry.SnakeAtlas.getTexture("EggsplosionGold")]];
      
      _particles = {};
      for (var i:int = 0; i < list.length; i++)
      {
        _particles[list[i][0]] = new PDParticleSystem(list[i][1], list[i][2]);
        _levelStage.addChild(_particles[list[i][0]]);
        _gameJuggler.add(_particles[list[i][0]]);
      }
    }
    
    protected function showObjective():void
    {
    
    }
    
    protected function addSpawnMap():void
    {
    
    }
    
    public function showMessage(message:String):void
    {
      dispatchEventWith(HUD.DISPLAY_MESSAGE, true, {message: message});
    }
    
    protected function setBoundaries():void
    {
      _levelBoundaries = new Rectangle(0, 0, _tileWidth, _tileHeight);
    }
    
    public function addFrame():void
    {
      var frame:Image = new Image(AssetRegistry.HalfFrameTexture);
      var rightFrame:Image = new Image(AssetRegistry.HalfFrameTexture);
      frame.x = -186;
      frame.y = -161;
      rightFrame.scaleX = -1;
      rightFrame.scaleY = -1;
      rightFrame.x = frame.x + frame.width + frame.width - 1;
      rightFrame.y = -161 + rightFrame.height;
      
      _levelStage.addChild(frame);
      _levelStage.addChild(rightFrame);
    }
    
    protected function addHud():void
    {
      //_hud = new HUD(new Radar(_eggs, _snake), ["lifes", "time"], this);
      _hud = new HUD(this);
      addChild(_hud);
    }
    
    protected function eggCollide():void
    {
      var egg:Eggs.Egg;
      
      egg = _eggs.overlapEgg(_snake.head);
      if (egg)
      {
        //shake();
        eatEgg(egg);
        _justAte = true;
      }
      
      egg = _rottenEggs.overlapEgg(_snake.head);
      if (egg)
      {
        eatEgg(egg);
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
      if (_obstacles[_snake.head.tileY * _tileWidth + _snake.head.tileX] && !_level4Animation)
      {
        die();
      }
    }
    
    protected function screenCollide():void
    {
      if ((_snake.head.tileX < _levelBoundaries.x || _snake.head.tileY < _levelBoundaries.y || _snake.head.tileX >= _levelBoundaries.x + _levelBoundaries.width || _snake.head.tileY >= _levelBoundaries.y + _levelBoundaries.height) && !_level4Animation)
      {
        die();
      }
    }
    
    protected function die():void
    {
      _snake.lives--;
      _snake.mps = SaveGame.startSpeed;
      var _shake = new Shake(_levelStage, 25, 0.5);
      Starling.juggler.add(_shake);
      if (_snake.lives < 0)
      {
        return;
      }
      if (_snake.lives >= 0)
      {
        AssetRegistry.soundmanager.playSound("dieSound");
      }
      pause();
      
      _sadSnake = new Image(AssetRegistry.UIAtlas.getTexture("sadsnake"));
      _sadSnake.x = (AssetRegistry.STAGE_WIDTH - _sadSnake.width) / 2;
      _sadSnake.y = AssetRegistry.STAGE_HEIGHT;
      _sadSnake.touchable = false;
      
      _sadText = new Image(AssetRegistry.UIAtlas.getTexture("SadSnakeText"));
      _sadText.x = (AssetRegistry.STAGE_WIDTH - _sadText.width) / 2;
      _sadText.y = -_sadText.height;
      _sadText.touchable = false;
      
      addChild(_sadSnake);
      addChild(_sadText);
      
      // Use a GTween, as the Starling tweens are paused.
      _tweens.push(new GTween(_sadSnake, 2, {y: AssetRegistry.STAGE_HEIGHT - _sadSnake.height}));
      _tweens.push(new GTween(_sadText, 2, {y: 0}));
      
      var registerTouchHandler:Function = function():void
      {
        addEventListener(TouchEvent.TOUCH, dieScreenTouch);
      }
      
      _tweens.push(new GTween(null, 1, null, {paused: false, onComplete: registerTouchHandler}));
    
    }
    
    protected function spawnInitialEggs():void
    {
      for (var j:int = 0; j < 5; j++)
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
            _snake.changeDirection(AssetRegistry.DOWN);
          }
          break;
        
        case 38: //UP
          if (_snake.head.facing == AssetRegistry.RIGHT || _snake.head.facing == AssetRegistry.LEFT)
          {
            _snake.changeDirection(AssetRegistry.UP);
          }
          break;
        
        case 39: //RIGHT
          if (_snake.head.facing == AssetRegistry.UP || _snake.head.facing == AssetRegistry.DOWN)
          {
            _snake.changeDirection(AssetRegistry.RIGHT);
          }
          break;
        
        case 37: //LEFT
          if (_snake.head.facing == AssetRegistry.UP || _snake.head.facing == AssetRegistry.DOWN)
          {
            _snake.changeDirection(AssetRegistry.LEFT);
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
        resetSnake();
        _shaking = false;
        unpause();
      }
    }
    
    private function resetSnake():void
    {
      startAt(_startPos.x, _startPos.y);
      _snake.head.facing = AssetRegistry.RIGHT;
      _snake.head.prevFacing = _snake.head.facing;
    }
    
    private function showParticles(egg:DisplayObject, particle:int):void
    {
      var pd:ParticleSystem;
      pd = _particles["combo" + String(Math.min(4, particle))];
      pd.x = egg.x + 5 + egg.width / 2;
      pd.y = egg.y + 5 + egg.height / 2;
      pd.maxCapacity = Math.min(50, pd.maxCapacity);
      pd.touchable = false;
      pd.start(0.5);
    }
    
    public function showSpecialParticles(head:DisplayObject, particle:String):void
    {
      var pd:ParticleSystem;
      pd = _particles[particle];
      pd.x = head.x + 5 + head.width / 2;
      pd.y = head.y + 5 + head.height / 2;
      pd.maxCapacity = Math.min(50, pd.maxCapacity);
      pd.touchable = false;
      pd.start(0.5);
    }
    
    public function spawnRandomEgg():void
    {
      
      var egg:Eggs.Egg;
      var types:Array = [AssetRegistry.EGGA, AssetRegistry.EGGB, AssetRegistry.EGGC];
      
      egg = _eggs.recycleEgg(0, 0, types[Math.floor(Math.random() * types.length)]);
      
      placeEgg(egg);
    
    }
    
    public function placeEgg(egg:Eggs.Egg, rotten:Boolean = false):void
    {
      var eggx:int;
      var eggy:int;
      var pos:int;
      do
      {
        pos = _spawnMap[int(Math.floor(Math.random() * _spawnMap.length))];
        eggy = Math.floor(pos / _tileWidth);
        eggx = pos - (eggy * _tileWidth);
      } while (!free(eggx, eggy));
      egg.tileX = eggx;
      egg.tileY = eggy;
    
    }
    
    private function free(x:int, y:int):Boolean
    {
      return !(_obstacles[y * _tileWidth + x]) && !(_snake.hit(x, y)) && !(_eggs.hit(x, y)) && !(_rottenEggs.hit(x, y));
    }
    
    protected function eatEgg(egg:Egg):void
    {
      var particle:PDParticleSystem;
      
      var biteSounds:Array = ["bite1", "bite2", "bite3"];
      
      if (!_rottenEnabled && egg.type == AssetRegistry.EGGROTTEN || egg.type != AssetRegistry.EGGROTTEN) // || egg.type < AssetRegistry.EGGROTTEN)
      {
        if (egg.type <= AssetRegistry.EGGROTTEN)
        {
          _snake.eat(egg.type);
          AssetRegistry.soundmanager.playSound(biteSounds[Math.floor(Math.random() * 3)]);
            //_hud.addPreview(egg.type);
        }
        
        particle = _particles[egg.type];
        if (particle)
        {
          particle.x = egg.x + 10;
          particle.y = egg.y + 13;
          particle.start(0.5);
        }
        
        _eggs.removeEgg(egg);
        
        var points:int = 2;
        
        if (egg.type == AssetRegistry.EGGGOLDEN)
        {
          points = 500;
          AssetRegistry.soundmanager.playSound("goldenEggSound");
        }
        
        if (egg.type == AssetRegistry.EGGSHUFFLE)
        {
          _snake.shuffle();
          points = 0;
          AssetRegistry.soundmanager.playSound("shuffleEggSound");
        }
        
        if (points > 0)
        {
          showPoints(egg, String(points));
        }
        
        if (_bonusTimer > 0)
        {
          var randColor:uint = Color.argb(255, Math.floor(Math.random() * 100) + 155, Math.floor(Math.random() * 255), Math.floor(Math.random() * 256));
          _bonusTimerPoints += 2;
          showPoints(egg, "+" + String(_bonusTimerPoints), 0, 20, randColor);
          _score += _bonusTimerPoints;
        }
        
        _score += points;
        _bonusTimer = _chainTime;
        
      }
      else
      {
        var _shake = new Shake(_levelStage, 20, 0.5);
        Starling.juggler.add(_shake);
        _poisonEggs += 1;
        _score -= 5;
        showPoints(egg, "-5", 0, 20, Color.RED);
        particle = _particles["realRotten"];
        AssetRegistry.soundmanager.playSound("rottenEggSound");
        if (particle)
        {
          particle.x = egg.x + 10;
          particle.y = egg.y + 13;
          particle.start(0.5);
        }
        
        _rottenEggs.removeEgg(egg);
        
        _bonusTimer = 0;
        
      }
      
      AssetRegistry.soundmanager.level = Math.floor(_snake.eatenEggs / 10);
    
    }
    
    protected function updateTimers(event:EnterFrameEvent):void
    {
      var passedTime:Number = event.passedTime * _gameJuggler.timeFactor;
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
      if (_bonusTimer > 0.5)
      {
        if (_chainTime == 2.5)
          _bonusBack.alpha = 0.3;
        if (_chainTime == 3.5)
          _bonusBack.alpha = 0.6;
        
        _bonusBar.scaleX = ((_bonusTimer - 0.5) / 2) * 25;
        _bonusBar.color = Color.argb(255, (1 - ((_bonusTimer - 0.5) / int(_chainTime))) * 255, ((_bonusTimer - 0.5) / int(_chainTime)) * 255, 0);
        
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
      var prefib:int = 4;
      var fib:int = 5;
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
            
            showPoints(egg, '+' + String(fib), 1);
            
            temp = fib;
            fib += prefib;
            prefib = temp;
            
            AssetRegistry.soundmanager.playSound("comboSound" + Math.min(soundCounter, 7));
            
            showParticles(egg, soundCounter);
            
            _snake.removeBodyPart(egg);
            
            soundCounter++;
            //_hud.updatePreview(_snake);
            
            setTimeout(func, (300 / (expoCounter * expoCounter)) + 80);
            
          }
        }
        else
        {
          _justAte = true;
        }
      }
      
      func();
    }
    
    protected function showPoints(egg:DisplayObject, points:String, variant:int = 0, offset:int = 0, color:uint = 0xffffff):void
    {
      var pos:Point = new Point();
      
      dispatchEventWith(HUD.DISPLAY_POINTS, true, {position: pos, variant: variant, message: points, color: color});
    /*
       var text:TextField = recycleText(120, 120, points, 60); // new TextField(120, 120, points, "kroeger 06_65", 60);
       text.color = color;
       text.autoScale = true;
       text.hAlign = HAlign.CENTER;
       var p:Point = new Point(egg.x, egg.y);
       p = _levelStage.localToGlobal(p);
       text.x = p.x + egg.width / 2 - text.width / 2 + offset;
       text.y = p.y + egg.height / 2 - text.height / 2 + offset; //egg.y + (egg.height / 2) - text.height / 2);
       var tween:Tween = new Tween(text, 2, "easeIn");
       tween.animate("y", offset);
       tween.animate("scaleX", 3);
       tween.animate("scaleY", 3);
       tween.animate("x", offset);
       tween.animate("rotation", deg2rad(45 - offset));
       tween.fadeTo(0);
    
       tween.onComplete = function():void
       {
       text.visible = false;
       }
    
       _gameJuggler.add(tween);
     */
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
    
    protected function checkLost():void
    {
      if (snake.lives < 0)
      {
        lose();
      }
    }
    
    protected function checkDie():void
    {
    
    }
    
    protected function lose():void
    {
      _lost = true;
      //pause();
      _gameJuggler.remove(_snake);
      var image:Image;
      image = new Image(AssetRegistry.UIAtlas.getTexture("game over_gravestone"));
      image.x = (AssetRegistry.STAGE_WIDTH - image.width) / 2;
      image.y = AssetRegistry.STAGE_HEIGHT;
      addChild(image);
      
      // Use a GTween, as the Starling tweens are paused.
      _tweens.push(new GTween(image, 2, {y: AssetRegistry.STAGE_HEIGHT - image.height}));
      AssetRegistry.soundmanager.playSound("gameOverSound");
      
      var registerTouchHandler:Function = function():void
      {
        addEventListener(TouchEvent.TOUCH, onLoseHandler);
      }
      
      _tweens.push(new GTween(null, 2, null, {onComplete: registerTouchHandler, paused: false}));
    
    }
    
    protected function onLoseHandler(event:TouchEvent):void
    {
      var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
      if (touch)
      {
        var score:Object = {score: _score, lives: _snake.lives, time: _overallTimer, level: _levelNr, snake: _snake, lost: true, lid: _lid}
        
        AssetRegistry.soundmanager.fadeOutMusic();
        dispatchEventWith(ManagedStage.SWITCHING, true, {stage: LevelScore, args: score});
        
      }
    }
    
    private function onEnterFrame(event:EnterFrameEvent):void
    {
      _updateTimer = getTimer();
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
          _gameJuggler.advanceTime(event.passedTime);
          
          if(!(_won || _lost)) {
            updateTimers(event);
          }

          if ((int(_overallTimer) > 0) && (int(_overallTimer) == _extensionTime))
          {
            _chainTime = 2.5;
            _bonusBack.width = 27;
            _bonusBack.color = 0x000000;
            _extensionTime = 0;
            showMessage(AssetRegistry.Strings.CHAINTIMEEXTENDMESSAGE);
          }
          
          if ((int(_overallTimer) > 0) && (int(_overallTimer) == _timeExtensionTime))
          {
            _timeExtension = 3;
            _timeExtensionTime = 0;
            showMessage(AssetRegistry.Strings.EXTRATIMEEXTENDMESSAGE);
          }
        }
        
        if (_eggs.length < _maxEggs)
        {
          spawnRandomEgg();
        }
        
        _hud.update();
               
        updateBonusBar();
        updateCamera();
        if (_rottenEnabled)
        {
          updateRotten();
        }
        
      }
    
      //Starling.current.statsDisplay.additionalStats["TU"] = getTimer() - _updateTimer;
    
    }
    
    private function onSnakeMoved(evt:starling.events.Event):void
    {
      doCombos();
      
      eggCollide();
      screenCollide();
      obstacleCollide();
      selfCollide();
      checkDie(); // For subclasses.
    }
    
    protected function updateRotten():void
    {
      if (_rottenTimer < 0)
      {
        _rottenTimer = 20;
        var rotten:Eggs.Egg = _rottenEggs.recycleEgg(0, 0, AssetRegistry.EGGROTTEN);
        rotten.pinkify();
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
    
    public function updateCamera():void
    {
      
      var a:Number, b:Number;
      var centerX:Number, centerY:Number;
      
      _camerax = _following.x;
      _cameray = _following.y;
      
      a = _camerax + _following.frameOffset.x + 7;
      b = _cameray + _following.frameOffset.y + 7;
      centerX = -(a * _zoom) + AssetRegistry.STAGE_WIDTH / 2;
      centerY = -(b * _zoom) + AssetRegistry.STAGE_HEIGHT / 2;
      
      if (Math.abs(centerX - _levelStage.x) > WINDOW)
      {
        if (centerX > _levelStage.x)
        {
          _levelStage.x += (centerX - _levelStage.x) - WINDOW;
        }
        else
        {
          _levelStage.x += (centerX - _levelStage.x) + WINDOW;
        }
      }
      
      if (Math.abs(centerY - _levelStage.y) > WINDOW)
      {
        if (centerY > _levelStage.y)
        {
          _levelStage.y += (centerY - _levelStage.y) - WINDOW;
        }
        else
        {
          _levelStage.y += (centerY - _levelStage.y) + WINDOW;
        }
      }
      
      var frame:int = 4 * AssetRegistry.TILESIZE;
      
      //_levelStage.x = Math.min(_levelStage.x, frame * zoom);
      //_levelStage.y = Math.min(_levelStage.y, frame * zoom);
      // TODO: Should be computed only once.
      _levelStage.x = Math.max(-((_bg.width + frame) * _zoom) + AssetRegistry.STAGE_HEIGHT, _levelStage.x);
      _levelStage.y = Math.max(-((_bg.height + frame) * _zoom) + AssetRegistry.STAGE_HEIGHT, _levelStage.y);
    
    }
    
    public function get score():String
    {
      return String(_score);
    }
    
    public function get lives():String
    {
      return String(_snake.lives);
    }
    
    public function get eatenEggs():String
    {
      return String(_snake.eatenEggs);
    }
    
    public function get speed():String
    {
      return String(_snake.mps - SaveGame.startSpeed);
    }
    
    public function get comboCount():String
    {
      return String(_combos);
    }
    
    public function get poisonCount():String
    {
      return String(_poisonEggs);
    }
    
    public function get overallTime():String
    {
      var _sec:String = (int(_overallTimer) % 60) < 10 ? "0" + String(int(_overallTimer) % 60) : String(int(_overallTimer) % 60);
      var _min:String = (int(_overallTimer) / 60) < 10 ? "0" + String(int(int(_overallTimer) / 60)) : String(int(int(_overallTimer) / 60));
      return _min + ":" + _sec;
    }
    
    public function pause():void
    {
      _paused = true;
      //Starling.juggler.paused = true;
      //addChild(_mchammer);
      _mchammer.touchable = true;
    }
    
    public function unpause():void
    {
      //removeChild(_mchammer);
      _paused = false;
      _mchammer.touchable = false;
      //Starling.juggler.paused = false;
    }
    
    public function togglePause():void
    {
      if (_paused)
      {
        unpause();
        hidePauseMenu();
      }
      else
      {
        pause();
        showPauseMenu();
      }
    }
    
    private function createPauseMenu():void
    {
      
      _pauseMenu = new ScreenNavigator();
      var trans:ScreenFadeTransitionManager = new ScreenFadeTransitionManager(_pauseMenu);
      
      _pauseMenu.addScreen(PAUSEMAIN, new ScreenNavigatorItem(new PauseMainScreen(this)));
      _pauseMenu.defaultScreenID = PAUSEMAIN;
      addChild(_pauseMenu);
    
    }
    
    private function showPauseMenu():void
    {
      _mchammer.y = 100; // Keep pause button.
      _pauseMenu.showScreen(PAUSEMAIN);
    }
    
    public function hidePauseMenu():void
    {
      _mchammer.y = 0;
      _pauseMenu.clearScreen();
    }
    
    protected function checkWin():void
    {
    
    }
    
    protected function win():void
    {
      _won = true;
      if (_currentCombos)
      {
        for (var j:int = 0; j < _currentCombos.length; j++)
        {
          var combo:Object = _currentCombos[j];
          removeAndExplodeCombo(combo.eggs);
          combo.combo.effect(this);
          _combos += 1;
        }
        _currentCombos = null;
      }
      //pause();
      _gameJuggler.remove(_snake);
      if (SaveGame.isArcade)
      {
        AssetRegistry.soundmanager.playSound("explosion");
      }
      else
      {
        AssetRegistry.soundmanager.playSound("winSound");
      }
      
      _evilSnake = new Image(AssetRegistry.UIAtlas.getTexture("snake_evillaugh"));
      _evilSnake.x = (AssetRegistry.STAGE_WIDTH - _evilSnake.width) / 2;
      _evilSnake.y = AssetRegistry.STAGE_HEIGHT;
      addChild(_evilSnake);
      
      _evilText = new Image(AssetRegistry.UIAtlas.getTexture("Snake_EvilLaughText"));
      _evilText.x = (AssetRegistry.STAGE_WIDTH - _evilText.width) / 2;
      _evilText.y = 0;
      addChild(_evilText);
      
      // Use a GTween, as the Starling tweens are paused.
      _tweens.push(new GTween(_evilSnake, 2, {y: AssetRegistry.STAGE_HEIGHT - _evilSnake.height}));
      _tweens.push(new GTween(_evilText, 2, {y: 0}));
      
      var registerTouchHandler:Function = function():void
      {
        addEventListener(TouchEvent.TOUCH, winScreenTouch);
      }
      
      _tweens.push(new GTween(null, 2, null, {paused: false, onComplete: registerTouchHandler}));
    }
    
    protected function showObjectiveBox(desc:String, goals:Array, fontSize:int = 50):void
    {
      
      var _scrollable:Sprite = new Sprite();
      
      var levelName:TextField = new TextField(600, 60, SaveGame.levelName, "kroeger 06_65", 60, Color.WHITE);
      
      var heading:TextField = new TextField(600, 60, AssetRegistry.Strings.OBJECTIVE, "kroeger 06_65", 60, Color.WHITE);
      
      var box:Quad = new Quad(800, 535, 0);
      box.alpha = 0x44 / 0xff;
      box.x = (960 - box.width) / 2;
      box.y = 30;
      addChild(box);
      
      levelName.x = (box.width - levelName.width) / 2;
      levelName.y = box.y + 10;
      levelName.autoScale = true;
      
      heading.x = (box.width - heading.width) / 2;
      heading.y = levelName.y + levelName.height + 10;
      _scrollable.addChild(levelName);
      _scrollable.addChild(heading);
      
      //var _goals:Sprite = new Sprite();
      
      var xPos:int = 10;
      var yPos:int = heading.y + heading.height + 20;
      
      for (var i:int = 0; i < goals.length; i++)
      {
        //var objectiveText:TextField = new TextField(140, 60, goals[i][0], "kroeger 06_65", 60, Color.WHITE);
        var img:Image = goals[i][0];
        var txt:TextField = new TextField(200, 60, goals[i][1], "kroeger 06_65", 60, Color.WHITE);
        txt.hAlign = HAlign.LEFT;
        img.x = xPos + 70;
        img.y = yPos;
        img.scaleX = img.scaleY = 3;
        if (goals.length == 1)
        {
          img.x = (box.width - img.width - txt.textBounds.width) / 2;
          img.y = yPos;
        }
        //txt.scaleX = txt.scaleY = 1.5;
        txt.x = img.x + img.width + 10;
        txt.y = img.y - 5;
        xPos = txt.x + txt.width + 10;
        _scrollable.addChild(img);
        _scrollable.addChild(txt);
      }
      
      var _scroller:Scroller = new Scroller();
      _scroller.setSize(box.width, box.height - 30);
      _scroller.x = box.x;
      _scroller.y = box.y;
      _scroller.viewPort = _scrollable;
      
      addChild(_scroller);
      
      var text:TextField = new TextField(700, 1250, "", "kroeger 06_65", fontSize, Color.WHITE);
      text.text = desc;
      text.autoScale = true;
      text.x = (box.width - text.width) / 2;
      text.y = yPos + 80;
      text.vAlign = VAlign.TOP;
      _scrollable.addChild(text);
      
      _scroller.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
      
      var that:LevelState = this;
      
      var _goButton:Button = new Button();
      _goButton.label = "GO!";
      _goButton.width = 800;
      _goButton.height = 80;
      _goButton.x = (AssetRegistry.STAGE_WIDTH - 800) / 2;
      _goButton.y = AssetRegistry.STAGE_HEIGHT - 80;
      
      addChild(_goButton);
      _goButton.onRelease.add(function(button:Button):void
        {
          that.removeChild(_goButton);
          that.removeChild(box);
          that.removeChild(_scrollable);
          that.removeChild(_scroller);
          unpause();
        });
      
      var _tempPoint:Point;
      var onTouch:Function = function(e:TouchEvent):void
      {
        
        var touch:Touch;
        touch = e.getTouch(_scrollable, TouchPhase.BEGAN);
        if (touch)
        {
          _tempPoint = touch.getLocation(_scrollable);
        }
        
        touch = e.getTouch(_scrollable, TouchPhase.ENDED);
        if (touch)
        {
          trace("Clicked");
          var p:Point = touch.getLocation(_scrollable);
          
          // Did not scroll to far, probably a click.
          if (Math.abs(p.y - _tempPoint.y) < 50)
          {
            p.y += _scroller.verticalScrollPosition;
            that.removeChild(_goButton);
            that.removeChild(box);
            that.removeChild(_scroller);
            unpause();
            that.removeChild(_scrollable);
            
          }
        }
      }
      _scrollable.addEventListener(TouchEvent.TOUCH, onTouch);
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
    
    protected function winScreenTouch(event:TouchEvent):void
    {
      var touch:Touch;
      touch = event.getTouch(this, TouchPhase.ENDED);
      if (touch)
      {
        var score:Object = {score: _score, lives: _snake.lives, time: _overallTimer, level: _levelNr, snake: _snake, lid: _lid}
        AssetRegistry.soundmanager.fadeOutMusic();
        dispatchEventWith(ManagedStage.SWITCHING, true, {stage: LevelScore, args: score});
        SaveGame.unlockLevel(_levelNr + 1);
      }
    }
    
    private function setSpeed():void
    {
      if (SaveGame.difficulty == 1)
      {
        SaveGame.startSpeed = 7;
      }
      else
      {
        SaveGame.startSpeed = 10;
      }
      _speed = 1 / SaveGame.startSpeed;
    
    }
    
    private function initializeTextPool():void
    {
      _textFieldPool = new Vector.<TextField>;
      _textLayer = new Sprite;
      for (var i:int = 0; i < 15; i++)
      {
        var temp:TextField = new TextField(100, 100, "", "kroeger 06_65");
        temp.visible = false;
        _textLayer.addChild(temp);
        _textFieldPool.push(temp);
      }
    }
    
    private function createBonusBar():void
    {
      _bonusBar = new Quad(1, 8, 0xffffff);
      _bonusBack = new Quad(27, 10, 0x000000);
      
      _bonusBack.alpha = 0;
      _bonusBar.scaleX = 0;
      _levelStage.addChild(_bonusBack);
      _levelStage.addChild(_bonusBar);
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
    
    public function get rottenEggs():Eggs.Eggs
    {
      return _rottenEggs;
    }
    
    public function get timeExtension():Number
    {
      return _timeExtension;
    }
    
    public function set timeExtension(value:Number):void
    {
      _timeExtension = value;
    }
    
    public function get chainTime():Number
    {
      return _chainTime;
    }
    
    public function set chainTime(value:Number):void
    {
      _chainTime = value;
    }
    
    public function get extensionTime():Number
    {
      return _extensionTime;
    }
    
    public function set extensionTime(value:Number):void
    {
      _extensionTime = value;
    }
    
    public function get timeExtensionTime():Number
    {
      return _timeExtensionTime;
    }
    
    public function set timeExtensionTime(value:Number):void
    {
      _timeExtensionTime = value;
    }
    
    public function get overallTimer():Number
    {
      return _overallTimer;
    }
    
    public function set bonusTimer(value:Number):void
    {
      _bonusTimer = value;
    }
    
    public function adjustBonusBack(width:int):void
    {
      _bonusBack.color = 0xffff00;
      _bonusBack.width = width;
    }
    
    public function get eggs():Eggs
    {
      return _eggs;
    }
    
    public function set eggs(value:Eggs):void
    {
      _eggs = value;
    }
    
    public function get gameJuggler():Juggler
    {
      return _gameJuggler;
    }
    
    public function get levelStage():Sprite
    {
      return _levelStage;
    }
    
    override public function dispose():void
    {
      var i:int = 0;
      
      for each (var tween:GTween in _tweens)
      {
        tween.end();
      }
      _tweens = new Vector.<GTween>;
      // Maybe this Level plays music
      AssetRegistry.soundmanager.fadeOutMusic();
      
      removeChildren();
      
      _textLayer.dispose();
      _textLayer = null;
      
      for (i = 0; i < _textFieldPool.length; i++)
      {
        _textFieldPool[i].dispose();
      }
      
      _currentCombos = null;
      
      this.removeEventListeners(EnterFrameEvent.ENTER_FRAME);
      Starling.current.stage.removeEventListeners(KeyboardEvent.KEY_DOWN);
      this.removeEventListeners(TouchEvent.TOUCH);
      
      _comboSet.dispose();
      _comboSet = null;
      _levelStage.removeChildren();
      _levelStage.dispose();
      _levelStage = null;
      _bg.dispose();
      _bg = null;
      _bgTexture = null;
      _obstacles = null;
      _spawnMap = null;
      _snake.removeEventListener(Snake.Snake.SNAKE_MOVED, onSnakeMoved);
      _snake.dispose();
      _snake = null;
      _eggs.dispose();
      _eggs = null;
      _rottenEggs.dispose();
      _rottenEggs = null;
      _hud.dispose();
      _hud = null;
      _bonusBar.dispose();
      _bonusBar = null;
      _bonusBack.dispose();
      _bonusBack = null;
      _mchammer.dispose();
      _mchammer = null;
      _pauseMenu.dispose();
      _pauseMenu = null;
      
      for each (var particle:PDParticleSystem in _particles)
      {
        particle.dispose();
      }
      _particles = null;
      
      _gameJuggler.purge();
      _gameJuggler = null;
      
      super.dispose();
    
    }
  
  }

}
