package Menu.SettingsScreens
{
  import org.josht.starling.foxhole.controls.Screen;
  import org.josht.starling.foxhole.controls.ToggleSwitch;
  import org.osflash.signals.ISignal;
  import starling.display.Button;
  import starling.display.Quad;
  import engine.AssetRegistry;
  import org.osflash.signals.Signal;
  import starling.events.Event;
  import starling.text.TextField;
  import starling.utils.Color;
  import org.josht.starling.foxhole.controls.Slider;
  import engine.SaveGame;
  
  /**
   * ...
   * @author
   */
  public class BetaSettingsScreen extends Screen
  {
    private var _greyBox:Quad;
    private var _mainButton:Button;
    private var _onMainSelect:Signal = new Signal(BetaSettingsScreen);
    private var _heading:TextField;
    
    private var _snakeSpeedSlider:Slider;
    private var _snakeSpeedHeading:TextField;
    private var _currentSpeed:TextField;
    
    public function BetaSettingsScreen()
    {
      super();
    }
    
    override protected function initialize():void {
      _greyBox = new Quad(710, 450, Color.BLACK);
      _greyBox.alpha = 0.7;
      _greyBox.x = 65 + 60;
      _greyBox.y = 40 + 30;
      
      addChild(_greyBox);      
      
      _heading = new TextField(_greyBox.width, 50, "Beta Settings", "kroeger 06_65", 50, Color.WHITE);
      _heading.x = _greyBox.x;
      _heading.y = _greyBox.y;
      addChild(_heading);
      
      _mainButton = new Button(AssetRegistry.MenuAtlasAlpha.getTexture("arrow_reduced"));
      _mainButton.x = _greyBox.x - _mainButton.width;
      _mainButton.y = _greyBox.y;
      var that:BetaSettingsScreen = this;
      _mainButton.addEventListener(Event.TRIGGERED, function(event:Event):void {
        onMainSelect.dispatch(that);
      });
      addChild(_mainButton);
      
      addSlider();
    }
    
    
    private function addSlider():void {
      _snakeSpeedHeading = new TextField(_greyBox.width, 50, "Snake Default Speed","kroeger 06_65", 40, Color.WHITE);
      _snakeSpeedHeading.x = _greyBox.x;
      _snakeSpeedHeading.y = _heading.y + _heading.height;
      addChild(_snakeSpeedHeading);
      
      _snakeSpeedSlider = new Slider();
      _snakeSpeedSlider.minimum = 1;
      _snakeSpeedSlider.maximum = 20;
      _snakeSpeedSlider.width = _greyBox.width - 100;
      _snakeSpeedSlider.x = _greyBox.x + 50;
      _snakeSpeedSlider.y = _snakeSpeedHeading.y + _snakeSpeedHeading.height;
      _snakeSpeedSlider.step = 1;
      _snakeSpeedSlider.value = SaveGame.startSpeed;
      _snakeSpeedSlider.validate();
      addChild(_snakeSpeedSlider);      
      
      _currentSpeed = new TextField(_greyBox.width, 50, "Current Speed: " + String(SaveGame.startSpeed), "kroeger 06_65", 40, Color.BLACK);
      _currentSpeed.x = _greyBox.x;
      _currentSpeed.y = _snakeSpeedSlider.y; // + _snakeSpeedSlider.height;
      _currentSpeed.touchable = false;
      addChild(_currentSpeed);
      
      _snakeSpeedSlider.onChange.add(function(slider:Slider):void {
        _currentSpeed.text = "Current Speed: " + slider.value;
        SaveGame.startSpeed = slider.value;
      });
      
    }
    
    public function get onMainSelect():Signal 
    {
      return _onMainSelect;
    }
  
  }

}