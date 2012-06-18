package engine 
{
    import flash.media.Sound;
    import starling.text.BitmapFont;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    import starling.text.TextField;
    import Level.*;
	/**
     * ...
     * @author 
     */
    public class AssetRegistry 
    {
      [Embed(source = "../../assets/Snake/Snake.png")] static private const SnakeTexturePNG:Class;
      [Embed(source = "../../assets/UI/UIOverlay.png")] static private const UIOverlayPNG:Class;
      [Embed(source = "../../assets/Snake/Snake.xml", mimeType="application/octet-stream")] static private const SnakeAtlasXML:Class;
      [Embed(source = "../../assets/Particles/drugs.pex", mimeType = "application/octet-stream")] private static const DrugsParticleXML:Class;
      [Embed(source = "../../assets/Particles/combo.pex", mimeType = "application/octet-stream")] private static const ComboParticleXML:Class;
      [Embed(source = "../../assets/Levels/Level04/level4atlas.xml", mimeType = "application/octet-stream")] private static const Level4AtlasXML:Class;
      [Embed(source = "../../assets/Levels/Level04/level4atlas.png")] private static const Level4AtlasPNG:Class;
      [Embed(source = "../../assets/Levels/Level06/Level6Atlas.xml", mimeType = "application/octet-stream")] private static const Level6AtlasXML:Class;
      [Embed(source = "../../assets/Levels/Level06/Level6Atlas.png")] private static const Level6AtlasPNG:Class;
      [Embed(source = "../../assets/Levels/Level07/Level7Atlas.xml",  mimeType = "application/octet-stream")] private static const Level7AtlasXML:Class;
      [Embed(source = "../../assets/Levels/Level07/Level7Atlas.png")] private static const Level7AtlasPNG:Class;
      [Embed(source = "../../assets/Particles/drugs_particle.png")] private static const DrugsParticlePNG:Class;
      [Embed(source = "../../assets/Particles/EggsplosionB.pex", mimeType = "application/octet-stream")] private static const EggsplosionXML:Class;
      [Embed(source = "../../assets/Particles/EggsplosionB.png")] private static const EggsplosionPNG:Class;
      
      [Embed(source = "../../assets/Levels/arcade.png")] private static const ArcadeBackgroundPNG:Class;
      [Embed(source = "../../assets/Font/8bit.fnt", mimeType = "application/octet-stream")] static private const FontXML:Class;
      [Embed(source = "../../assets/Font/8bit_0.png")] static private const FontPNG:Class;
      [Embed(source = "../../assets/Loading/loading.png")] static public const LoadingPNG:Class;
      [Embed(source = "../../assets/Levels/arcadeOverlay.png")] static public const ArcadeOverlayPNG:Class;
      
      [Embed(source = "../../assets/Levels/Level01/level01bg.png")] static public const Level1BackgroundPNG:Class;
      [Embed(source = "../../assets/Levels/Level02/level02bg.jpg")] static public const Level2BackgroundPNG:Class;
      [Embed(source = "../../assets/Levels/Level03/level03.png")] static public const Level3BackgroundPNG:Class;
      [Embed(source = "../../assets/Levels/Level03/level03_stein.png")] static public const Level3StonePNG:Class;
      [Embed(source = "../../assets/Levels/Level03/SteinAugenGlühen.png")] static public const Level3StoneGlowPNG:Class;
      [Embed(source = "../../assets/Levels/Level04/Level4mitRahmen.png")] static public const Level4BackgroundPNG:Class;
      [Embed(source = "../../assets/Levels/Level04/level4_palme.png")] static public const Level4PalmTreePNG:Class;
      [Embed(source = "../../assets/Levels/Level05/level05.png")] static public const Level5BackgroundPNG:Class;
      [Embed(source = "../../assets/Levels/Level06/level06.png")] static public const Level6BackgroundPNG:Class;
      [Embed(source = "../../assets/Loading/loading-screen.png")] static public const LoadingScreenPNG:Class;
      
      [Embed(source = "../../assets/Music/Ode to Joy (Short version found in Peggle).mp3")] static public const WinMusic:Class;
      [Embed(source = "../../assets/Sounds/Biss3.mp3")] static public const Bite:Class;
      
      [Embed(source="../../assets/Levels/arcadeoverlaytexture.xml", mimeType="application/octet-stream")] static private const ArcadeOverlayAtlasXML:Class
      [Embed(source = "../../assets/Levels/arcadeoverlaytexture.png")] static private const ArcadeOverlayAtlasPNG:Class;
      
      [Embed(source = "../../assets/Menus/Menu.xml", mimeType="application/octet-stream")] static private const MenuXML:Class;
      [Embed(source = "../../assets/Menus/Menu.png")] static private const MenuPNG:Class;
      
      [Embed(source = "../../assets/Levels/Scoring/Scoring.xml", mimeType="application/octet-stream")] static private const ScoringXML:Class;
      [Embed(source = "../../assets/Levels/Scoring/Scoring.png")] static private const ScoringPNG:Class;
      
      [Embed(source = "../../assets/Levels/LevelSelect/LevelSelect.xml", mimeType = "application/octet-stream")] static private const LevelSelectXML:Class;
      [Embed(source = "../../assets/Levels/LevelSelect/LevelSelect.png")] static private const LevelSelectPNG:Class;
      [Embed(source = "../../assets/Levels/LevelSelect/background.png")] static private const LevelSelectBGPNG:Class;
      [Embed(source = "../../assets/Levels/LevelSelect/tile-boss-locked.png")] static private const LevelSelectBossLockedPNG:Class;
      
      [Embed(source = "../../assets/Music/LevelMusikStufe1.mp3")] static private const LevelMusic1:Class;
      [Embed(source = "../../assets/Music/LevelMusikStufe2.mp3")] static private const LevelMusic2:Class;
      
      [Embed(source = "../../assets/Levels/LevelFrame640x480.png")] static private const LevelFramePNG:Class;
      
      // Particles
      [Embed(source = "../../assets/Particles/EggsplosionA.pex", mimeType = "application/octet-stream")] static public const EggsplosionA:Class;
      [Embed(source = "../../assets/Particles/EggsplosionB.pex", mimeType = "application/octet-stream")] static public const EggsplosionB:Class;
      [Embed(source = "../../assets/Particles/EggsplosionC.pex", mimeType = "application/octet-stream")] static public const EggsplosionC:Class;
      [Embed(source = "../../assets/Particles/EggsplosionGoldV2.pex", mimeType = "application/octet-stream")] static public const EggsplosionGold:Class;
      [Embed(source = "../../assets/Particles/EggsplosionRotten.pex", mimeType = "application/octet-stream")] static public const EggsplosionRotten:Class;
      [Embed(source = "../../assets/Particles/EggsplosionShuffle.pex", mimeType = "application/octet-stream")] static public const EggsplosionShuffle:Class;
      [Embed(source = "../../assets/Particles/EggsplosionGreen.pex", mimeType = "application/octet-stream")] static public const EggsplosionGreen:Class;
      
      public static var SnakeAtlas:TextureAtlas;
      public static var MenuAtlas:TextureAtlas;
      public static var ArcadeOverlayAtlas:TextureAtlas;
      public static var LevelSelectAtlas:TextureAtlas;
      public static var ScoringAtlas:TextureAtlas;
      public static var Level4Atlas:TextureAtlas;
      public static var Level6Atlas:TextureAtlas;
      public static var Level7Atlas:TextureAtlas;
      
      public static var UIOverlayTexture:Texture;
      public static var LevelSelectBGTexture:Texture;
      public static var LevelSelectBossLocked:Texture;
      public static var ComboParticleConfig:XML;
      public static var DrugParticleConfig:XML;
      public static var DrugParticleTexture:Texture;
      public static var EggsplosionParticleConfig:XML;
      public static var EggsplosionParticleTexture:Texture;
      public static var ArcadeBackground:Texture;
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
      
      public static const TILESIZE:int = 15;

      public static const DOWN:int = 0;
      public static const UP:int = 1;
      public static const LEFT:int = 2;
      public static const RIGHT:int = 3;
      
      public static const EGGZERO:int = 0;
      public static const EGGA:int = 1;
      public static const EGGB:int = 2;
      public static const EGGC:int = 3;
      public static const EGGROTTEN:int = 4;
      public static const EGGSHUFFLE:int = 5;
      public static const EGGGOLDEN:int = 6;
      
      public static var HQ:Boolean = false;
      public static var LEVELS:Array;     
    
      public static function init():void 
      {
        LEVELS = [Level1, Level2, Level3, Level4, Level5, Level6, Level7];
        TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmap(new FontPNG), XML(new FontXML)));              
        
        LevelMusic1Sound = new LevelMusic1;
        LevelMusic2Sound = new LevelMusic2;
        WinMusicSound = new WinMusic as Sound;
      }
      
      public static function loadArcadeGraphics():void {
        UIOverlayTexture = Texture.fromBitmap(new UIOverlayPNG);
        ArcadeBackground = Texture.fromBitmap(new ArcadeBackgroundPNG);
        ArcadeOverlayAtlas = new TextureAtlas(Texture.fromBitmap(new ArcadeOverlayAtlasPNG), XML(new ArcadeOverlayAtlasXML));
        
        loadLevelGraphics();
      }
      
      public static function loadMenuGraphics():void {
        MenuAtlas = new TextureAtlas(Texture.fromBitmap(new MenuPNG), XML(new MenuXML));       
      }
      
      public static function disposeMenuGraphics():void {
        MenuAtlas.dispose();
      }
      
      public static function loadScoringGraphics():void {
        ScoringAtlas = new TextureAtlas(Texture.fromBitmap(new ScoringPNG), XML(new ScoringXML));
      }
      
      public static function disposeScoringGraphics():void {
        ScoringAtlas.dispose();
      }
      
      public static function disposeArcadeGraphics():void {
        UIOverlayTexture.dispose();
        ArcadeBackground.dispose();
        ArcadeOverlayAtlas.dispose();
        disposeLevelGraphics();
      }
      
      public static function loadLevel1Graphics():void {
        Level1Background = Texture.fromBitmap(new Level1BackgroundPNG);
        loadLevelGraphics();
      }
      
      public static function disposeLevel1Graphics():void {
        Level1Background.dispose();
        disposeLevelGraphics();
      }
 
      public static function loadLevel2Graphics():void {
        Level2Background = Texture.fromBitmap(new Level2BackgroundPNG);
        loadLevelGraphics();
      }
      
      public static function disposeLevel2Graphics():void {
        Level2Background.dispose();
        disposeLevelGraphics();
      }     
      
      public static function loadLevel3Graphics():void {
        Level3Background = Texture.fromBitmap(new Level3BackgroundPNG);
        Level3Stone = Texture.fromBitmap(new Level3StonePNG);
        Level3StoneGlow = Texture.fromBitmap(new Level3StoneGlowPNG);
        loadLevelGraphics();
      }
      
      public static function disposeLevel3Graphics():void {
        Level3Background.dispose();
        Level3Stone.dispose();
        Level3StoneGlow.dispose();
        disposeLevelGraphics();
      }    
      
      public static function loadLevel4Graphics():void {
        //Level4Background = Texture.fromBitmap(new Level4BackgroundPNG);
        Level4Atlas = new TextureAtlas(Texture.fromBitmap(new Level4AtlasPNG), XML(new Level4AtlasXML));
        loadLevelGraphics();
      }
      
      public static function disposeLevel4Graphics():void {
        //Level4Background.dispose();
        Level4Atlas.dispose();
        disposeLevelGraphics();
      }      
      
      public static function loadLevel5Graphics():void {
        Level5Background = Texture.fromBitmap(new Level5BackgroundPNG);
        loadLevelGraphics();
      }
      
      public static function disposeLevel5Graphics():void {
        Level5Background.dispose();
        disposeLevelGraphics();
      }
      
      public static function loadLevel6Graphics():void {
        //Level6Background = Texture.fromBitmap(new Level6BackgroundPNG);
        Level6Atlas = new TextureAtlas(Texture.fromBitmap(new Level6AtlasPNG), XML(new Level6AtlasXML));
        loadLevelGraphics();
      }
      
      public static function disposeLevel6Graphics():void {
        //Level6Background.dispose();
        Level6Atlas.dispose();
        disposeLevelGraphics();
      }
      
      public static function loadLevelGraphics():void {
        SnakeAtlas = new TextureAtlas(Texture.fromBitmap(new SnakeTexturePNG), XML(new SnakeAtlasXML));   
        LevelFrame = Texture.fromBitmap(new LevelFramePNG);
                
        DrugParticleConfig = XML(new DrugsParticleXML);
        DrugParticleTexture = Texture.fromBitmap(new DrugsParticlePNG);     
        ComboParticleConfig = XML(new ComboParticleXML);
        
        EggsplosionParticleConfig = XML(new EggsplosionXML);
        EggsplosionParticleTexture = Texture.fromBitmap(new EggsplosionPNG);
        
//        WinMusicSound = new WinMusic as Sound;   
        BiteSound = new Bite as Sound;        
      }
      
      public static function disposeLevelGraphics():void {
        SnakeAtlas.dispose();
        LevelFrame.dispose();
        
        DrugParticleConfig = null;
        DrugParticleTexture.dispose();
        ComboParticleConfig = null;       
        
        EggsplosionParticleConfig = null;
        EggsplosionParticleTexture.dispose();
        
        //WinMusicSound = null;        
      }
      
      public static function loadLevel7Graphics():void {
        //Level6Background = Texture.fromBitmap(new Level6BackgroundPNG);
        Level7Atlas = new TextureAtlas(Texture.fromBitmap(new Level7AtlasPNG), XML(new Level7AtlasXML));
        loadLevelGraphics();
      }
      
      public static function disposeLevel7Graphics():void {
        //Level6Background.dispose();
        Level7Atlas.dispose();
        disposeLevelGraphics();
      }
      
      public static function loadLevelSelectGraphics():void {          
        LevelSelectAtlas = new TextureAtlas(Texture.fromBitmap(new LevelSelectPNG), XML(new LevelSelectXML));    
        LevelSelectBGTexture = Texture.fromBitmap(new LevelSelectBGPNG);
        LevelSelectBossLocked = Texture.fromBitmap(new LevelSelectBossLockedPNG);
      }
      
      public static function disposeLevelSelectGraphics():void {
        LevelSelectAtlas.dispose();
        LevelSelectBGTexture.dispose();
        LevelSelectBossLocked.dispose();
      }
        
    }

}
