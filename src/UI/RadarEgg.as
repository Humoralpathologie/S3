package UI 
{
	import starling.display.Image;
	import starling.textures.Texture;
  import engine.AssetRegistry;
  import starling.textures.TextureSmoothing;
	
	/**
     * ...
     * @author 
     */
  public class RadarEgg extends Image 
  {
    private var _type:int;
    
    public function RadarEgg(type:int = 0)//AssetRegistry.EGGZERO)
    {
      super(AssetRegistry.SnakeAtlas.getTexture("radar_green"));      
      this.type = type;              
    }
    
    public function set type(value:int):void {
      _type = value;
      switch(_type) {
        case AssetRegistry.EGGA:
            texture = AssetRegistry.SnakeAtlas.getTexture("radar_a");
            break;
        case AssetRegistry.EGGB:
            texture = AssetRegistry.SnakeAtlas.getTexture("radar_b");
            break;
        case AssetRegistry.EGGC:
            texture = AssetRegistry.SnakeAtlas.getTexture("radar_c");
            break;
        case AssetRegistry.EGGGOLDEN:
            texture = AssetRegistry.SnakeAtlas.getTexture("radar_gold");
            break;
        case AssetRegistry.EGGSHUFFLE:
            texture = AssetRegistry.SnakeAtlas.getTexture("radar_shuffle");
            break;           
        case AssetRegistry.EGGZERO:
            texture = AssetRegistry.SnakeAtlas.getTexture("radar_green");
            break;        
        case AssetRegistry.EGGROTTEN:
            texture = AssetRegistry.SnakeAtlas.getTexture("radar_rotten");
            break;                   
      }
      smoothing = TextureSmoothing.NONE;
    }
    
  }

}