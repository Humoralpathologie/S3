package Menu
{
  import engine.ManagedStage;
  import flash.geom.Point;
  import org.josht.starling.foxhole.controls.ScrollContainer;
  import org.josht.starling.foxhole.controls.Scroller;
  //import org.josht.starling.foxhole.controls.Button;
  //import starling.display.Button;
  import starling.display.DisplayObject;
  import starling.display.Image;
  import starling.display.Quad;
  import starling.display.Sprite;
  import engine.AssetRegistry;
  import starling.events.Event;
  import starling.events.Touch;
  import starling.events.TouchEvent;
  import starling.events.TouchPhase;
  import starling.core.Starling;
  import engine.StageManager;
  import Level.*;
  import engine.SaveGame;
  import starling.textures.TextureSmoothing;
  import engine.Utils;
  import engine.VideoPlayer;
  
  /**
   * ...
   * @author
   */
  public class LevelSelect extends ManagedStage
  {
    private var _levelSelectTop:Image;
    private var _levelSelectBottom:Image;
    private var _scroller:Scroller;
    private var _scrollable:Sprite;
    private var _locks:Vector.<Image>;
    private var _boxes:Object;
    private var _tempPoint:Point;
    
   
    
    private static const _lockedPositions:Array = [[15, 262], [261, 377], [514, 509], [261, 626], [11, 743], [261, 881]];
    
    public function LevelSelect()
    {
      
      AssetRegistry.loadGraphics([AssetRegistry.LEVELSELECT, AssetRegistry.SCORING]);
      _scroller = new Scroller();
      _scrollable = new Sprite();
      
      _levelSelectTop = new Image(AssetRegistry.Opaque_1_Part1_Atlas.getTexture("levelauswahl_oben"));
      _levelSelectTop.smoothing = TextureSmoothing.NONE;
      _scrollable.addChild(_levelSelectTop);
      
      if (SaveGame.levelUnlocked(7))
      {
        _levelSelectBottom = new Image(AssetRegistry.Opaque_1_Part1_Atlas.getTexture("levelauswahl_unten_1126"));
      }
      else
      {
        _levelSelectBottom = new Image(AssetRegistry.Opaque_1_Part1_Atlas.getTexture("levelauswahl_unten_1126_locked"));
      }
      _levelSelectBottom.y = _levelSelectTop.height - 1;
      _levelSelectBottom.smoothing = TextureSmoothing.NONE;
      _scrollable.addChild(_levelSelectBottom);
      
      
      addLocks();
      addMedals();
      addHitBoxes();
      
      _scrollable.flatten();
      
      _scroller.hasElasticEdges = false;
      _scroller.viewPort = _scrollable;
      _scroller.setSize(960, 640);
      
      _scrollable.addEventListener(TouchEvent.TOUCH, onTouch);
      
      addChild(_scroller);
      
      SaveGame.isArcade = false;
    }
    
    private function onTouch(e:TouchEvent):void
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
          trace(p);
          
          for each (var obj:Object in _boxes)
          {
            if (Utils.polygonHitTest(p, obj.box))
            {
              obj.callback();
            }
          }
        }
      }
    }
    
    private function addMedals():void
    {
      var medalPos:Array = [[313, 335], [556, 460], [821, 593], [557, 722], [312, 845], [557, 979], [312, 1175]];
      for (var i:int; i < medalPos.length; i++)
      {
        trace(AssetRegistry.MEDALS[SaveGame.medals[i]])
        if (AssetRegistry.MEDALS[SaveGame.medals[i]])
        {
          var medal:Image = new Image(AssetRegistry.Alpha_1_Atlas.getTexture(AssetRegistry.MEDALS[SaveGame.medals[i]]));
          medal.x = medalPos[i][0];
          medal.y = medalPos[i][1];
          _scrollable.addChild(medal);
        }
      }
    }
    
    private function addHitBoxes():void
    {
      _boxes = {};
      var box:Array = [new Point(18, 368), new Point(282, 261), new Point(442, 369), new Point(233, 473)];
      
      _boxes["level1"] = {box: box, callback: function():void
        {
          if (SaveGame.firstStart)
          {
            dispatchEventWith(SWITCHING, true, {stage: VideoPlayer, args: {stage: Level1, videoURI: "IntroLv1.mp4"}});
            SaveGame.firstStart = false;
          }
          else
          {
            dispatchEventWith(SWITCHING, true, {stage: Level1});
          }
        }};
      
      box = [new Point(265, 492), new Point(479, 385), new Point(691, 491), new Point(478, 599)];
      _boxes["level2"] = {box: box, callback: function():void
        {
          if (SaveGame.levelUnlocked(2))
          {
            dispatchEventWith(SWITCHING, true, {stage: Level2});
          }
        }};
      
      box = [new Point(517, 616), new Point(729, 512), new Point(942, 616), new Point(731, 726)];
      _boxes["level3"] = {box: box, callback: function():void
        {
          if (SaveGame.levelUnlocked(3))
          {
            dispatchEventWith(SWITCHING, true, {stage: Level3});
          }
        
        }};
      
      box = [new Point(266, 742), new Point(472, 639), new Point(688, 742), new Point(480, 848)];
      _boxes["level4"] = {box: box, callback: function():void
        {
          if (SaveGame.levelUnlocked(4))
          {
            dispatchEventWith(SWITCHING, true, {stage: Level4});
          }
        }};
      
      box = [new Point(15, 871), new Point(226, 764), new Point(439, 871), new Point(226, 976)];
      _boxes["level5"] = {box: box, callback: function():void
        {
          if (SaveGame.levelUnlocked(5))
          {
            dispatchEventWith(SWITCHING, true, {stage: Level5});
          }
        }};
      
      box = [new Point(265, 997), new Point(477, 980), new Point(689, 997), new Point(477, 1104)];
      _boxes["level6"] = {box: box, callback: function():void
        {
          if (SaveGame.levelUnlocked(6))
          {
            dispatchEventWith(SWITCHING, true, {stage: Level6});
          }
        }};
      
      box = [new Point(250, 1160), new Point(680, 1160), new Point(680, 2000), new Point(250, 2000)];
      _boxes["level7"] = {box: box, callback: function():void
        {
          if (SaveGame.levelUnlocked(7))
          {
            dispatchEventWith(SWITCHING, true, {stage: Level7});
          }
        }};
      
      box = [new Point(718, 286), new Point(893, 212), new Point(887, 306), new Point(729, 306)];
      _boxes["backtomenu"] = {box: box, callback: function():void
        {
          dispatchEventWith(SWITCHING, true, {stage: MainMenu})
        }};
    
    }
    
    private function addLocks():void
    {
      
      _locks = new Vector.<Image>;
      var lock:Image;
      var x:int;
      var y:int;
      var textureName:String;
      
      for (var i:int = 2; i < 7; i++)
      {
        if (!SaveGame.levelUnlocked(i))
        {
          x = _lockedPositions[i - 1][0];
          y = _lockedPositions[i - 1][1];
          textureName = "tile-level" + String(i) + "_" + String(x) + "-" + String(y);
          lock = new Image(AssetRegistry.Alpha_025_Atlas.getTexture(textureName));
          lock.x = x;
          lock.y = y;
          _scrollable.addChild(lock);
        }
      }
    }
    
    override public function dispose():void
    {
      _scrollable.removeEventListeners(TouchEvent.TOUCH);
      _scrollable.dispose();
      _levelSelectBottom.dispose();
      _levelSelectTop.dispose();
      _scroller.dispose();
      for (var i:int = 0; i < _locks.length; i++)
      {
        _locks[i].dispose();
      }
      _locks = null;
      super.dispose();
    
    }
  
  }

}
