package engine 
{
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
	/**
     * ...
     * @author 
     */
    public class AssetRegistry 
    {
      [Embed(source = "../../assets/Snake/Snake.png")] static private const SnakeTexturePNG:Class;
      [Embed(source = "../../assets/UI/UIOverlay.png")] static private const UIOverlayPNG:Class;
      [Embed(source = "../../assets/Snake/Snake.xml", mimeType="application/octet-stream")] static private const SnakeAtlasXML:Class;
      
      public static var SnakeAtlas:TextureAtlas;
      public static var UIOverlayTexture:Texture;
      
      public static const TILESIZE:int = 15;

      public static const DOWN:int = 0;
      public static const UP:int = 1;
      public static const LEFT:int = 2;
      public static const RIGHT:int = 3;
      
      public static const EGGZERO:int = 0;
      public static const EGGA:int = 1;
      public static const EGGB:int = 2;
      public static const EGGC:int = 3;
    
      public function AssetRegistry() 
      {
        
        UIOverlayTexture = Texture.fromBitmap(new UIOverlayPNG);
        
        var texture:Texture = Texture.fromBitmap(new SnakeTexturePNG);
        SnakeAtlas = new TextureAtlas(texture, XML(new SnakeAtlasXML));
      }
        
    }

}