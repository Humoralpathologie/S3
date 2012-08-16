package UI
{
  import flash.geom.Point;
  import Level.LevelState;
  import starling.animation.Tween;
  import starling.display.Button;
  import starling.display.DisplayObject;
  import starling.display.Image;
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
  
  /**
   * ...
   * @author Roger Braun
   */
  public class HUD extends Sprite
  {
    public static const CONTROLS_CHANGED:String = "controlschanged";
    public static const DISPLAY_MESSAGE:String = "displaymessage";
    
    private var _controls:Sprite;
    private var _top:Image;
    private var _buttons:Vector.<Button>;
    private var _levelState:LevelState;
    private var _icons:Vector.<DisplayObject>;
    private var _iconsCfg:Object = { };
    private var _iconLayer:Sprite;
    private var _textLayer:Sprite;
    private var _score:TextField;
    private var _tweens:Vector.<Tween>;
    private var _textMessagesPool:Vector.<TextField>;
    
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
      
      createTop();
      createControls();
      
      addChild(_top);
      addChild(_controls);
      addChild(_iconLayer);
      addChild(_textLayer);
      
      // Listen if the controls change in the pause menu.
      _levelState.addEventListener(HUD.CONTROLS_CHANGED, onControlsChanged);
      
      // Listen if we should display any messages.
      _levelState.addEventListener(HUD.DISPLAY_MESSAGE, onDisplayMessage);
    }
    
    private function recycleMessage():TextField {
      var i:int;
      var txt:TextField;
      
      for (i = 0; i < _textMessagesPool.length; i++) {
        if (_textMessagesPool[i].visible == false) {
          _textMessagesPool[i].y = 0;
          trace("Recycling old message");
          return _textMessagesPool[i];
        }
      }
      
      trace("Making a new message");
      txt = new TextField(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, "", "kroeger 06_65", 90, Color.WHITE);
      txt.touchable = false;
      _textMessagesPool.push(txt);
      return txt;
    }
    
    private function onDisplayMessage(evt:Event) {
      var tween:Tween;
      var textMessage:TextField;
      
      textMessage = recycleMessage();
      textMessage.text = evt.data.message;
      
      tween = new Tween(textMessage, 3);
      tween.animate("y", -textMessage.height);
      tween.onComplete = function():void {
        textMessage.visible = false;
      }
      _tweens.push(tween);
      Starling.juggler.add(tween);
 
      _textLayer.addChild(textMessage);     
    }
    
    public function set iconsCfg(value:Object):void {
      _iconsCfg = value;
      createIcons();
    }
    
    public function update():void {
      // Update score display.
      _score.text = _levelState.score;
      
      // Update all icon TextFields.
      for each (var iconCfg in _iconsCfg) {
        iconCfg.textField.text = _levelState[iconCfg.watching];
      }
    }
    
    // Creates icons AND the necessary text. This also creates the score display.
    private function createIcons():void {
      var iconImg:Image;
      var iconTxt:TextField;
      var pos:Point;
      var iconCfg:Object;
            
      // Create the score display.
      _score = new TextField(Starling.current.stage.stageWidth, 100, "0", "kroeger 06_65", 80, Color.WHITE);
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
    
    // TODO: Actually write this.
    private function destroyIcons():void {
      _score.dispose();
      _score = null;
      _icons = null;
    }
    
    private function createTop():void {
      _top = new Image(AssetRegistry.UIAtlas.getTexture("ui-top"));
      _top.addEventListener(TouchEvent.TOUCH, function(evt:TouchEvent) {
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
      trace("Creating buttons type " + String(SaveGame.controlType));
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
        left180: { x: 0, y: 190, texture: "ui-classic-180-left", fn: function() { _levelState.snake.oneeightyLeft() }},
        right180: { x: 480, y: 190, texture: "ui-classic-180-right", fn: function() { _levelState.snake.oneeightyRight() }},
        left: { x: 0, y: 490, texture: "ui-classic-left", fn: function() { _levelState.snake.moveLeft() }},
        right: { x: 480, y: 490, texture: "ui-classic-right", fn: function() { _levelState.snake.moveRight() }}  
        };
      createButtonsHelper(buttonConfig);
    }
    
    private function createType2Buttons():void {
      var buttonConfig:Object = {
        up: { x: 490, y: 190, texture: "ui-4way-bottom-up", fn: function() { _levelState.snake.changeDirection(AssetRegistry.UP); }},
        down: { x: 490, y: 500, texture: "ui-4way-bottom-down", fn: function() { _levelState.snake.changeDirection(AssetRegistry.DOWN); }},
        left: { x: 0, y: 190, texture: "ui-4way-bottom-left", fn: function() { _levelState.snake.changeDirection(AssetRegistry.LEFT);}},
        right: { x: 190, y: 190, texture: "ui-4way-bottom-right", fn: function() { _levelState.snake.changeDirection(AssetRegistry.RIGHT); }}  
        };
      createButtonsHelper(buttonConfig);
    }    
    
    private function createButtonsHelper(buttonConfig:Object) {
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
          button.addEventListener(TouchEvent.TOUCH, function(evt:TouchEvent) {
            if (evt.getTouch(button, TouchPhase.BEGAN)) {
              callback();
            }
          });
        };
        tmp(button, btnData.fn);
        tmp = null;
        
        _buttons.push(button);
        _controls.addChild(button);
      }
    }
    
    private function destroyIconLayer():void {
      destroyIcons();
      _iconLayer.dispose();
      _iconLayer = null;
    }
    
    private function onControlsChanged(evt:Event) {
      createButtons();
    }
    
    override public function dispose():void {
      super.dispose();
      _levelState.removeEventListener(HUD.DISPLAY_MESSAGE, onDisplayMessage);
      _levelState.removeEventListener(HUD.CONTROLS_CHANGED, onControlsChanged);
      
      //TODO: tweens, textfieldpool
      destroyIconLayer();
      destroyTop();
      destroyControls();
    }
  
  }

}