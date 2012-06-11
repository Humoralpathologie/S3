package Menu
{
  import engine.ManagedStage;
  import flash.geom.Point;
  import starling.display.DisplayObject;
  import starling.display.Image;
  import starling.display.Quad;
  import starling.display.Sprite;
  import engine.AssetRegistry;
  import starling.events.Touch;
  import starling.events.TouchEvent;
  import starling.events.TouchPhase;
  import starling.core.Starling;
  import engine.StageManager;
  import Level.*;
  
  /**
   * ...
   * @author
   */
  public class LevelSelect extends ManagedStage
  {
    private var _bg:Quad;
    private var _levelInfo:Sprite;
    private var _showingInfo:Boolean;
    private var _levelName:Image;
    private var _scrollable:Sprite;
    private var _slideY:Number = 0;
    
    public function LevelSelect()
    {
      
      AssetRegistry.loadLevelSelectGraphics();
      
      _scrollable = new Sprite();
      _scrollable.addEventListener(TouchEvent.TOUCH, onTouch);
      _levelInfo = new Sprite();
      _levelInfo.addChild(new Image(AssetRegistry.LevelSelectAtlas.getTexture("info-level")));
      
      _showingInfo = false;
      _levelName = new Image(AssetRegistry.LevelSelectAtlas.getTexture("text-info-level1"));
      
      _bg = new Quad(960, 2240, 0xCDB594);
      _scrollable.addChild(_bg);
      
      var header:Image = new Image(AssetRegistry.LevelSelectAtlas.getTexture("header_15-20"));
      header.x = 15;
      header.y = 20;
      _scrollable.addChild(header);
      
      var level1:Image = new Image(AssetRegistry.LevelSelectAtlas.getTexture("tile-level1_15-262"));
      level1.x = 15;
      level1.y = 262;
      level1.addEventListener(TouchEvent.TOUCH, showLevelInfo(1));
      _scrollable.addChild(level1);
      
      var lockedLevel:Image;
      
      var level2:Image = new Image(AssetRegistry.LevelSelectAtlas.getTexture("tile-level2_261-377"));
      level2.x = 261;
      level2.y = 377;
      lockedLevel = new Image(AssetRegistry.LevelSelectAtlas.getTexture("tile-level-locked"));
      lockedLevel.x = level2.x;
      lockedLevel.y = level2.y;
      level2.addEventListener(TouchEvent.TOUCH, showLevelInfo(2));
      
      //_scrollable.addChild(level2);
      _scrollable.addChild(lockedLevel);
      
      var level3:Image = new Image(AssetRegistry.LevelSelectAtlas.getTexture("tile-level3_514-509"));
      level3.x = 514;
      level3.y = 509;
      level3.alpha = 0.5;
      level3.addEventListener(TouchEvent.TOUCH, showLevelInfo(3));
      
      _scrollable.addChild(level3);
      
      var level4:Image = new Image(AssetRegistry.LevelSelectAtlas.getTexture("tile-level4_261-626"));
      level4.x = 261;
      level4.y = 626;
      level4.alpha = 0.5;
      level4.addEventListener(TouchEvent.TOUCH, showLevelInfo(4));
      
      _scrollable.addChild(level4);
      
      var level5:Image = new Image(AssetRegistry.LevelSelectAtlas.getTexture("tile-level5_11-743"));
      level5.x = 11;
      level5.y = 743;
      level5.alpha = 0.5;
      level5.addEventListener(TouchEvent.TOUCH, showLevelInfo(5));
      
      _scrollable.addChild(level5);
      
      var level6:Image = new Image(AssetRegistry.LevelSelectAtlas.getTexture("tile-level6_261-890"));
      level6.x = 261;
      level6.y = 890;
      level6.alpha = 0.5;
      level6.addEventListener(TouchEvent.TOUCH, showLevelInfo(6));
      
      _scrollable.addChild(level6);
      
      var level7:Image = new Image(AssetRegistry.LevelSelectAtlas.getTexture("tile-level7_515-1009"));
      level7.x = 515;
      level7.y = 1009;
      level7.alpha = 0.5;
      level7.addEventListener(TouchEvent.TOUCH, showLevelInfo(7));
      
      _scrollable.addChild(level7);
      
      var level8:Image = new Image(AssetRegistry.LevelSelectAtlas.getTexture("tile-boss_54-1190"));
      level8.x = 54;
      level8.y = 1190;
      level8.alpha = 0.5;
      level8.addEventListener(TouchEvent.TOUCH, showLevelInfo(8));
      
      _scrollable.addChild(level8);
      
      addChild(_scrollable);
      
      _scrollable.flatten();
    
    }
    
    private function showLevelInfo(level:int):Function
    {
      var that:Sprite = this;
      return function(event:TouchEvent):void
      {
        if (!_showingInfo)
        {
          var touch:Touch = event.getTouch(that, TouchPhase.ENDED)
          if (touch)
          {
            if (_slideY < 50)
            {
              _levelInfo.removeChild(_levelName);
              _levelName.dispose();
              
              _levelName = new Image(AssetRegistry.LevelSelectAtlas.getTexture("text-info-level" + String(level)));
              _levelName.x += 85;
              _levelName.y += 85;
              
              _levelInfo.addChild(_levelName);
              _levelInfo.x = (Starling.current.viewPort.width - _levelInfo.width) / 2;
              _levelInfo.y = (Starling.current.viewPort.height - _levelInfo.height) / 2;
              _levelInfo.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void
                {
                  var touch:Touch = event.getTouch(that, TouchPhase.ENDED);
                  if (touch)
                  {
                    if(touch.getLocation(_levelInfo).y < _levelInfo.height * 2 / 3) {
                      _showingInfo = false;
                      that.removeChild(_levelInfo);
                    } else {
                      StageManager.switchStage(Level1);
                    }
                  }
                });
              
              that.addChild(_levelInfo);
              
              _showingInfo = true;
            }
          }
          else
          {
            touch = event.getTouch(that, TouchPhase.BEGAN);
            if (touch)
            {
              _slideY = 0;
            }
          }
        }
      }
    }
    
    private function onTouch(event:TouchEvent):void
    {
      if (!_showingInfo)
      {
        var touch:Touch = event.getTouch(_scrollable, TouchPhase.MOVED);
        if (touch)
        {
          _slideY += Math.abs(touch.getMovement(_scrollable).y);
          _scrollable.y += touch.getMovement(_scrollable).y;
          _scrollable.y = Math.min(0, _scrollable.y);
          _scrollable.y = Math.max(-(_bg.height - Starling.current.viewPort.height), _scrollable.y);
        }
      }
    }
    
    override public function dispose():void {
      AssetRegistry.disposeLevelSelectGraphics();
      super.dispose();
    }
  
  }

}