package engine
{
  import flash.media.Sound;
  import flash.utils.ByteArray;
  import starling.text.BitmapFont;
  import starling.textures.Texture;
  import starling.textures.TextureAtlas;
  import starling.text.TextField;
  import Level.*;
  import engine.SoundManager;
  import flash.system.System;
  import Languages.*;
  
  /**
   * ...
   * @author
   */
  public class AssetRegistry
  {
    
    // Menu Graphics
    [Embed(source = "../../assets/Menus/MenuAlpha.png")]
    static private const MenuAlphaPNG:Class;
    [Embed(source = "../../assets/Menus/MenuAlpha.xml", mimeType = "application/octet-stream")]
    static private const MenuAlphaXML:Class;
    [Embed(source = "../../assets/Menus/MenuOpaque.atf", mimeType = "application/octet-stream")]
    static private const MenuOpaqueATF:Class;
    [Embed(source = "../../assets/Menus/MenuOpaque.xml", mimeType = "application/octet-stream")]
    static private const MenuOpaqueXML:Class;
    public static var MenuAtlasOpaque:TextureAtlas;
    public static var MenuAtlasAlpha:TextureAtlas;    
    
    // Level BG Graphics
    [Embed(source = "../../assets/Levels/ATF/Levels.atf", mimeType = "application/octet-stream")]
    static private const LevelAtlasATF:Class;
    [Embed(source = "../../assets/Levels/ATF/Levels.xml", mimeType = "application/octet-stream")]
    static private const LevelAtlasXML:Class;
    public static var LevelAtlas:TextureAtlas;
    
    // Level Frame
    [Embed(source = "../../assets/Levels/HalfFrame@1.png")]
    static private const HalfFramePNG:Class;
    public static var HalfFrameTexture:Texture;
    
    // UI Graphics
    [Embed(source = "../../assets/UI/UI.png")]
    static private const UIAtlasPNG:Class;
    [Embed(source = "../../assets/UI/UI.xml", mimeType = "application/octet-stream")]
    static private const UIAtlasXML:Class;
    public static var UIAtlas:TextureAtlas;
    
    // Scoring Graphics
    [Embed(source = "../../assets/Levels/Scoring/ScoringScalable.png")]
    static private const ScoringScalableAtlasPNG:Class;
    [Embed(source = "../../assets/Levels/Scoring/ScoringScalable.xml", mimeType = "application/octet-stream")]
    static private const ScoringScalableAtlasXML:Class;
    public static var ScoringScalableAtlas:TextureAtlas;
    
    // Level Selection Screen Graphics
    // .25 size
    [Embed(source = "../../assets/Levels/LevelSelect/LevelSelectAlpha.png")]
    static private const LevelSelectAtlasAlphaPNG:Class;
    [Embed(source = "../../assets/Levels/LevelSelect/LevelSelectAlpha.xml", mimeType = "application/octet-stream")]
    static private const LevelSelectAtlasAlphaXML:Class;
    [Embed(source="../../assets/Levels/LevelSelect/LevelSelectOpaque.atf", mimeType="application/octet-stream")]
    static private const LevelSelectAtlasOpaqueATF:Class;
    [Embed(source = "../../assets/Levels/LevelSelect/LevelSelectOpaque.xml", mimeType = "application/octet-stream")]
    static private const LevelSelectAtlasOpaqueXML:Class;
    public static var LevelSelectAtlasOpaque:TextureAtlas;
    public static var LevelSelectAtlasAlpha:TextureAtlas;
    
    [Embed(source="../../assets/Snake/Snake.png")]
    static private const SnakeTexturePNG:Class;
    [Embed(source = "../../assets/Snake/Snake.atf", mimeType = "application/octet-stream")]
    static private const SnakeTextureATF:Class;
    [Embed(source="../../assets/UI/UIOverlay.png")]
    static private const UIOverlayPNG:Class;
    [Embed(source="../../assets/Snake/Snake.xml",mimeType="application/octet-stream")]
    static private const SnakeAtlasXML:Class;
    [Embed(source="../../assets/Particles/drugs.pex",mimeType="application/octet-stream")]
    private static const DrugsParticleXML:Class;
    [Embed(source="../../assets/Particles/combo.pex",mimeType="application/octet-stream")]
    private static const ComboParticleXML:Class;
    [Embed(source = "../../assets/Levels/Arcade/Arcade.xml", mimeType = "application/octet-stream")]
    private static const ArcadeAtlasXML:Class;
    [Embed(source = "../../assets/Levels/Arcade/Arcade.atf", mimeType = "application/octet-stream")]
    private static const ArcadeAtlasATF:Class;
    [Embed(source="../../assets/Levels/Level04/level4atlas.xml",mimeType="application/octet-stream")]
    private static const Level4AtlasXML:Class;
    [Embed(source="../../assets/Levels/Level04/level4atlas.png")]
    private static const Level4AtlasPNG:Class;
    [Embed(source="../../assets/Levels/Level06/Level6Atlas.xml",mimeType="application/octet-stream")]
    private static const Level6AtlasXML:Class;
    [Embed(source="../../assets/Levels/Level06/Level6Atlas.png")]
    private static const Level6AtlasPNG:Class;
    [Embed(source="../../assets/Levels/Level07/Level7Atlas.xml",mimeType="application/octet-stream")]
    private static const Level7AtlasXML:Class;
    [Embed(source="../../assets/Levels/Level07/Level7Atlas.png")]
    private static const Level7AtlasPNG:Class;
    [Embed(source="../../assets/Particles/drugs_particle.png")]
    private static const DrugsParticlePNG:Class;
    [Embed(source="../../assets/Particles/EggsplosionB.pex",mimeType="application/octet-stream")]
    private static const EggsplosionXML:Class;
    [Embed(source="../../assets/Particles/EggsplosionB.png")]
    private static const EggsplosionPNG:Class;
    
    [Embed(source="../../assets/Levels/arcade.png")]
    private static const ArcadeBackgroundPNG:Class;
    [Embed(source="../../assets/Font/8bit.fnt",mimeType="application/octet-stream")]
    static private const FontXML:Class;
    [Embed(source="../../assets/Font/8bit_0.png")]
    static private const FontPNG:Class;
    [Embed(source="../../assets/Loading/loading.png")]
    static public const LoadingPNG:Class;
    [Embed(source="../../assets/Levels/arcadeOverlay.png")]
    static public const ArcadeOverlayPNG:Class;
    
    [Embed(source="../../assets/Levels/Level01/level01bg.png")]
    static public const Level1BackgroundPNG:Class;
    [Embed(source="../../assets/Levels/Level02/level02bg.png")]
    static public const Level2BackgroundPNG:Class;
    //[Embed(source = "../../assets/Levels/Level02/level02bg.atf", mimeType = "application/octet-stream")] static public const Level2BackgroundATF:Class;
    [Embed(source="../../assets/Levels/Level03/level03.png")]
    static public const Level3BackgroundPNG:Class;
    [Embed(source="../../assets/Levels/Level03/level03_stein.png")]
    static public const Level3StonePNG:Class;
    [Embed(source="../../assets/Levels/Level03/SteinAugenGlühen.png")]
    static public const Level3StoneGlowPNG:Class;
    [Embed(source="../../assets/Levels/Level04/Level4mitRahmen.png")]
    static public const Level4BackgroundPNG:Class;
    [Embed(source="../../assets/Levels/Level04/level4_palme.png")]
    static public const Level4PalmTreePNG:Class;
    [Embed(source="../../assets/Levels/Level05/level05.png")]
    static public const Level5BackgroundPNG:Class;
    [Embed(source="../../assets/Levels/Level06/level06.png")]
    static public const Level6BackgroundPNG:Class;
    [Embed(source="../../assets/Loading/loading-screen.png")]
    static public const LoadingScreenPNG:Class;
    
    [Embed(source="../../assets/Sounds/Biss3.mp3")]
    static public const Bite:Class;
    
    [Embed(source="../../assets/Levels/arcadeoverlaytexture.xml",mimeType="application/octet-stream")]
    static private const ArcadeOverlayAtlasXML:Class
    [Embed(source="../../assets/Levels/arcadeoverlaytexture.png")]
    static private const ArcadeOverlayAtlasPNG:Class;
    
    [Embed(source="../../assets/Levels/Scoring/Scoring.xml",mimeType="application/octet-stream")]
    static private const ScoringXML:Class;
    [Embed(source="../../assets/Levels/Scoring/Scoring.png")]
    static private const ScoringPNG:Class;
    

    //[Embed(source = "../../assets/Levels/LevelSelect/LevelSelect.atf", mimeType = "application/octet-stream")] static private const LevelSelectATF:Class;
    //[Embed(source="../../assets/Levels/LevelSelect/background.png")]
   // static private const LevelSelectBGPNG:Class;
   // [Embed(source="../../assets/Levels/LevelSelect/tile-boss-locked.png")]
   // static private const LevelSelectBossLockedPNG:Class;
    
    [Embed(source="../../assets/Music/LevelMusikStufe1.mp3")]
    static private const LevelMusic1:Class;
    [Embed(source="../../assets/Music/LevelMusikStufe2.mp3")]
    static private const LevelMusic2:Class;
    [Embed(source="../../assets/Music/LevelMusikStufe3.mp3")]
    static private const LevelMusic3:Class;
    [Embed(source="../../assets/Music/LevelMusikStufe4.mp3")]
    static private const LevelMusic4:Class;    
    [Embed(source="../../assets/Music/eile_arcade1.mp3")]
    static public const ArcadeMusic:Class;
    [Embed(source = "../../assets/Music/snake_remix.mp3")]
    static public const ArcadeEndlessMusic:Class;
   
    // Sounds
    [Embed(source = "../../assets/Sounds/Combo/SchwanzEffekt1.mp3")]
    static private const ComboSound0:Class;
    [Embed(source = "../../assets/Sounds/Combo/SchwanzEffekt2.mp3")]
    static private const ComboSound1:Class;
    [Embed(source = "../../assets/Sounds/Combo/SchwanzEffekt3.mp3")]
    static private const ComboSound2:Class;
    [Embed(source = "../../assets/Sounds/Combo/SchwanzEffekt4.mp3")]
    static private const ComboSound3:Class;
    [Embed(source = "../../assets/Sounds/Combo/SchwanzEffekt5.mp3")]
    static private const ComboSound4:Class;
    [Embed(source = "../../assets/Sounds/Combo/SchwanzEffekt6.mp3")]
    static private const ComboSound5:Class;
    [Embed(source = "../../assets/Sounds/Combo/SchwanzEffekt7.mp3")]
    static private const ComboSound6:Class;
    [Embed(source = "../../assets/Sounds/Combo/SchwanzEffekt8.mp3")]
    static private const ComboSound7:Class;
    
    // Particles
    [Embed(source="../../assets/Particles/EggsplosionA.pex",mimeType="application/octet-stream")]
    static public const EggsplosionA:Class;
    [Embed(source="../../assets/Particles/EggsplosionB.pex",mimeType="application/octet-stream")]
    static public const EggsplosionB:Class;
    [Embed(source="../../assets/Particles/EggsplosionC.pex",mimeType="application/octet-stream")]
    static public const EggsplosionC:Class;
    [Embed(source="../../assets/Particles/EggsplosionGoldV2.pex",mimeType="application/octet-stream")]
    static public const EggsplosionGold:Class;
    [Embed(source="../../assets/Particles/EggsplosionRotten.pex",mimeType="application/octet-stream")]
    static public const EggsplosionRotten:Class;
    [Embed(source="../../assets/Particles/EggsplosionShuffle.pex",mimeType="application/octet-stream")]
    static public const EggsplosionShuffle:Class;
    [Embed(source="../../assets/Particles/EggsplosionGreen.pex",mimeType="application/octet-stream")]
    static public const EggsplosionGreen:Class;
    [Embed(source="../../assets/Particles/EggsplosionRottenLV1and2.pex",mimeType="application/octet-stream")]
    static public const EggsplosionRottenLV1:Class;
    [Embed(source = "../../assets/Particles/Taileggsplosion1.pex", mimeType = "application/octet-stream")]
    static public const Taileggsplosion0:Class;
    [Embed(source = "../../assets/Particles/Taileggsplosion2.pex", mimeType = "application/octet-stream")]
    static public const Taileggsplosion1:Class;
    [Embed(source = "../../assets/Particles/Taileggsplosion3.pex", mimeType = "application/octet-stream")]
    static public const Taileggsplosion2:Class;
    [Embed(source = "../../assets/Particles/Taileggsplosion4.pex", mimeType = "application/octet-stream")]
    static public const Taileggsplosion3:Class;
    [Embed(source = "../../assets/Particles/Taileggsplosion5.pex", mimeType = "application/octet-stream")]
    static public const Taileggsplosion4:Class;
     [Embed(source="../../assets/Particles/ExtraLife.pex",mimeType="application/octet-stream")]
    static public const ExtraLife:Class;
    [Embed(source="../../assets/Particles/BonusTime.pex",mimeType="application/octet-stream")]
    static public const BonusTime:Class;
    [Embed(source="../../assets/Particles/ChainTimePlus.pex",mimeType="application/octet-stream")]
    static public const ChainTimePlus:Class;
    [Embed(source="../../assets/Particles/ExtraEggs.pex",mimeType="application/octet-stream")]
    static public const ExtraEggs:Class;
    
    public static var SnakeAtlas:TextureAtlas;
    public static var ArcadeOverlayAtlas:TextureAtlas;
    public static var LevelSelectAtlas:TextureAtlas;
    public static var ScoringAtlas:TextureAtlas;
    public static var Level4Atlas:TextureAtlas;
    public static var Level6Atlas:TextureAtlas;
    public static var Level7Atlas:TextureAtlas;
    
    public static var UIOverlayTexture:Texture;
    //public static var LevelSelectBGTexture:Texture;
    //public static var LevelSelectBossLocked:Texture;
    public static var ComboParticleConfig:XML;
    public static var DrugParticleConfig:XML;
    public static var DrugParticleTexture:Texture;
    public static var EggsplosionParticleConfig:XML;
    public static var EggsplosionParticleTexture:Texture;
    public static var ArcadeBackground:Texture;
    public static var ArcadeAtlas:TextureAtlas;
    public static var ArcadeOverlay:Texture;
    
    public static var Level1Background:Texture;
    public static var Level2Background:Texture;
    public static var Level3Background:Texture;
    public static var Level3Stone:Texture;
    public static var Level3StoneGlow:Texture;
    public static var Level4Background:Texture;
    public static var Level5Background:Texture;
    public static var Level6Background:Texture;
    public static var Level7Background:Texture;
    public static var Level8Background:Texture;
    public static var LevelFrame:Texture;
    
    public static var WinMusicSound:Sound;
    public static var BiteSound:Sound;
    
    public static var LevelMusic1Sound:Sound;
    public static var LevelMusic2Sound:Sound;
    public static var LevelMusic3Sound:Sound;
    public static var LevelMusic4Sound:Sound;
   
    public static const TILESIZE:int = 15;
    
    public static const DOWN:int = 0;
    public static const UP:int = 1;
    public static const LEFT:int = 2;
    public static const RIGHT:int = 3;
    
    public static const EGGNONE:int = -1;
    public static const EGGZERO:int = 0;
    public static const EGGA:int = 1;
    public static const EGGB:int = 2;
    public static const EGGC:int = 3;
    public static const EGGROTTEN:int = 4;
    public static const EGGSHUFFLE:int = 5;
    public static const EGGGOLDEN:int = 6;
    
    public static var HQ:Boolean = false;
    public static var LEVELS:Array;
    
    public static const STAGE_WIDTH:int = 960;
    public static const STAGE_HEIGHT:int = 640;
    
    public static const ASPECT_RATIO:Number = STAGE_HEIGHT / STAGE_WIDTH;
    public static var SCALE:Number = 0;
    
    public static var soundmanager:SoundManager;
    
    public static var loaded:Array = [];

    public static const MENU:String = "Menu";
    public static const SNAKE:String = "Snake";
    public static const ARCADE:String = "Arcade";
    public static const SCORING:String = "Scoring";
    public static const LEVELSELECT:String = "LevelSelect";
    
    public static const LEVEL1:String = "Level 1";
    public static const LEVEL2:String = "Level 2";
    public static const LEVEL3:String = "Level 3";
    public static const LEVEL4:String = "Level 4";
    public static const LEVEL5:String = "Level 5";
    public static const LEVEL6:String = "Level 6";
    public static const LEVEL7:String = "Level 7";
    public static const LEVEL8:String = "Level 8";
    
    public static const COMBO_TRIGGERS:Array = ["acba", "ccbba", "bcaac", "abbca", "abcb", "bccb"];
    
    public static var Strings:Class;
    
    // Stuff for Scoreoid.
    
    public static const GAME_ID:String = "atZTbG24V";
    public static const API_KEY:String = "7bb1d7f5ac027ae81b6c42649fddc490b3eef755";
    
    public static function init():void
    {
      LEVELS = [Level1, Level2, Level3, Level4, Level5, Level6,null, null, ArcadeState];
      TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmap(new FontPNG), XML(new FontXML)));      
      
      LevelMusic1Sound = new LevelMusic1;
      LevelMusic2Sound = new LevelMusic2;
      LevelMusic3Sound = new LevelMusic3;
      LevelMusic4Sound = new LevelMusic4;
      
      soundmanager = new SoundManager();
      soundmanager.musicMuted = SaveGame.musicMuted;
      soundmanager.SFXMuted = SaveGame.SFXMuted;
      
	  
	    Strings = English;
      
      registerSounds();
      registerMusic();
      
    }
    
    public static function loadGraphics(needed:Array, keep:Boolean = false):void {
      var i:int;
      
      var assets:Object = {
        (String(MENU)): { load: loadMenuGraphics, dispose: disposeMenuGraphics },
        (String(LEVELSELECT)): { load: loadLevelSelectGraphics, dispose: disposeLevelSelectGraphics },
        (String(SNAKE)): { load: loadLevelGraphics, dispose: disposeLevelGraphics },
        (String(LEVEL1)): { load: loadLevel1Graphics, dispose: disposeLevel1Graphics },
        (String(LEVEL2)): { load: loadLevel2Graphics, dispose: disposeLevel2Graphics },
        (String(LEVEL3)): { load: loadLevel3Graphics, dispose: disposeLevel3Graphics },
        (String(LEVEL4)): { load: loadLevel4Graphics, dispose: disposeLevel4Graphics },
        (String(LEVEL5)): { load: loadLevel5Graphics, dispose: disposeLevel5Graphics },
        (String(LEVEL6)): { load: loadLevel6Graphics, dispose: disposeLevel6Graphics },
        (String(LEVEL7)): { load: loadLevel7Graphics, dispose: disposeLevel7Graphics },
        (String(ARCADE)): { load: loadArcadeGraphics, dispose: disposeArcadeGraphics },

        (String(SCORING)): { load: loadScoringGraphics, dispose: disposeScoringGraphics}
      };
      
      var toUnload:Array = [];
      
      // Throw out stuff we already have and mark things to unload.
      for (i = 0; i < loaded.length; i++) {
        if (needed.indexOf(loaded[i]) != -1) {
          needed.splice(needed.indexOf(loaded[i]), 1);
        } else {
          toUnload.push(loaded[i]);
        }
      }
      
      // Unload what we don't need. Don't unload if keep is true.
      if(!keep) {
        for (i = 0; i < toUnload.length; i++) {
          assets[toUnload[i]].dispose();
          trace("Unloading " + toUnload[i]);
          loaded.splice(loaded.indexOf(toUnload[i]), 1);
        }
      }
      
      // Run GC
      
      System.gc();
      System.gc();
      trace(needed);
      trace(loaded);
      
      // Load what we still need
      for (i = 0; i < needed.length; i++) {
        assets[needed[i]].load();
        trace("Loading " + needed[i]);
        loaded.push(needed[i]);
      }
  
    }
    
    public static function registerSounds():void {
      soundmanager.registerSound("comboSound0", new ComboSound0);
      soundmanager.registerSound("comboSound1", new ComboSound1);
      soundmanager.registerSound("comboSound2", new ComboSound2);
      soundmanager.registerSound("comboSound3", new ComboSound3);
      soundmanager.registerSound("comboSound4", new ComboSound4);
      soundmanager.registerSound("comboSound5", new ComboSound5);
      soundmanager.registerSound("comboSound6", new ComboSound6);
      soundmanager.registerSound("comboSound7", new ComboSound7);
      soundmanager.registerSound("bite", new Bite());
    }
    
    public static function registerMusic():void {
      soundmanager.registerSound("arcadeMusic", new ArcadeMusic);
      soundmanager.registerSound("arcadeEndlessMusic", new ArcadeEndlessMusic);
    }
    
    public static function loadArcadeGraphics():void
    {
      //UIOverlayTexture = Texture.fromBitmap(new UIOverlayPNG);
      //ArcadeAtlas = new TextureAtlas(Texture.fromAtfData(new ArcadeAtlasATF), XML(new ArcadeAtlasXML));
      //ArcadeBackground = ArcadeAtlas.getTexture("arcade");
      //ArcadeOverlayAtlas = new TextureAtlas(Texture.fromBitmap(new ArcadeOverlayAtlasPNG), XML(new ArcadeOverlayAtlasXML));
      
    }
    
    public static function loadMenuGraphics():void
    {
      MenuAtlasAlpha = new TextureAtlas(Texture.fromBitmap(new MenuAlphaPNG), XML(new MenuAlphaXML));
      MenuAtlasOpaque = new TextureAtlas(Texture.fromAtfData(new MenuOpaqueATF), XML(new MenuOpaqueXML));
    }
    
    public static function disposeMenuGraphics():void
    {
      MenuAtlasAlpha.dispose();
      MenuAtlasAlpha = null;
      MenuAtlasOpaque.dispose();
      MenuAtlasOpaque = null;
    }
    
    public static function loadScoringGraphics():void
    {
      ScoringAtlas = new TextureAtlas(Texture.fromBitmap(new ScoringPNG), XML(new ScoringXML));
      ScoringScalableAtlas = new TextureAtlas(Texture.fromBitmap(new ScoringScalableAtlasPNG, true, false, 0.42), XML(new ScoringScalableAtlasXML));
    }
    
    public static function disposeScoringGraphics():void
    {
      ScoringAtlas.dispose();
      ScoringAtlas = null;
      ScoringScalableAtlas.dispose();
      ScoringScalableAtlas = null;
    }
    
    public static function disposeArcadeGraphics():void
    {
      //UIOverlayTexture.dispose();
      //ArcadeBackground.dispose();
      //ArcadeOverlayAtlas.dispose();
    }
    
    public static function loadLevel1Graphics():void
    {
      //Level1Background = Texture.fromBitmap(new Level1BackgroundPNG);
    }
    
    public static function disposeLevel1Graphics():void
    {
      //Level1Background.dispose();
    }
    
    public static function loadLevel2Graphics():void
    {
      //Level2Background = Texture.fromBitmap(new Level2BackgroundPNG);
    }
    
    public static function disposeLevel2Graphics():void
    {
      //Level2Background.dispose();
    }
    
    public static function loadLevel3Graphics():void
    {
      //Level3Background = Texture.fromBitmap(new Level3BackgroundPNG);
      Level3Stone = Texture.fromBitmap(new Level3StonePNG);
      Level3StoneGlow = Texture.fromBitmap(new Level3StoneGlowPNG);
    }
    
    public static function disposeLevel3Graphics():void
    {
      //Level3Background.dispose();
      Level3Stone.dispose();
      Level3StoneGlow.dispose();
    }
    
    public static function loadLevel4Graphics():void
    {
      //Level4Background = Texture.fromBitmap(new Level4BackgroundPNG);
      Level4Atlas = new TextureAtlas(Texture.fromBitmap(new Level4AtlasPNG), XML(new Level4AtlasXML));
    }
    
    public static function disposeLevel4Graphics():void
    {
      //Level4Background.dispose();
      Level4Atlas.dispose();
    }
    
    public static function loadLevel5Graphics():void
    {
    }
    
    public static function disposeLevel5Graphics():void
    {
    }
    
    public static function loadLevel6Graphics():void
    {
      //Level6Background = Texture.fromBitmap(new Level6BackgroundPNG);
      Level6Atlas = new TextureAtlas(Texture.fromBitmap(new Level6AtlasPNG), XML(new Level6AtlasXML));
    }
    
    public static function disposeLevel6Graphics():void
    {
      //Level6Background.dispose();
      Level6Atlas.dispose();
    }
    
    public static function loadLevelGraphics():void
    {
      SnakeAtlas = new TextureAtlas(Texture.fromBitmap(new SnakeTexturePNG), XML(new SnakeAtlasXML));
      LevelAtlas = new TextureAtlas(Texture.fromAtfData(new LevelAtlasATF), XML(new LevelAtlasXML));
      UIAtlas = new TextureAtlas(Texture.fromBitmap(new UIAtlasPNG, true, false, 0.4), XML(new UIAtlasXML));
      HalfFrameTexture = Texture.fromBitmap(new HalfFramePNG);//,true,false,0.5);
      
      DrugParticleConfig = XML(new DrugsParticleXML);
      DrugParticleTexture = Texture.fromBitmap(new DrugsParticlePNG);
      ComboParticleConfig = XML(new ComboParticleXML);
      
      EggsplosionParticleConfig = XML(new EggsplosionXML);
      EggsplosionParticleTexture = Texture.fromBitmap(new EggsplosionPNG);
      
//        WinMusicSound = new WinMusic as Sound;   
    }
    
    public static function disposeLevelGraphics():void
    {
      SnakeAtlas.dispose();
      LevelAtlas.dispose();
      UIAtlas.dispose();
      HalfFrameTexture.dispose();
      
      System.disposeXML(DrugParticleConfig)
      DrugParticleTexture.dispose();
      
      System.disposeXML(ComboParticleConfig);
      
      System.disposeXML(EggsplosionParticleConfig);
      EggsplosionParticleTexture.dispose();
    
      //WinMusicSound = null;        
    }
    
    public static function loadLevel7Graphics():void
    {
      //Level6Background = Texture.fromBitmap(new Level6BackgroundPNG);
      Level7Atlas = new TextureAtlas(Texture.fromBitmap(new Level7AtlasPNG), XML(new Level7AtlasXML));
    }
    
    public static function disposeLevel7Graphics():void
    {
      //Level6Background.dispose();
      Level7Atlas.dispose();
    }
    
    public static function loadLevelSelectGraphics():void
    {
      LevelSelectAtlasOpaque = new TextureAtlas(Texture.fromAtfData(new LevelSelectAtlasOpaqueATF), XML(new LevelSelectAtlasOpaqueXML));
      LevelSelectAtlasAlpha = new TextureAtlas(Texture.fromBitmap(new LevelSelectAtlasAlphaPNG, true, false, 0.25), XML(new LevelSelectAtlasAlphaXML));
      
    }
    
    public static function disposeLevelSelectGraphics():void
    {
      LevelSelectAtlasOpaque.dispose();
      LevelSelectAtlasOpaque = null;
      LevelSelectAtlasAlpha.dispose();
      LevelSelectAtlasAlpha = null;
    }
  
  }

}
