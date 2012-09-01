package UI
{
  import Eggs.Egg;
  import flash.geom.Point;
  import Level.LevelState;
  import Snake.BodyPart;
  import starling.animation.Tween;
  import starling.display.Button;
  import starling.display.DisplayObject;
  import starling.display.Image;
  import starling.display.QuadBatch;
  import starling.display.Sprite;
  import engine.AssetRegistry;
  import starling.events.Event;
  import starling.events.Touch;
  import starling.events.TouchEvent;
  import starling.events.TouchPhase;
  import engine.SaveGame;
  import starling.text.TextField;
  import starling.textures.Texture;
  import starling.utils.Color;
  import starling.utils.VAlign;
  import starling.utils.HAlign;
  import starling.core.Starling;
  import Snake.Snake;  
  
  /**
   * ...
   * @author Roger Braun
   */
  public class HUD extends Sprite
  {
    public static const CONTROLS_CHANGED:String = "controlschanged";
    public static const DISPLAY_MESSAGE:String = "displaymessage";
    public static const DISPLAY_POINTS:String = "displaypoints";
    
    private var _controls:Sprite;
    private var _top:Image;
    private var _buttons:Vector.<Button>;
    private var _levelState:LevelState;
    private var _iconsCfg:Object = { };
    private var _iconLayer:Sprite;
    private var _textLayer:Sprite;
    private var _score:TextField;
    private var _tweens:Vector.<Tween>;
    private var _textMessagesPool:Vector.<TextField>;
    private var _tailView:Sprite;
    private var _tailViewBoxes:Vector.<Image>;
    private var _radarCircle:Image;
    private var _radarEggsLayer:Sprite;
    private var _radarEggs:Vector.<Image>;
    private var _center:Point;
    private var _messageQueue:Vector.<String>;
    private var _messageQueueRunning:Boolean = false;
    private var _pointsQueue:Vector.<Object>;
    private var _pointsQueueRunning:Boolean = false;   
    
    private var _scoreDisplay:int = 0;
    
    public function HUD(levelState:LevelState)
    {
      _levelState = levelState;
      _iconLayer = new Sprite();
      _iconLayer.touchable = false;
      
      // TextFields always force a new draw call, so add them last!
      _textLayer = new Sprite();
      _textLayer.touchable = false;
      
      // This keeps our tweens.
      _tweens = new Vector.<Tween>;
      
      // This is to re-use TextFields for message display.
      _textMessagesPool = new Vector.<TextField>;
      
      // Initialize message queue.
      _messageQueue = new Vector.<String>;
      _messageQueueRunning = false;
    
      // Initialize points queue.
      _pointsQueue = new Vector.<Object>;
      _pointsQueueRunning = false;
      
      // A center point so we don't need to recalculate
      _center = new Point(AssetRegistry.STAGE_WIDTH / 2, AssetRegistry.STAGE_HEIGHT / 2);
      
      createTop();
      createControls();
      createTailView();
      createRadarCircle();
      createRadarEggs();
      
      // UIAtlas.
      addChild(_top);
      addChild(_controls);
      addChild(_radarCircle);
      // SnakeAtlas.
      addChild(_iconLayer);
      addChild(_tailView);
      addChild(_radarEggsLayer);
      // Text, so it doesn't matter.
      addChild(_textLayer);
      
      // Listen if the controls change in the pause menu.
      _levelState.addEventListener(HUD.CONTROLS_CHANGED, onControlsChanged);
      
      // Listen if we should display any messages.
      _levelState.addEventListener(HUD.DISPLAY_MESSAGE, onDisplayMessage);
      
      // Listen if we should display any points.
      _levelState.addEventListener(HUD.DISPLAY_POINTS, onDisplayPoints);
      
      // Listen for changes in the snake body.
      _levelState.addEventListener(Snake.Snake.BODY_CHANGED, onSnakeBodyChanged);
    }
    
    private function createRadarEggs():void {      
      var i:int;
      
      _radarEggsLayer = new Sprite();
      _radarEggsLayer.touchable = false;
      
      _radarEggs = new Vector.<Image>;
      
      for (i = 0; i < 20; i++) {
        _radarEggs.push(new Image(getRadarEggTexture(AssetRegistry.EGGA)));
        _radarEggs[i].visible = false;
        _radarEggsLayer.addChild(_radarEggs[i]);
      }
    }
    
    private function getRadarEggTexture(type:int):Texture {
      var texture:Texture;
      
      switch(type) {
        case AssetRegistry.EGGA:
            texture = AssetRegistry.SnakeAtlas.getTexture("radar_a");
            break;
        case AssetRegistry.EGGB:
            texture = AssetRegistry.SnakeAtlas.getTexture("radar_b");
            break;
        case AssetRegistry.EGGC:
            texture = AssetRegistry.SnakeAtlas.getTexture("radar_c");
            break;
        case AssetRegistry.EGGGOLDEN:
            texture = AssetRegistry.SnakeAtlas.getTexture("radar_gold");
            break;
        case AssetRegistry.EGGSHUFFLE:
            texture = AssetRegistry.SnakeAtlas.getTexture("radar_shuffle");
            break;           
        case AssetRegistry.EGGZERO:
            texture = AssetRegistry.SnakeAtlas.getTexture("radar_green");
            break;        
        case AssetRegistry.EGGROTTEN:
            texture = AssetRegistry.SnakeAtlas.getTexture("radar_rotten");
            break;                   
      }
    
      return texture;
    }
        
    private function createRadarCircle():void {
      _radarCircle = new Image(AssetRegistry.UIAtlas.getTexture("KreisRadar"));
      _radarCircle.x = (AssetRegistry.STAGE_WIDTH - _radarCircle.width) / 2;
      _radarCircle.y = (AssetRegistry.STAGE_HEIGHT - _radarCircle.height) / 2;
    }
    
    private function onSnakeBodyChanged(evt:Event):void {
      updateTailView(_levelState.snake.getTailTypes());
    }
    
    private function createTailView():void {
      var i:int;
      var tailViewBox:Image;
      
      var baseX:int = 750;
      var baseY:int = 10;
      
      _tailView = new Sprite();
      _tailView.touchable = false;
      _tailViewBoxes = new Vector.<Image>;
          
      for (i = 0; i < 5; i++) {
        tailViewBox = new Image(tailViewTexture(AssetRegistry.EGGNONE));
        tailViewBox.y = baseY;
        tailViewBox.x = baseX + (tailViewBox.width * i);
        _tailView.addChild(tailViewBox);
        _tailViewBoxes.push(tailViewBox);
      }
      
      updateTailView(_levelState.snake.getTailTypes());
    }
    
    private function updateTailView(types:Array):void {
      var i:int;
      // There should always be an eggtype for every box.
      if (types.length != _tailViewBoxes.length) {
        return;
      }
      for (i = 0; i < types.length; i++) {
        _tailViewBoxes[i].texture = tailViewTexture(types[i]);
      }
    }
    
    private function recycleMessage():TextField {
      var i:int;
      var txt:TextField;
      
      for (i = 0; i < _textMessagesPool.length; i++) {
        if (_textMessagesPool[i].visible == false) {
          txt = _textMessagesPool[i];
          txt.y = 0;
          txt.x = 0;
          txt.color = Color.WHITE;
          txt.rotation = 0;
          txt.alpha = 1;
          txt.visible = true;
          txt.scaleX = txt.scaleY = 1;
          txt.pivotX = txt.pivotY = 0;
          txt.height = AssetRegistry.STAGE_WIDTH;
          txt.width = AssetRegistry.STAGE_HEIGHT;
          trace("Recycling old message");
          return _textMessagesPool[i];
        }
      }
      
      trace("Making a new message");
      txt = new TextField(AssetRegistry.STAGE_WIDTH, AssetRegistry.STAGE_HEIGHT, "", "kroeger 06_65", 90, Color.WHITE);
      txt.touchable = false;
      _textMessagesPool.push(txt);
      return txt;
    }
    
    private function showMessage(message:String):void {
      var tween:Tween;
      var textMessage:TextField;      
      textMessage = recycleMessage();
      textMessage.text = message; 
        
      tween = new Tween(textMessage, 3);
      tween.animate("y", -textMessage.height);
      tween.onComplete = function():void {
        textMessage.visible = false;
        
      }
        
      _tweens.push(tween);
      _levelState.gameJuggler.add(tween);
     
      _textLayer.addChild(textMessage);       
    }
    
    private function showPoint(pointObj:Object):void {
      var tween:Tween;
      var textMessage:TextField;  
      var variant:int = pointObj.variant;
      //var variant:int = Math.floor(Math.random() * 2);
      
      textMessage = recycleMessage();
      textMessage.text = pointObj.message; 
      textMessage.color = pointObj.color;

      tween = new Tween(textMessage, 2);
      textMessage.height = 200;
      textMessage.width = 200;
      textMessage.scaleX = textMessage.scaleY = 0.5; 
      tween.animate("scaleX", 2);
      tween.animate("scaleY", 2);
      tween.animate("alpha", 0);
      tween.onComplete = function():void {
       textMessage.visible = false;
       _scoreDisplay += int(pointObj.message);
      }
 
      textMessage.width = 200;
      textMessage.height = 200;
      
      if (variant == 0) {
        textMessage.x = 0;
        textMessage.y = 640;      
        tween.animate("x", 280);
        tween.animate("y", -(Math.sqrt(80000)/2));
        tween.animate("rotation", - 90 * (Math.PI / 180));        
      } else {
        textMessage.x = 960;
        textMessage.y = 640;
        tween.animate("x", 480);
        tween.animate("y", -(Math.sqrt(80000)*2.5));
        tween.onUpdate = function():void {
          textMessage.pivotX = textMessage.width;
        }
        tween.animate("rotation", 45* (Math.PI / 180));        
      }
      _tweens.push(tween);
      _levelState.gameJuggler.add(tween);
     
      _textLayer.addChild(textMessage);       
    }    
    
    private function showNextMessage():void {  
      trace("Showing next message");
      // Stop if we don't have queue
      if (!_messageQueue) { _messageQueueRunning = false;  return; }
        
      if (_messageQueue.length > 0) {
        var message:String = _messageQueue.pop();
        showMessage(message);
        _levelState.gameJuggler.delayCall(showNextMessage, 0.5);
      } else {
        _messageQueueRunning = false;
      }
    }

    private function showNextPoint():void {  
      trace("Showing next point");
      // Stop if we don't have queue
      if (!_pointsQueue) { _pointsQueueRunning = false;  return; }
        
      if (_pointsQueue.length > 0) {
        var pointObj:Object = _pointsQueue.pop();
        showPoint(pointObj);
        _levelState.gameJuggler.delayCall(showNextPoint, 0.2);
      } else {
        _pointsQueueRunning = false;
      }
    }    
    
    private function startMessageQueue():void {
      trace("Starting message queue");
      _messageQueueRunning = true;    
      showNextMessage();
    }

    private function startPointsQueue():void {
      trace("Starting points queue");
      _pointsQueueRunning = true;    
      showNextPoint();
    }    
    
    private function onDisplayMessage(evt:Event):void {
      _messageQueue.push(evt.data.message);
      trace(_messageQueueRunning);
      if (!_messageQueueRunning) {
        startMessageQueue();
      }
    }
    
    private function onDisplayPoints(evt:Event):void {
      _pointsQueue.push(evt.data);
      if (!_pointsQueueRunning) {
        startPointsQueue();
      }
    }    
    
    public function set iconsCfg(value:Object):void {
      _iconsCfg = value;
      createIcons();
    }
    
    public function update():void {
      var i:int;
      var levelEggs:Vector.<Egg> = _levelState.eggs.eggPool;
      var radarEgg:Image;
      var levelEgg:Egg;
      var pos:Point = new Point();
      var levelEggsLength:int = levelEggs.length;
      
      // Update score display.
      _score.text = String(_scoreDisplay);
      
      // Update all icon TextFields.
      for each (var iconCfg:Object in _iconsCfg) {
        iconCfg.textField.text = _levelState[iconCfg.watching];
      }
      
      // Update radar      
      for (i = 0; i < _radarEggs.length; i++) {
        radarEgg = _radarEggs[i]; 
        
        if (i < levelEggsLength && levelEggs[i].visible) {
          levelEgg = levelEggs[i];
          
          radarEgg.texture = getRadarEggTexture(levelEgg.type);
          setRadarEggPosition(levelEgg, radarEgg);
          
          radarEgg.visible = true;
        } else {
          radarEgg.visible = false;
        }
      }
    }
    
    private function setRadarEggPosition(egg:Egg, radarEgg:Image):void {
      var theta:Number;
      var dx:Number, dy:Number;
      
      dx = egg.x - _levelState.snake.head.x;
      dy = egg.y - _levelState.snake.head.y;
      theta = Math.atan2(dy, dx);
          
      radarEgg.x = (_center.x - (radarEgg.width) / 2) + (210 * Math.cos(theta));
      radarEgg.y = (_center.y - (radarEgg.height) / 2) + (210 * Math.sin(theta));               
    }
    
    // Creates icons AND the necessary text. This also creates the score display.
    private function createIcons():void {
      var iconImg:Image;
      var iconTxt:TextField;
      var pos:Point;
      var iconCfg:Object;
            
      // Create the score display.
      _score = new TextField(AssetRegistry.STAGE_WIDTH, 100, "0", "kroeger 06_65", 80, Color.WHITE);
      _score.touchable = false;
      _textLayer.addChild(_score);
      
      // Make the level-dependent icons.
      
      for (var iconName:String in _iconsCfg) {
        iconCfg = _iconsCfg[iconName];
        // Make the Icon
        pos = getIconPos(iconCfg.pos);
        iconImg = new Image(getIconTexture(iconCfg.type));
        iconImg.x = pos.x;
        iconImg.y = pos.y;
        iconImg.scaleX = 2;
        iconImg.scaleY = 2;
        iconImg.touchable = false;
        
        // Make the TextFields. These are wide to accomodate the long time display.
        iconTxt = new TextField(200, iconImg.height, "0", "kroeger 06_65", 40, Color.WHITE);
        iconTxt.vAlign = VAlign.CENTER;
        iconTxt.hAlign = HAlign.LEFT;
        iconTxt.text = "X";
        iconTxt.touchable = false;
        iconTxt.x = iconImg.x + iconImg.width + 12;
        iconTxt.y = iconImg.y;
        
        // Remember this so we can change it later.
        iconCfg.textField = iconTxt;
        
        _iconLayer.addChild(iconImg);
        _textLayer.addChild(iconTxt);   
      }
    }
    
    private function getIconPos(pos:int):Point {
      var pnt:Point = new Point();
      switch(pos) {
        case 1:
          pnt.x = 12;
          pnt.y = 12;
          break;
        case 2:
          pnt.x = 108;
          pnt.y = 12;
          break;
        case 3:
          pnt.x = 12;
          pnt.y = 70;
          break;
        case 4:
          pnt.x = 108;
          pnt.y = 70;
          break;
      }
      return pnt;
    }
    
    private function getIconTexture(type:String):Texture {
      var txtr:Texture;
      switch(type) {
        case "lives":
          txtr =  AssetRegistry.SnakeAtlas.getTexture("icon-lives");
          break;  
        default:
          txtr = AssetRegistry.SnakeAtlas.getTexture("icon-" + type);
          break;
      }
      return txtr;
    }
    
    private function destroyIcons():void {
       _iconsCfg = null;
      _iconLayer.removeChildren(0, -1, true);
      _iconLayer.dispose();
      _iconLayer = null;
      _score.removeFromParent(true);
      _score = null;
      _textLayer.removeChildren(0, -1, true);
      _textLayer.dispose();
      _textLayer = null;
    }
    
    private function createTop():void {
      _top = new Image(AssetRegistry.UIAtlas.getTexture("ui-top"));
      _top.addEventListener(TouchEvent.TOUCH, function(evt:TouchEvent):void {
          if (evt.getTouch(_top, TouchPhase.ENDED)) {
            _levelState.togglePause();
          }
      });
    }
    
    private function destroyTop():void {
      _top.removeEventListeners(TouchEvent.TOUCH);
      _top.dispose();
      _top = null;      
    }
    
    private function createControls():void {
      _controls = new Sprite();
      createButtons();
    }
        
    private function destroyControls():void {
      destroyButtons();
      _controls.dispose();
      _controls = null;
    }
    
    private function destroyButtons():void {
      var i:int = 0;
      if (!_buttons) { return; }
      for (i = 0; i < _buttons.length; i++) {
        _buttons[i].removeEventListeners();
        _buttons[i].removeFromParent(true);
      }
      _buttons = null;
    }
    
    private function createButtons():void {
      // There may already be buttons;
      destroyButtons();
      _buttons = new Vector.<Button>;
      if(SaveGame.controlType == 1) {
        createType1Buttons();
      } else {
        createType2Buttons();
      }
    }
    
    private function createType1Buttons():void {
      var buttonConfig:Object = {
        left180: { x: 0, y: 190, texture: "ui-classic-180-left", fn: function():void { _levelState.snake.oneeightyLeft() }},
        right180: { x: 480, y: 190, texture: "ui-classic-180-right", fn: function():void { _levelState.snake.oneeightyRight() }},
        left: { x: 0, y: 490, texture: "ui-classic-left", fn: function():void { _levelState.snake.moveLeft() }},
        right: { x: 480, y: 490, texture: "ui-classic-right", fn: function():void { _levelState.snake.moveRight() }}  
        };
      createButtonsHelper(buttonConfig);
    }
    
    private function createType2Buttons():void {
      var buttonConfig:Object = {
        up: { x: 490, y: 190, texture: "ui-4way-bottom-up", fn: function():void { _levelState.snake.changeDirection(AssetRegistry.UP); }},
        down: { x: 490, y: 500, texture: "ui-4way-bottom-down", fn: function():void { _levelState.snake.changeDirection(AssetRegistry.DOWN); }},
        left: { x: 0, y: 190, texture: "ui-4way-bottom-left", fn: function():void { _levelState.snake.changeDirection(AssetRegistry.LEFT);}},
        right: { x: 190, y: 190, texture: "ui-4way-bottom-right", fn: function():void { _levelState.snake.changeDirection(AssetRegistry.RIGHT); }}  
        };
      createButtonsHelper(buttonConfig);
    }    
    
    private function createButtonsHelper(buttonConfig:Object):void {
      var button:Button;
      
      for each(var btnData:Object in buttonConfig) {
        button = new Button(AssetRegistry.UIAtlas.getTexture(btnData.texture));
        button.x = btnData.x;
        button.y = btnData.y;
        
        // We use TouchEvent.TOUCH instead of Event.TRIGGERED because we want
        // to react on press, not on release. The wrapper function closes over
        // the button and the callback function.
        // TODO: Maybe this should be rewritten with Events?
        
        var tmp:Function = function(button:Button, callback:Function):void {
          button.addEventListener(TouchEvent.TOUCH, function(evt:TouchEvent):void {
            if (evt.getTouch(button, TouchPhase.BEGAN)) {
              callback();
            }
          });
        };
        tmp(button, btnData.fn);
        
        _buttons.push(button);
        _controls.addChild(button);
      }
    }
    
    private function onControlsChanged(evt:Event):void {
      createButtons();
    }
    
    private function destroyTweens():void {
      var i:int;
      for (i = 0; i < _tweens.length; i++) {
        _levelState.gameJuggler.remove(_tweens[i]);
        _tweens[i] = null;
      }
      _tweens = null;
    }
    
    private function destroyTextMessagesPool():void {
      var i:int;
      for (i = 0; i < _textMessagesPool.length; i++) {
        _textMessagesPool[i].dispose();
        _textMessagesPool[i] = null;
      }
      _textMessagesPool = null;
    }
    
    private function tailViewTexture(eggType:int):Texture {
      var type:String;
      switch (eggType) {    
        case AssetRegistry.EGGZERO:
          type = "PreviewIconEiGreen";
        break;
        case AssetRegistry.EGGA:
          type = "PreviewIconEiA";
        break;
        case AssetRegistry.EGGB:
          type = "PreviewIconEiB";
        break;
        case AssetRegistry.EGGC:
          type = "PreviewIconEiC";
        break;
        case AssetRegistry.EGGROTTEN:
          type = "PreviewIconEiRotten";
        break;
        default:
          type = "UIBoxFuerPreview";
        break;
      } 
      return AssetRegistry.SnakeAtlas.getTexture(type);
    }
    
    private function destroyRadarCircle():void {
      _radarCircle.removeFromParent(true);
      _radarCircle = null;
    }
    
    override public function dispose():void {
      super.dispose();
      
      _levelState.removeEventListener(Snake.Snake.BODY_CHANGED, onSnakeBodyChanged);
      _levelState.removeEventListener(HUD.DISPLAY_POINTS, onDisplayPoints);
      _levelState.removeEventListener(HUD.DISPLAY_MESSAGE, onDisplayMessage);
      _levelState.removeEventListener(HUD.CONTROLS_CHANGED, onControlsChanged);
      
      //TODO: tailview, radareggs, messagequeue
      destroyRadarCircle();
      destroyTextMessagesPool();
      destroyTweens();
      destroyIcons();
      destroyTop();
      destroyControls();
    }
  
  }

}