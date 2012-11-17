package engine
{
  import starling.display.Sprite;
  import starling.events.Event;
  
  /**
   * A stage managed by... the StageManager!
   * @author Roger Braun
   */
  // This class was a stupid idea.
  // Not that stupid after all!
  public class ManagedStage extends Sprite
  {
    public static const CLOSING:String = "closing";
    public static const SHOWING:String = "showing";
    public static const SWITCHING:String = "switching";
    
    public var unscaled = false;
    
    public function ManagedStage()
    {
      super();
    }
    
    override public function dispose():void {
      super.dispose();
      dispatchEvent(new Event(ManagedStage.CLOSING, true));
    }
  }

}