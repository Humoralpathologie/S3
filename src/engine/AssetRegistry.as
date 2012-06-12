package engine 
{
    import flash.media.Sound;
    import starling.text.BitmapFont;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    import starling.text.TextField;
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
      [Embed(source = "../../assets/Particles/drugs_particle.png")] private static const DrugsParticlePNG:Class;
      [Embed(source = "../../assets/Levels/arcade.png")] private static const ArcadeBackgroundPNG:Class;
      [Embed(source = "../../assets/Font/8bit.fnt", mimeType = "application/octet-stream")] static private const FontXML:Class;
      [Embed(source = "../../assets/Font/8bit_0.png")] static private const FontPNG:Class;
      [Embed(source = "../../assets/Loading/loading.png")] static public const LoadingPNG:Class;
      [Embed(source = "../../assets/Levels/arcadeOverlay.png")] static public const ArcadeOverlayPNG:Class;
      [Embed(source = "../../assets/Levels/level01bg.png")] static public const Level1BackgroundPNG:Class;
      
      //[Embed(source = "../../assets/Music/Ode to Joy (Short version found in Peggle).mp3")] static public const WinMusic:Class;
      [Embed(source = "../../assets/Sounds/Biss3.mp3")] static public const Bite:Class;
      
      [Embed(source="../../assets/Levels/arcadeoverlaytexture.xml", mimeType="application/octet-stream")] static private const ArcadeOverlayAtlasXML:Class
      [Embed(source = "../../assets/Levels/arcadeoverlaytexture.png")] static private const ArcadeOverlayAtlasPNG:Class;
      
      [Embed(source = "../../assets/Menus/Menu.xml", mimeType="application/octet-stream")] static private const MenuXML:Class;
      [Embed(source = "../../assets/Menus/Menu.png")] static private const MenuPNG:Class;
      
      [Embed(source = "../../assets/Levels/LevelSelect/LevelSelect.xml", mimeType = "application/octet-stream")] static private const LevelSelectXML:Class;
      [Embed(source = "../../assets/Levels/LevelSelect/LevelSelect.png")] static private const LevelSelectPNG:Class;
      [Embed(source = "../../assets/Levels/LevelSelect/background.png")] static private const LevelSelectBGPNG:Class;
      [Embed(source = "../../assets/Levels/LevelSelect/tile-boss-locked.png")] static private const LevelSelectBossLockedPNG:Class;
      
      [Embed(source = "../../assets/Music/LevelMusikStufe1.mp3")] static private const LevelMusic1:Class;
      [Embed(source = "../../assets/Music/LevelMusikStufe2.mp3")] static private const LevelMusic2:Class;
      
      public static var SnakeAtlas:TextureAtlas;
      public static var MenuAtlas:TextureAtlas;
      public static var ArcadeOverlayAtlas:TextureAtlas;
      public static var LevelSelectAtlas:TextureAtlas;
      
      public static var UIOverlayTexture:Texture;
      public static var LevelSelectBGTexture:Texture;
      public static var LevelSelectBossLocked:Texture;
      public static var ComboParticleConfig:XML;
      public static var DrugParticleConfig:XML;
      public static var DrugParticleTexture:Texture;
      public static var ArcadeBackground:Texture;
      public static var ArcadeOverlay:Texture;
      public static var Level1Background:Texture;
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
    
      public static function init():void 
      {
        SnakeAtlas = new TextureAtlas(Texture.fromBitmap(new SnakeTexturePNG), XML(new SnakeAtlasXML));   
        
        TextField.registerBitmapFont(new BitmapFont(SnakeAtlas.getTexture("8bit_0"), XML(new FontXML)));       
        MenuAtlas = new TextureAtlas(Texture.fromBitmap(new MenuPNG), XML(new MenuXML));
        
        LevelMusic1Sound = new LevelMusic1;
        LevelMusic2Sound = new LevelMusic2;
      }
      
      public static function loadArcadeGraphics():void {
        UIOverlayTexture = Texture.fromBitmap(new UIOverlayPNG);
        ArcadeBackground = Texture.fromBitmap(new ArcadeBackgroundPNG);
        ArcadeOverlayAtlas = new TextureAtlas(Texture.fromBitmap(new ArcadeOverlayAtlasPNG), XML(new ArcadeOverlayAtlasXML));
        
        loadLevelGraphics();
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
      
      public static function loadLevelGraphics():void {
        DrugParticleConfig = XML(new DrugsParticleXML);
        DrugParticleTexture = Texture.fromBitmap(new DrugsParticlePNG);     
        ComboParticleConfig = XML(new ComboParticleXML);
        
//        WinMusicSound = new WinMusic as Sound;   
        BiteSound = new Bite as Sound;        
      }
      
      public static function disposeLevelGraphics():void {
        DrugParticleConfig = null;
        DrugParticleTexture.dispose();
        ComboParticleConfig = null;        
        
        WinMusicSound = null;        
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
