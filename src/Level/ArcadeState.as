package Level
{
  import com.gskinner.motion.GTween;
  import com.gskinner.motion.plugins.SoundTransformPlugin;
  import Eggs.Egg;
  import Eggs.Eggs;
  import flash.geom.Rectangle;
  import flash.media.Sound;
  import fr.kouma.starling.utils.Stats;
  import Snake.Snake;
  import starling.animation.Tween;
  import starling.core.Starling;
  import starling.display.Image;
  import starling.display.Quad;
  import starling.display.Sprite;
  import starling.extensions.ParticleDesignerPS;
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
  import Combo.*;
  import flash.utils.*;
  import com.gskinner.motion.easing.Exponential
  import UI.Radar;
  import engine.SaveGame;
  
  /**
   * ...
   * @author
   */
  public class ArcadeState extends LevelState
  {
    public function ArcadeState() {
      AssetRegistry.loadGraphics([AssetRegistry.SNAKE, AssetRegistry.ARCADE]);
      _rottenEnabled = true;
      
      super();
      
      _comboSet.addCombo(new Combo.ExtraLifeCombo);
      _comboSet.addCombo(new Combo.NoRottenCombo);
      _comboSet.addCombo(new Combo.ShuffleCombo);
      _comboSet.addCombo(new Combo.GoldenCombo);
      _comboSet.addCombo(new Combo.ExtraTimeCombo);
      
      for (var i:int = 0; i < 3; i++) {
        if (SaveGame.specials[i]) {
          switch(SaveGame.specials[i].effect) {
            case "combo-xtraspawn":
                _comboSet.addCombo(new Combo.ExtraEggCombo(SaveGame.specials[i].combo));
                break;
            case "combo-leveluptime":
                _comboSet.addCombo(new Combo.ExtendExtraTimeCombo(SaveGame.specials[i].combo));
                break;
            case "combo-chaintime":
                _comboSet.addCombo(new Combo.ExtendChainTimeCombo(SaveGame.specials[i].combo));
                break;
          }
        }
      }
      
      _startPos.x = 20;
      _startPos.y = 20;
      startAt(_startPos.x, _startPos.y);
      AssetRegistry.soundmanager.playMusic("arcadeMusic");
      _levelNr = 9;
    }
    
    override protected function setBoundaries():void {
      _levelBoundaries = new Rectangle(13, 12, 43, 38);
    }
    
    override public function spawnRandomEgg():void {
      var egg:Eggs.Egg;
      var types:Array = [AssetRegistry.EGGA, AssetRegistry.EGGB, AssetRegistry.EGGC, AssetRegistry.EGGA, AssetRegistry.EGGB, AssetRegistry.EGGC];
      
      if (!SaveGame.noGreenArcade) {
        types.push(AssetRegistry.EGGZERO);
      }
      
      var type:int = types[Math.floor(Math.random() * types.length)];
      
      egg = new Egg(0, 0, type);
      
      placeEgg(egg);     
    }
    
    override public function dispose():void {
      super.dispose();
    }
    
    override public function addFrame():void {
      // Not needed here.
    }
    
    override protected function addObstacles():void {
      var pos:Array = [1506, 1507, 3055, 3056, 3057, 1771, 3090, 3091, 1044, 1045, 3049, 1309, 3052, 3053, 3283, 805, 806, 807, 808, 809, 810, 811, 812, 813, 814, 815, 816, 817, 818, 819, 821, 822, 823, 824, 825, 3122, 3123, 820, 1333, 1334, 1335, 1071, 3120, 1308, 1770, 1836, 1069, 1070, 1572, 1573, 2892, 2893, 846, 847, 3115, 3116, 1837, 3156, 3157, 1110, 1111, 3054, 1374, 1375, 3118, 3119, 3121, 871, 872, 873, 874, 875, 876, 877, 878, 879, 1136, 881, 3186, 3187, 3188, 3181, 1135, 880, 1137, 3051, 3189, 3182, 3183, 1638, 1639, 3117, 3184, 3050, 2958, 2959, 912, 913, 3222, 3223, 1176, 1177, 1440, 1441, 3185, 937, 938, 939, 3247, 1202, 1203, 3252, 3253, 3254, 3255, 3248, 1201, 1705, 3251, 3249, 1704, 3277, 3278, 3279, 3024, 3025, 978, 979, 3284, 3285, 3286, 3287, 3288, 3289, 1242, 1243, 3280, 1003, 1004, 1005, 1267, 1268, 1269, 3281, 3282, 3250];
      for (var i:int = 0; i < pos.length; i++) {
        _obstacles[pos[i]] = true;
      }
    }   
    
    override protected function checkWin():void {
      if (_timeLeft <= 0) {
        win();
      }
    }
    
    override protected function addHud():void {
      _hud = new HUD(new Radar(_eggs, _snake), ["lifes", "time", "combo", "poison"], this);
      addChild(_hud);
      _hud.poison.x = 108;
      _hud.poison.y = 70;
      _hud.poisonTextField.x = _hud.poison.x + _hud.poison.width + 12;  
    }    
    
    override protected function updateHud():void {
      _hud.radar.update(); 
      _hud.score = String(_score);
      _hud.lifesText = String(_snake.lives);
      _hud.timeText = String(_timeLeft.toFixed(2)); 
      _hud.poisonText = String(_poisonEggs);
      _hud.comboText = String(_combos);
    }

    override protected function checkLost():void {
      if (_poisonEggs > 4) {
        lose();
      }
      super.checkLost();
    }    
    
    override protected function addBackground():void
    {
      _bgTexture = AssetRegistry.ArcadeBackground;
      _bg = new Image(_bgTexture);
      _bg.blendMode = BlendMode.NONE;
      _levelStage.addChild(_bg);
      
      if (AssetRegistry.HQ)
      {
        // Add blinking overlay
        
        _overlay = new Image(AssetRegistry.ArcadeOverlayAtlas.getTexture("arcadeOverlay0x0"));
        _overlay.smoothing = TextureSmoothing.NONE;
        _overlay.blendMode = BlendMode.ADD;
        _levelStage.addChild(_overlay);
        new GTween(_overlay, 0.3, {"alpha": 0}, {ease: Exponential.easeOut, reflect: true, repeatCount: 0});
        
        _overlay = new Image(AssetRegistry.ArcadeOverlayAtlas.getTexture("arcadeOverlay240x0"));
        _overlay.x = 240;
        _overlay.smoothing = TextureSmoothing.NONE;
        _overlay.blendMode = BlendMode.ADD;
        
        _levelStage.addChild(_overlay);
        
        new GTween(_overlay, 0.3, {"alpha": 0}, {ease: Exponential.easeOut, reflect: true, repeatCount: 0});
      }
    }
  }

}
