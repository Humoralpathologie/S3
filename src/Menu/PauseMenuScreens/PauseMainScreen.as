package Menu.PauseMenuScreens
{
  import Level.LevelState;
  import org.josht.starling.foxhole.controls.Screen;
  import org.josht.starling.foxhole.controls.Slider;
  import starling.display.Quad;
  import org.osflash.signals.ISignal;
  
  /**
   * ...
   * @author
   */
  public class PauseMainScreen extends Screen
  {
    private var _levelstate:LevelState;
    private var _greyBox:Quad;
    private var _zoomSlider:Slider;
    
    public function PauseMainScreen(levelstate:LevelState)
    {
      super();
      _levelstate = levelstate;

       _greyBox = new Quad(710, 450, 0);
      _greyBox.x = 125;
      _greyBox.y = 95;
      _greyBox.alpha = 0.3;
      addChild(_greyBox);
      
      _zoomSlider = new Slider;
      _zoomSlider.x = _greyBox.x + 50;
      _zoomSlider.width = _greyBox.width - 100;
      _zoomSlider.y = _greyBox.y + 50;
      _zoomSlider.minimum = 0.5;
      _zoomSlider.maximum = 5;
      _zoomSlider.value = _levelstate.zoom;
      _zoomSlider.onChange.add(function(slider:Slider) {
        _levelstate.zoom = slider.value;
        _levelstate.updateCamera();
        _zoomSlider.validate(); // Should not be needed, but somehow is.
      });
      addChild(_zoomSlider);    
    }
    
  }

}