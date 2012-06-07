package engine 
{
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
      [Embed(source = "../../assets/Particles/drugs_particle.png")] private static const DrugsParticlePNG:Class;
      [Embed(source = "../../assets/Levels/arcade.png")] private static const ArcadeBackgroundPNG:Class;
      [Embed(source = "../../assets/Font/8bit.fnt", mimeType = "application/octet-stream")] static private const FontXML:Class;
      [Embed(source = "../../assets/Font/8bit_0.png")] static private const FontPNG:Class;
      
      public static var SnakeAtlas:TextureAtlas;
      public static var UIOverlayTexture:Texture;
      public static var DrugParticleConfig:XML;
      public static var DrugParticleTexture:Texture;
      public static var ArcadeBackground:Texture;
      
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
    
      public static function init():void 
      {
        
        UIOverlayTexture = Texture.fromBitmap(new UIOverlayPNG);
        ArcadeBackground = Texture.fromBitmap(new ArcadeBackgroundPNG);
        
        var texture:Texture = Texture.fromBitmap(new SnakeTexturePNG);
        SnakeAtlas = new TextureAtlas(texture, XML(new SnakeAtlasXML));
        
        DrugParticleConfig = XML(new DrugsParticleXML);
        DrugParticleTexture = Texture.fromBitmap(new DrugsParticlePNG);
        
        TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmap(new FontPNG()), XML(new FontXML)));
        
      }
        
    }

}