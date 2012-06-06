package UI 
{
  import starling.display.Image;
	import starling.display.Sprite;
  import starling.textures.Texture;
  import engine.AssetRegistry;
	
	/**
     * ...
     * @author 
     */
  public class HUD extends Sprite 
  {
        
    public function HUD() 
    {
      var overlay:Image = new Image(AssetRegistry.UIOverlayTexture);
      addChild(overlay);
    } 
  }

}