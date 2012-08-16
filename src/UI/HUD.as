package UI
{
  import flash.geom.Point;
  import Level.LevelState;
  import starling.display.Button;
  import starling.display.DisplayObject;
  import starling.display.Image;
  import starling.display.Sprite;
  import engine.AssetRegistry;
  import starling.events.Event;
  import starling.events.TouchEvent;
  import starling.events.TouchPhase;
  import engine.SaveGame;
  import starling.text.TextField;
  import starling.textures.Texture;
  import starling.utils.Color;
  import starling.utils.VAlign;
  import starling.utils.HAlign;
  
  /**
   * ...
   * @author Roger Braun
   */
  public class HUD extends Sprite
  {
    private var _controls:Sprite;
    private var _top:Image;
    private var _buttons:Vector.<Button>;
    private var _levelState:LevelState;
    private var _icons:Vector.<DisplayObject>;
    private var _iconLayer:Sprite;
    private var _textLayer:Sprite;
    
    public function HUD(levelState:LevelState)
    {
      _levelState = levelState;
      _iconLayer = new Sprite();
      
      // TextFields always force a new draw call, so add them last!
      _textLayer = new Sprite();
      
      createTop();
      createControls();
      
      addChild(_top);
      addChild(_controls);
      addChild(_iconLayer);
      addChild(_textLayer);
    }
    
    public function set icons(value:Object):void {
      if (_icons) { destroyIcons() };
      createIcons(value);
    }
    
    // Creates icons AND the necessary text.
    private function createIcons(iconsCfg:Object):void {
      var iconImg:Image;
      var iconTxt:TextField;
      var pos:Point;
      for each(var iconCfg:Object in iconsCfg) {
        
        // Make the Icon
        pos = getIconPos(iconCfg.pos);
        iconImg = new Image(getIconTexture(iconCfg.type));
        iconImg.x = pos.x;
        iconImg.y = pos.y;
        iconImg.scaleX = 2;
        iconImg.scaleY = 2;
        iconImg.touchable = false;
        
        // Make the text
        iconTxt = new TextField(80, iconImg.height, "0", "kroeger 06_65", 40, Color.WHITE);
        iconTxt.vAlign = VAlign.CENTER;
        iconTxt.hAlign = HAlign.LEFT;
        iconTxt.text = "X";
        iconTxt.touchable = false;
        iconTxt.x = iconImg.x + iconImg.width + 12;
        iconTxt.y = iconImg.y;
        
        _iconLayer.addChild(iconImg);
        _textLayer.addChild(iconTxt);   
        _icons.push(iconTxt);
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
      _icons = null;
    }
    
    private function createTop():void {
      _top = new Image(AssetRegistry.UIAtlas.getTexture("ui-top"));
    }
    
    private function destroyTop():void {
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
    
    override public function dispose():void {
      super.dispose();
      destroyIconLayer();
      destroyTop();
      destroyControls();
    }
  
  }

}