package Menu.PauseMenuScreens
{
  import Level.LevelState;
  import org.josht.starling.foxhole.controls.Button;
  import org.josht.starling.foxhole.controls.Screen;
  import org.josht.starling.foxhole.controls.Slider;
  import starling.display.Quad;
  import org.osflash.signals.ISignal;
  import engine.StageManager;
  import Menu.MainMenu;
  import flash.utils.*;
  
  /**
   * ...
   * @author
   */
  public class PauseMainScreen extends Screen
  {
    private var _levelstate:LevelState;
    private var _greyBox:Quad;
    private var _zoomSlider:Slider;
    private var _backButton:Button;
    private var _restartButton:Button;
    
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
      
      _backButton = new Button();
      _backButton.label = "Back to Menu";
      _backButton.width = 400;
      _backButton.height = 80;
      _backButton.x = _greyBox.x + (_greyBox.width - _backButton.width) / 2;
      _backButton.y = _zoomSlider.y + 100;
      _backButton.onRelease.add(function(button:Button) {
        StageManager.switchStage(MainMenu);
      });
      
      _restartButton = new Button();
      _restartButton.label = "Restart Level";
      _restartButton.width = 400;
      _restartButton.height = 80;
      _restartButton.x = _backButton.x;
      _restartButton.y = _backButton.y + _backButton.height + 40;
      _restartButton.onRelease.add(function(button:Button) {
        StageManager.switchStage(Class(getDefinitionByName(getQualifiedClassName(levelstate))));
      });      
          
      addChild(_backButton);
      addChild(_restartButton);
      
      this.validate();
    }
    
  }

}