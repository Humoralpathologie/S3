package Level 
{
  import com.gskinner.motion.GTween;
  import Eggs.Egg;
  import Eggs.Eggs;
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
  
	
	/**
     * ...
     * @author 
     */
  public class ArcadeState extends LevelState 
    {  
    override protected function addBackground():void {
      _bgTexture = AssetRegistry.ArcadeBackground;
      _bg = new Image(_bgTexture);
      _bg.blendMode = BlendMode.NONE;
      _levelStage.addChild(_bg);
      
        if (AssetRegistry.HQ) {
          // Add blinking overlay

          _overlay = new Image(AssetRegistry.ArcadeOverlayAtlas.getTexture("arcadeOverlay0x0"));
          _overlay.smoothing = TextureSmoothing.NONE;
          _overlay.blendMode = BlendMode.ADD;
          _levelStage.addChild(_overlay);   
          new GTween(_overlay, 0.3, { "alpha": 0 }, { ease: Exponential.easeOut, reflect:true, repeatCount:0 } );          
          
          
          _overlay = new Image(AssetRegistry.ArcadeOverlayAtlas.getTexture("arcadeOverlay240x0"));
          _overlay.x = 240;
          _overlay.smoothing = TextureSmoothing.NONE;
          _overlay.blendMode = BlendMode.ADD;
          
          _levelStage.addChild(_overlay);
        
          new GTween(_overlay, 0.3, { "alpha": 0 }, { ease: Exponential.easeOut, reflect:true, repeatCount:0 } );          
        } 
    }      
  }
    
}