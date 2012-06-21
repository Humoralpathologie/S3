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
  import engine.SaveGame;
  
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
    private static const _lockedPositions:Array = [
      [15, 262],
      [261, 382],
      [514, 512],
      [261, 638],
      [11, 764],
      [261, 893],
      [514, 1018],
      [54, 1190]
    ];
    
    private static const _unlockedPositions:Array = [
      [15, 262],
      [261, 377],
      [514, 509],
      [261, 626],
      [11, 743],
      [261, 890],
      [515, 1009],
      [54, 1190]      
    ];
    
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
      //_scrollable.addChild(_bg);
      
      var bgTop:Image = new Image(AssetRegistry.LevelSelectBGTexture);
      _scrollable.addChild(bgTop);
      
      var bgBottom:Image = new Image(AssetRegistry.LevelSelectBGTexture);
      bgBottom.y = bgTop.height * 2;
      bgBottom.scaleY = -1;
      
      _scrollable.addChild(bgBottom);
      
      var header:Image = new Image(AssetRegistry.LevelSelectAtlas.getTexture("header_15-20"));
      header.x = 15;
      header.y = 20;
      _scrollable.addChild(header);
      
      for (var i:int = 0; i < 8; i++) {
        var textureStr:String;
        var level:Image;
        if(SaveGame.levelUnlocked(i + 1)) {
          textureStr = "tile-level" + String(i + 1) + "_" + String(_unlockedPositions[i][0]) + "-" + String(_unlockedPositions[i][1]);
          level = new Image(AssetRegistry.LevelSelectAtlas.getTexture(textureStr));
          level.x = _unlockedPositions[i][0];
          level.y = _unlockedPositions[i][1];
          level.addEventListener(TouchEvent.TOUCH, showLevelInfo(i + 1));
        } else {
          if (i == 7) {
            level = new Image(AssetRegistry.LevelSelectBossLocked);
          } else {
            level = new Image(AssetRegistry.LevelSelectAtlas.getTexture("tile-level-locked"));
          }
          level.x = _lockedPositions[i][0];
          level.y = _lockedPositions[i][1];
        }
        _scrollable.addChild(level);
      }
            
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
              _levelInfo.x = (Starling.current.stage.stageWidth - _levelInfo.width) / 2;
              _levelInfo.y = (Starling.current.stage.stageHeight - _levelInfo.height) / 2;
              _levelInfo.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void
                {
                  var touch:Touch = event.getTouch(that, TouchPhase.ENDED);
                  if (touch)
                  {
                    if(touch.getLocation(_levelInfo).y < _levelInfo.height * 2 / 3) {
                      _showingInfo = false;
                      that.removeChild(_levelInfo);
                    } else {
                      StageManager.switchStage(AssetRegistry.LEVELS[level - 1]);
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
          _scrollable.y = Math.max(-(_bg.height - Starling.current.stage.stageHeight), _scrollable.y);
        }
      }
    }
    

    
    override public function dispose():void {
      AssetRegistry.disposeLevelSelectGraphics();
      super.dispose();
    }
  
  }

}