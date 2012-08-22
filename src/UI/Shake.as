package UI
{
    import flash.printing.PrintMethod;
    import starling.animation.IAnimatable;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.EventDispatcher;
  
  /**
   * ...
   * @author
   */
  public class Shake extends EventDispatcher implements IAnimatable
  {
    private var _intensity:int;
    private var _duration:Number;
    private var _levelStage:Sprite;
    
    public function Shake(levelStage:Sprite, intensity:int, duration:Number) {
      _intensity = intensity;
      _duration = duration;
      _levelStage = levelStage;
    }
    public function advanceTime(time:Number):void {
      _duration -= time;
      if (_duration <= 0) {
         dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
      } else {
        _levelStage.x += Math.random() * _intensity - int (_intensity / 2);
        _levelStage.y += Math.random() * _intensity - int (_intensity / 2);
      }
    }
    
    public function get duration():int {
      return _duration;
    }
    public function set duration(value:int):void {
      _duration = value;
    }
  }
}